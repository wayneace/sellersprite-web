# 关键词挖掘验证记录

- 日期: 2026-11-12
- 站点: US（美国站）
- 页面: `/v3/keyword-miner`
- bsk session: `<session>`

## 代表查询

- 种子词: `yoga mat`；匹配方式：默认（精确）；日期：「最近30天」；未加过滤条件
- 结果 URL: `https://www.sellersprite.com/v3/keyword-miner/?q=yoga%20mat&marketId=1&batch=0`
- 分页组件: `total=3310`、`pageSize=50`、`currentPage=1`
- 表头（实测）:
  `# / 关键词 数据解释 / 展示10条相关产品 / 所属类目 / 月搜索趋势 / 相关度 / 月搜索量 增长率 / 月购买量 / 展示量 点击量 / SPR / 标题密度 / 需供比 商品数 / 广告竞品数 / ABA 集中度 / PPC竞价 精准 / 市场分析 / 操作`
- 首行: 关键词 `yoga mat`（瑜伽垫），月搜索量 `900,747`，月购买量 `26,752`，购买率 `2.97%`，商品数 `14,150`，PPC 竞价 `1.02`（USD）

### read-table.js

| 字段 | 值 |
|---|---|
| ok | true |
| rowCount | 50 |
| total | 3310 |
| pageSize | 50 |
| currentPage | 1 |
| loading | false |
| empty | false |
| source | `el-table-store` |

注：Task 5 的片段验证也在本页跑过同一查询，`rowCount=50`、`total=3310` 与本次一致。

## 过滤面板（第二次查询）

- 在「搜索结果过滤」里设置 相关度 ≥ `80`，点「开始筛选」。
- 过滤前 `total=3310`；过滤后 `total=4`、`rowCount=4`、`currentPage=1`。
- **过滤条件不写入 URL**：URL 仍是 `?q=yoga%20mat&marketId=1&batch=0`。报告筛选条件必须读页面回显。
- 首行仍是 `yoga mat`（相关度最高）。

## 空/错误查询

- 种子词: `zzzz-no-such-keyword-xyz`；其余默认
- 结果 URL: `https://www.sellersprite.com/v3/keyword-miner/?q=zzzz-no-such-keyword-xyz&marketId=1&batch=0`
- `read-page-state.js`: `total=0`、`currentPage=1`、`loading=false`、`emptyText="主人-暂无相关数据哦!"`
- 页面显示「搜索结果数: 0」；表格为空。
- 未重复提交。

## 页面控件观察

- 查询栏：国家下拉「美国站」→ 日期「最近30天」→ 输入框「输入关键词，如: flashlight」→「重用上次筛选」→「立即查询」→「查询历史」→ 示例词。
- 种子词输入框和「立即查询」在 `observe` 里没有稳定 ref，使用 CSS：
  - 输入 `input[placeholder^='输入关键词']`
  - 查询 `.el-input:has(input[placeholder^='输入关键词']) .el-input-group__append button.my-btn`（全局 `button.my-btn` 匹配 5 个，会报 selector matched 5 elements）
- 过滤面板包含：所属类目、相关度、ABA月排名、月搜索量、月购买量、购买率、展示量、点击量、SPR、标题密度、商品数、需供比、广告竞品数、点击总占比、转化总占比、PPC竞价、单词个数、词根匹配、Amazon Choice、排除/包含关键词、广泛匹配/词组匹配、开始筛选、重置条件。

## 异常与备注

- 过滤条件不进入 URL，URL 不能复现筛选。
- `read-table.js` 命中 Element UI store，适合本页宽表；不需要 `bsk extract table`。
- 未提交导出任务。

## 结论

关键词挖掘页在 US 站完成代表查询、过滤面板二次查询和空查询：50 行/页、total 3310，相关度 ≥80 后 total 4，空种子词返回「主人-暂无相关数据哦!」。读取方式确认为 `read-table.js`（`el-table-store`），种子词输入和查询按钮需要 CSS 兜底。
