# 冷启动验收

- 日期: 2026-11-12
- 执行者: 无本项目上下文的 fresh subagent（general-purpose，session `<session>`）
- 输入: 只给 skill 路径 `<repo>` 和任务；明确禁止 `sellersprite-web-cli` / `ssw` / `python3 scripts/ssw.py`

## 任务

```text
You are a fresh agent. Use only the skill at <repo>.
Do not use sellersprite-web-cli, ssw, python3 scripts/ssw.py, or any old CLI.
Task: 在选产品页查 "yoga mat" 近 30 天销量最高的 10 个商品，报告总数、关键列、URL、站点、查询条件。
Read SKILL.md first and follow it. In your final report, list every shell command you ran.
```

## 结果

**通过。** 子代理：

- 选对页面 `/v3/product-research`，先读 `SKILL.md`，再读页面文档；
- 用 bsk session + `cooperate wait/sync` + `navigate` + `observe` + `fill` + `click` 完成查询；
- 用 `scripts/read-table.js` 读到 60 行（`el-table-store`）；
- 报告包含 URL、站点 US、数据月份「最近30天」、查询条件、total（分页 2000 / 页面 5000+）、读取行数、页码；
- 输出 Top10 关键列（ASIN、标题、品牌、BSR、销量(父)、增长率、销售额、子体销量、变体数、价格、评分/评分数、FBA、毛利率）；
- **没有**调用旧 CLI / `ssw` / Python 适配层；
- 结束时 `bsk session stop <session>`。

查询结果摘要：关键词 `yoga mat`，US，最近30天，模糊匹配，按销量(父)降序；Top1 `B0BVFDH9CP`（SINOPHANT Leggings，销量 108,916），Top10 第 10 名 `B07H9PZDQW`（Gaiam Yoga Mat，销量 51,411）；第 11 名 51,050，Top10 截断点明确。

## 它跑过的命令（去重后的关键序列）

```sh
ls -la <repo>
bsk session start --json
bsk cooperate wait --session <session> --json
bsk cooperate sync --session <session> --json
bsk --help 2>&1 | head -60
bsk reload --session <session> --json
bsk tab --help 2>&1 | head -40
bsk browsers --json 2>&1 | head -40
bsk tab list --session <session> --json
bsk navigate "https://www.sellersprite.com/v3/product-research" --session <session> --json
bsk observe --session <session> --max-tokens 4000
bsk observe --session <session> --max-tokens 4000 --cursor <cursor>
bsk click "@e36" --session <session> --json
bsk cooperate wait --session <session> --json
bsk cooperate sync --session <session> --json
bsk click "@e273" --session <session> --context "<ctx>" --observation "<obs>" --json
bsk fill "@e411" --value "yoga mat" --session <session> --context "<ctx>" --observation "<obs>" --json
bsk click "@e442" --session <session> --context "<ctx>" --observation "<obs>" --json
bsk observe --session <session> --max-tokens 1500
bsk extract table --session <session> --json
bsk extract discover --session <session> --json
bsk evaluate "$(cat scripts/read-table.js)" --session <session> --context "<ctx>" --observation "<obs>" --json
bsk observe --session <session> --max-tokens 8000
bsk screenshot --session <session> --json
bsk snapshot --session <session>
bsk focus "@e498" --session <session> --context "<ctx>" --observation "<obs>" --json
bsk press "Enter" --session <session> --context "<ctx>" --observation "<obs>" --json
bsk evaluate "JSON.stringify(Array.from(document.querySelectorAll('.el-select'))...)" --session <session> --context "<ctx>" --observation "<obs>" --json
bsk click ".filter-sort-popover .el-select" --session <session> --context "<ctx>" --observation "<obs>" --json
bsk click ".filter-sort-popover > .el-select:first-child" --session <session> --context "<ctx>" --observation "<obs>" --json
bsk click ".el-select-dropdown:not([style*='display: none']) .el-select-dropdown__item:nth-child(2)" --session <session> --context "<ctx>" --observation "<obs>" --json
bsk evaluate "(()=>{const el=Array.from(document.querySelectorAll('label')).find(l=>l.innerText.includes('展示所有变体')); ...})()" --session <session> --context "<ctx>" --observation "<obs>" --json
bsk click ".el-checkbox[aria-describedby='el-tooltip-9207']" --session <session> --context "<ctx>" --observation "<obs>" --json
bsk evaluate "$(cat scripts/read-table.js)" --session <session> --context "<ctx>" --observation "<obs>" --json
bsk evaluate "$(cat scripts/read-page-state.js)" --session <session> --context "<ctx>" --observation "<obs>" --json
bsk session stop <session> --json
```

说明：以上是全部**不同类型的命令**；重复的 `cooperate sync`、重复 `observe` 和只读 JSON 解析已折叠，每一类都实际执行过。完整原始调用（含每次 sync 与重试）见子代理 transcript。

## 失败点与恢复

1. **第一次 `bsk click "@e36"` 没带 context/observation** → 报权限错误；子代理随后 `cooperate sync` 并带参重试。符合 workflow 的共享标签页规则。
2. **`bsk fill "@e411" "yoga mat"` 缺少 `--value`** → 参数错误；改用 `--value` 成功。workflow 当时也缺 `--value`，已在最终审查中修复为 `bsk fill "@eN" --value "..."`。
3. **旧 ref 坐标点击落到底部**（排序/复选框附近）→ 子代理重新 observe，改用 CSS 选择器和 `focus`+`Enter`。没有盲重试。
4. **排序下拉难点开**：`.el-select` 有多个、被 tooltip/控制浮层遮挡；最终用 `.filter-sort-popover` 收窄并 `focus`+`Enter`。这是文档缺口。
5. **变体口径歧义**：子代理取消「展示所有变体」后 URL 出现 `symbolFlag=false`，它把 false 解释成「唯一畅销变体」，与旧知识（true=唯一畅销变体）冲突。文档需要提醒以复选框回显为准。

## 对应修改

- `references/pages/product-research.md`：
  - 排序小节补充「排序控件在结果区工具栏；被浮层遮挡时先 scroll-to/重新 observe，必要时 focus+Enter，不要连点」。
  - 变体口径改为「以页面复选框回显为准，不要只凭 URL 判断」，并记录 `symbolFlag=false` 的冷启动观察。
- `references/troubleshooting.md`：新增「下拉/排序点不开或选项没出现」一行。

## 结论

冷启动验收通过：fresh agent 能只用本 skill 选对页面、按循环操作、用片段读到数据，并给出带出处（URL/站点/月份/条件/总数/行数/页码）的报告；没有退回旧 CLI。发现的排序下拉与变体口径缺口已回写文档。未重跑（无严重失败）。
