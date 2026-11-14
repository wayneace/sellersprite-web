#!/usr/bin/env bash
# Development-only documentation check. Usage: bash scripts/check-docs.sh [page]
set -u
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PAGES=(
  competitor-lookup product-research keyword-research keyword-miner keyword-reverse traffic-source
  market-research aba-research product-store keyword-comparison traffic-extend
  keyword-conversion-rate keyword-store real-time-bidding
)
URLS=(
  /v3/competitor-lookup /v3/product-research /v2/keyword-research /v3/keyword-miner
  /v3/keyword-reverse /v3/reversing /v3/market-research /v3/aba-research /v3/product-store
  /v3/keyword-comparison /v3/traffic/extend /v3/keyword-conversion-rate /v3/keyword-store
  /v3/real-time-bidding
)
status=0

check_page() {
  local p="$1"
  local f="$ROOT/skill/sellersprite-web/references/pages/$p.md"
  if [ ! -f "$f" ]; then
    echo "MISSING $f"
    status=1
    return
  fi
  local n
  n="$(grep -c '^## [0-9][0-9]*\.' "$f")"
  if [ "$n" -ne 13 ]; then
    echo "SECTIONS $p: $n != 13"
    status=1
  fi
  grep -q '^## 13\. 验证记录' "$f" || { echo "NO VERIFICATION SECTION $p"; status=1; }
  grep -q 'https://github.com/wayneace/sellersprite-web' "$f" || { echo "NO VERIFICATION LINK $p"; status=1; }
}

if [ "$#" -gt 0 ]; then
  check_page "$1"
else
  for p in "${PAGES[@]}"; do check_page "$p"; done
  for url in "${URLS[@]}"; do
    grep -q "$url" "$ROOT/skill/sellersprite-web/SKILL.md" || { echo "SKILL MISSING $url"; status=1; }
    grep -q "$url" "$ROOT/skill/sellersprite-web/references/site-map.md" || { echo "SITE-MAP MISSING $url"; status=1; }
    grep -q "$url" "$ROOT/README.md" || { echo "README MISSING $url"; status=1; }
  done
fi
exit "$status"
