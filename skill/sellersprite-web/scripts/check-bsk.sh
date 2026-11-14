#!/usr/bin/env bash
# Read-only self-check for the bsk CLI and the browser-skill.
# Exit codes: 0 ok, 1 outdated/mismatch, 2 browser-skill not found, 3 bsk CLI missing.
set -u

MIN_CLI="${BSK_MIN_VERSION:-0.5.0}"
MIN_SKILL="${BSK_SKILL_MIN_VERSION:-0.5.0}"
status=0

ver_ge() {
  # ver_ge A B -> exit 0 when A >= B (dotted numeric versions)
  awk -v a="$1" -v b="$2" 'BEGIN {
    n=split(a,A,"."); m=split(b,B,".");
    max=n>m?n:m;
    for(i=1;i<=max;i++){
      x=(i<=n?A[i]:0)+0; y=(i<=m?B[i]:0)+0;
      if(x>y) exit 0;
      if(x<y) exit 1;
    }
    exit 0;
  }'
}

# 1. bsk CLI
if ! command -v bsk >/dev/null 2>&1; then
  echo "bsk CLI: 未安装 -> 先安装 bsk"
  exit 3
fi
cli_version="$(bsk --version 2>/dev/null | awk '{print $NF}')"
if [ -z "$cli_version" ]; then
  echo "bsk CLI: 版本未知（bsk --version 失败）"
  exit 3
fi
if ver_ge "$cli_version" "$MIN_CLI"; then
  echo "bsk CLI: ${cli_version}（最低 ${MIN_CLI}）ok"
else
  echo "bsk CLI: ${cli_version}（最低 ${MIN_CLI}）过旧 -> bsk update"
  status=1
fi

# 2. browser-skill: check Cherry Studio first, then known harness dirs, then bsk's list
candidates=""
add_dir() {
  [ -n "${1:-}" ] && [ -d "$1" ] && candidates="$candidates
$1"
}
add_dir "${BSK_SKILLS_DIR:-}"
add_dir "$HOME/Library/Application Support/CherryStudio/Data/Skills"
add_dir "$HOME/.agents/skills"
add_dir "$HOME/.claude/skills"
add_dir "$HOME/.cursor/skills"
if command -v bsk >/dev/null 2>&1; then
  while IFS= read -r d; do add_dir "$d"; done < <(
    bsk install-skill --list --json 2>/dev/null |
      sed -n 's/.*"skills_dir"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p'
  )
fi

skill_file=""
OLDIFS="$IFS"
IFS='
'
for dir in $candidates; do
  [ -n "$dir" ] || continue
  for f in "$dir/browser-skill/SKILL.md" "$dir/skill/SKILL.md"; do
    if [ -f "$f" ] && grep -q '^name:[[:space:]]*browser-skill' "$f"; then
      skill_file="$f"
      break 2
    fi
  done
  found="$(find "$dir" -maxdepth 2 -name SKILL.md -print 2>/dev/null | while IFS= read -r f; do
    if grep -q '^name:[[:space:]]*browser-skill' "$f"; then
      printf '%s\n' "$f"
      break
    fi
  done)"
  if [ -n "$found" ]; then
    skill_file="$found"
    break
  fi
done
IFS="$OLDIFS"

if [ -z "$skill_file" ]; then
  echo "browser-skill: 未找到（检查了 Cherry/Codex/Claude/Cursor 的 skills 目录；可用 BSK_SKILLS_DIR 指定）"
  exit 2
fi

skill_version="$(awk '/^---[[:space:]]*$/{n++; next} n==1 && /^version:[[:space:]]*/{sub(/^version:[[:space:]]*/, ""); print; exit}' "$skill_file")"
skill_is_versioned=1
if [ -z "$skill_version" ]; then
  # browser-skill 0.5.0 不再写 frontmatter version；用工作流标记判断兼容性。
  if grep -q 'bsk open' "$skill_file" && grep -q 'bsk close' "$skill_file"; then
    skill_is_versioned=0
    skill_version="0.5.0-compatible"
    echo "browser-skill: ${skill_version}（无 version 字段；检测到 bsk open/close）ok（${skill_file}）"
  else
    echo "browser-skill: 版本未知且不包含 0.5 工作流标记（${skill_file}）-> 重新安装/更新 browser-skill"
    exit 2
  fi
fi
if [ "$skill_is_versioned" = 1 ]; then
  if ver_ge "$skill_version" "$MIN_SKILL"; then
    echo "browser-skill: ${skill_version}（最低 ${MIN_SKILL}）ok（${skill_file}）"
  else
    echo "browser-skill: ${skill_version}（最低 ${MIN_SKILL}）过旧（${skill_file}）-> 重新安装/更新 browser-skill"
    status=1
  fi
fi

# 3. Consistency and optional latest-release check
if [ "$skill_is_versioned" = 1 ] && [ "$cli_version" != "$skill_version" ]; then
  echo "版本不一致: bsk CLI $cli_version vs browser-skill $skill_version -> 更新较旧的一方"
  status=1
fi

if [ "${BSK_SKIP_UPDATE_CHECK:-0}" != "1" ]; then
  latest="$(bsk update --check --json 2>/dev/null |
    sed -n 's/.*"latest_version"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -1)"
  if [ -n "$latest" ] && [ "$latest" != "null" ]; then
    echo "最新 bsk: $latest"
    if ! ver_ge "$cli_version" "$latest"; then
      echo "bsk CLI 有更新: $cli_version -> ${latest}（bsk update）"
      status=1
    fi
    if [ "$skill_is_versioned" = 1 ] && ! ver_ge "$skill_version" "$latest"; then
      echo "browser-skill 有更新: $skill_version -> ${latest}（重新安装/更新 browser-skill）"
      status=1
    fi
  fi
fi

# 4. Browser extension version (warning only; does not change exit status)
if command -v bsk >/dev/null 2>&1; then
  status_json="$(bsk status --json 2>/dev/null)"
  ext_version="$(printf '%s\n' "$status_json" | sed -n 's/.*"extension_version"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -1)"
  ext_protocol="$(printf '%s\n' "$status_json" | sed -n 's/.*"extension_protocol_version"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -1)"
  skew="$(printf '%s\n' "$status_json" | sed -n 's/.*"version_skew"[[:space:]]*:[[:space:]]*\([a-z]*\).*/\1/p' | head -1)"
  if [ "$skew" = "true" ]; then
    echo "browser extension: ${ext_version:-未知}（与 bsk CLI 不一致）-> 在 Chrome 里更新 BrowserSkill 扩展；bsk read 可能不可用，改用 bsk extract/bsk evaluate"
  else
    echo "browser extension: ${ext_version:-未知}（protocol ${ext_protocol:-?}）ok"
  fi
fi

exit "$status"
