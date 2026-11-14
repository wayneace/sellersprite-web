# 关键词转化率（keyword conversion rate）

## 1. 用途

按关键词查看搜索转化率、点击转化率、PPC 竞价、CPA、产品均价、ACOS、广告预算和点击前三 ASIN，用来识别高转化词、控制广告成本、判断细分市场的转化难度。

- 适合：筛选高转化关键词；对比不同词的 CPA/ACOS；看一个词需要多少广告预算；找“低竞价高转化”的词。
- 不适合：看单个 ASIN 的全部流量词（用「关键词反查」）；批量拓词（用「关键词挖掘」/「拓展流量词」）；看市场整体规模（用「选市场」）。

## 2. URL 与导航

- URL：`https://www.sellersprite.com/v3/keyword-conversion-rate`
- 导航：工作台「产品」→ 关键词优化 → **关键词转化率**。
- 查询后 URL 形如
  `https://www.sellersprite.com/v3/keyword-conversion-rate?marketId=1&reverseType=W&bidMatchType=1&keywordMatchType=all&matchType=1&keywordList=lunch%20box`
- 过滤条件会写入 URL（实测 `minSearches=999999999`）；报告仍以页面回显为准。

## 3. 站点选择

- 查询栏最左侧是站点下拉（默认「美国站」），可切加拿大等站点；旁边是「按周」/「按月」选择器。
- US 用 USD；CA 用 CAD。切换站点/周期后重新查询并核对币种。
- 本页 US 已完整验证；CA 只确认站点控件，未验证 CA 数据/币种。

## 4. 页面结构

1. **子导航**：关键词挖掘 / 关键词反查 / 流量词对比 / 拓展流量词 / 关键词转化率 / 实时查竞价 / 关键词收录 / 关键词词库。
2. **查询栏**：站点下拉、周期（按周/按月）、关键词输入（最多200个）、清除、立即查询、查询历史、示例词。
3. **搜索结果过滤**面板：搜索量、点击量、购买量、搜索转化率、点击转化率、PPC竞价、CPA、产品均价、ACOS、点击占比、转化占比、词组个数、排除/包含关键词；开始筛选、重置条件。
4. **结果区**：`搜索结果数`、`更新至：2026第44周(...)`、表格、分页。
5. **结果工具栏**：加入词库、全部加入词库、导出、复制。

## 5. 必填输入与可选筛选

- 关键词：至少 1 个，最多 **200** 个；支持回车提交单个词组，或从 Excel 按列复制粘贴。
- 过滤面板的关键词输入是另一个框，最多 1000 个，用于在结果中再筛选。
- 站点：默认美国站；周期：按周（本次默认）。
- 可选过滤：搜索量、点击量、购买量、搜索转化率、点击转化率、PPC竞价、CPA、产品均价、ACOS、点击占比、转化占比、词组个数、排除/包含关键词。
- 改完过滤条件点「开始筛选」（第二次查询），确认 `搜索结果数` 变化。

## 6. 操作流程

1. `bsk open "https://www.sellersprite.com/v3/keyword-conversion-rate" --json`；确认标题「关键词转化率」、站点是美国站。
2. 填关键词。**本页输入框是自定义组件，`bsk fill` 可能超时**；本次改用页面示例词链接 `lunch box` 完成查询。实际使用时可以先点示例词验证组件，再用 fill/粘贴；fill 超时不要反复重放，先 `bsk sync` 看输入框是否已写入。
3. 点「立即查询」，等结果页标题变成 `lunch box|关键词转化率|卖家精灵`，出现 `搜索结果数` 和表格。
4. 读取用 `<skill-dir>/scripts/read-table.js`（本页命中 `el-table-store`，能读 `total/pageSize/currentPage`）。
5. 需要收窄时，在「搜索结果过滤」填条件，点「开始筛选」；确认 `搜索结果数` 变化。
6. 不要点加入词库/导出/复制；本次只读验证。
7. 结束 `bsk close`。

## 7. 结果表关键列

实测表头（2026-11-14，US，关键词 `lunch box`，按周，更新至 2026第44周(10/25~10/31)）：

`#`、`关键词 数据解释`、`周搜索量`、`周点击量`、`周购买量`、`搜索转化率`、`点击转化率`、`PPC竞价 精准`、`CPA`、`产品均价 自定义价格`、`ACOS`、`广告预算`、`ABA集中度`、`点击前三ASIN`。

`read-table.js` 的 `headers` 会重复一遍（表头/表体各一份，共 28 项）；以**前 14 项**为准。注意 `PPC竞价` 和 `ACOS` 的重复项文字略有差异。

`read-table.js` 返回的 item 关键字段：

- `keyword` / `keywordCn`：英文/中文关键词。
- `searches` / `clicks` / `purchases`：周搜索量/点击量/购买量。
- `searchConvRate` / `clickConvRate`：搜索转化率/点击转化率（小数，如 0.0255 = 2.55%）。
- `exactPpc` / `broadPpc` / `phrasePpc`：精准/词组/广泛 PPC，每个是 `{min,max,value}`。
- `exactCpa` / `broadCpa` / `phraseCpa`：精准/词组/广泛 CPA，每个是 `{min,max,value}`。
- `avgProductPrice`：产品均价，`{min,max,value}`。
- `exactAcos` / `broadAcos` / `phraseAcos`：ACOS；`exactBudget` / `broadBudget` / `phraseBudget`：广告预算。
- `phraseCount`：词组个数。
- `top3Asins`：点击前三 ASIN（ASIN、点击率、转化率、图片），不是结果行本身。
- `updatedTime` / `weekIndex`：更新时间/周索引；页面顶部另显示「更新至：2026第44周(10/25~10/31)」。

## 8. 排序、分页、每页条数

- 默认排序以页面为准；本次未改排序。
- 每页 **50** 条。
- 实测总数 **2,471**，第 1 页 **50** 行，`pageSize=50`、`currentPage=1`。
- 分页用 `read-table.js` 的 `total/pageSize/currentPage`；翻页后重新读表。
- `搜索结果数` 与分页 total 应一致；不一致时两个都记录。

## 9. 导出

- 结果工具栏有「加入词库」「全部加入词库」「导出」「复制」。
- 本次验证**没有点击导出/加入词库/复制**。导出是异步任务；加入词库会改账号数据。需要时按 `workflow.md` 的导出规则单独确认。

## 10. 空态与页面坑

- 空态原文：**「主人-暂无相关数据哦!」**；实测把「搜索量」最小值设为 `999999999`，点「开始筛选」：
  - `搜索结果数: 0`
  - `read-table.js rowCount=0`、`total=null`、`empty=true`
  - URL 出现 `minSearches=999999999`（本页过滤条件会写入 URL）
- 关键词输入是自定义组件，`bsk fill` 可能超时；本次用示例词链接完成查询。fill 超时后先 `bsk sync` 看是否已写入，不要重放。
- `headers` 重复一遍是页面表头/表体双表结构，不是读取错误；取前 14 项。
- `exactAcos` 等对象的 `min/max` 可能和直觉相反（min 数值大于 max），报告用 `value`，不要用 min/max 推算区间。
- ACOS 是小数（0.4148 = 41.48%），不是 0.41%。
- 过滤条件即使写入 URL，也不代表所有条件都能复现；报告写页面回显 + URL 关键参数。

## 11. 验证清单

- [ ] URL 是 `/v3/keyword-conversion-rate`，查询后标题是 `lunch box|关键词转化率|卖家精灵`。
- [ ] 站点是美国站，周期是按周。
- [ ] 关键词与页面回显一致（本次 `lunch box`）。
- [ ] `搜索结果数` 与 `read-table.js` 的 `total` 一致。
- [ ] 实际读取行数、页码、每页 50 条。
- [ ] `headers` 取前 14 项，记录重复表头现象。
- [ ] 空态触发时记录「主人-暂无相关数据哦!」和 `minSearches` 参数。
- [ ] 未点加入词库、未导出、未修改账号数据。

## 12. 典型配方

1. **高转化词**：关键词 `lunch box` → 立即查询 → 按搜索转化率/点击转化率排序 → 读前 50。
2. **控 ACOS**：过滤面板设 ACOS ≤ 30% → 开始筛选 → 结合 CPA/产品均价判断利润空间。
3. **低竞价高转化**：设 PPC竞价上限 + 搜索转化率下限 → 开始筛选。
4. **看广告预算**：用 `exactBudget`/`broadBudget`/`phraseBudget` 估算维持该词广告所需的日预算。
5. **继续下钻**：把词拿到「关键词反查」看具体 ASIN，或到「关键词挖掘」拓相关词。

## 13. 验证记录

[验证记录](https://github.com/wayneace/sellersprite-web/blob/main/docs/verification/keyword-conversion-rate.md)（dev 文档，不随 skill 安装）
