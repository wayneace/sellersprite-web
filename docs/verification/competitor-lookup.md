# 竞品分析验证记录

- 日期: 2026-11-12
- 站点: US（美国站）
- 页面: `/v3/competitor-lookup`
- bsk session: `<session>`

## 代表查询

- 查询方式: 关键词
- 查询条件: `yoga mat`；月份「最近30天」；类目未选；品牌/卖家/ASIN 未填
- 结果 URL:
  `https://www.sellersprite.com/v3/competitor-lookup?market=US&monthName=bsr_sales_nearly&asins=%5B%5D&keywords=yoga%20mat&page=1&nodeIdPaths=%5B%5D&symbolFlag=true&size=60&order%5Bfield%5D=amz_unit&order%5Bdesc%5D=true&lowPrice=N&salesGrowthType=30d`
- 页面标题: `查询结果|查竞品|卖家精灵`
- 页面显示「搜索结果数: 5,000+」
- 分页组件: `total=2000`、`pageSize=60`、`currentPage=1`
- 表头（实测）:
  `# / 产品信息 数据解释 / 大类BSR / 销量趋势(父) 销量趋势(子) / 销量(父) 增长率 / 销售额 / 子体销量 子体销售额 / 变体数 / 价格 Q&A / 评分数 月新增 / 评分 留评率 / FBA 毛利率 / 上架时间 / 配送 买家运费 / 操作`
- 首行样例 ASIN: `B07H9PZDQW`（Gaiam Thick Yoga Mat，价格 `24.24`，US/USD）

### read-table.js

| 字段 | 值 |
|---|---|
| ok | true |
| rowCount | 60 |
| total | 2000 |
| pageSize | 60 |
| currentPage | 1 |
| loading | false |
| empty | false |
| source | `el-table-store` |

### bsk extract table

- 直接调用：`Multiple containers found; use discover or a selector`。
- `--selector ".el-table"`：`Target is not an HTML or ARIA table/grid`。
- `extract discover` 找到 2 个 table target；用 `--target` 能返回列定义，但 `rows` 为 0、`row_sources` 为空。
- 结论：本页读取用 `read-table.js`，`extract table` 不作为数据来源。

## 空/错误查询

- 查询方式: 关键词
- 输入: `zzzz-no-such-product-xyz`
- 结果 URL: 同上，`keywords=zzzz-no-such-product-xyz`
- 分页组件: `total=0`、`rowCount=0`、`loading=false`
- 页面正文提示: 「很抱歉，暂无结果！」；可能原因：ASIN 输入有误；ASIN 创建不久或销量太少，没有达到该类目销量前 50 万；推荐使用插件查询。
- 注意: `.el-table__empty-text` 不存在，所以 `read-table.js` 的 `empty=false`；判断空结果要看 `total=0` 和正文提示。
- 未重复提交同一空查询。

## 异常与备注

- 页面当前版本没有可见的「低价」开关；URL 默认 `lowPrice=N`，未手改。
- 「展示所有变体」默认勾选（`symbolFlag=true`）；该字段在竞品页的语义未单独验证，保持默认。
- `read-page-state.js` 的 `total=2000` 与页面「搜索结果数: 5,000+」不一致；报告时两者都写，并注明来源（分页组件 vs 页面标题）。
- 关键词输入框、查询按钮均有稳定 ref（`e1934`、`e1942`），本页不需要 CSS 兜底。

## 结论

竞品分析页在 US 站用关键词 `yoga mat` 查询成功：60 行/页、分页 total 2000、表头与文档一致，首行 ASIN `B07H9PZDQW` 可作为后续关键词反查和流量来源的样例。空查询返回 `total=0` 并显示「很抱歉，暂无结果！」。读取方式确定为 `read-table.js`（`el-table-store`）。
