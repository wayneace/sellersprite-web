# 选产品验证记录

- 日期: 2026-11-12
- 站点: US（美国站）
- 页面: `/v3/product-research`
- bsk session: `<session>`

## 代表查询

- 查询条件: 包含关键词 `yoga mat`；月销量 ≥ `100`；月份「最近30天」；每页 60；第 1 页；其余筛选默认
- 结果 URL:
  `https://www.sellersprite.com/v3/product-research?market=US&page=1&size=60&symbolFlag=true&monthName=bsr_sales_nearly&selectType=2&filterSub=false&weightUnit=g&order%5Bfield%5D=amz_unit&order%5Bdesc%5D=true&productTags=%5B%5D&nodeIdPaths=%5B%5D&sellerTypes=%5B%5D&eligibility=%5B%5D&pkgDimensionTypeList=%5B%5D&sellerNationList=%5B%5D&keywords=yoga%20mat&minSales=100&lowPrice=N&salesGrowthType=30d&video=`
- 页面标题: `查询结果|选产品|卖家精灵`
- 页面显示「搜索结果数: 5,000+」
- 分页组件: `total=2000`、`pageSize=60`、`currentPage=1`
- 表头（实测）:
  `# / 产品信息 数据解释 / 大类BSR / 销量趋势(父) 销量趋势(子) / 销量(父) 增长率 / 销售额 / 子体销量 子体销售额 / 变体数 / 价格 Q&A / 评分数 月新增 / 评分 留评率 / FBA 毛利率 / 上架时间 / 配送 买家运费 / 操作`
- 首行样例: ASIN `B0BVF476TZ`（SINOPHANT High Waisted Leggings for Women…），`销量(父)=108916`，价格 `7.99`（USD）。模糊匹配会命中标题含 yoga 的高销量商品，这是预期行为。
- 排序口径说明: 本记录 URL 为 `order[field]=amz_unit`（子体销量）；冷启动记录使用 `order[field]=total_units`（销量(父)），因此 Top1 显示为同一标题的 `B0BVFDH9CP`、销量同为 108,916。这是排序字段不同，不是数据矛盾。

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

## 空/错误查询

- 查询条件: 在上面的基础上加 价格下限 `999999`
- 结果 URL: 同上，`minPrice=999999`
- 分页组件: `total=0`、`rowCount=0`、`loading=false`
- 页面正文提示: 「很抱歉，暂无结果！ 建议：1、重新选择类目；2、重新选择过滤条件（先重置条件）；3、系统内置了一些推荐选品模式，您可以直接拿来参考。」
- 注意: 空态不是 `.el-table__empty-text`，`read-table.js` 的 `empty=false`；判断空结果看 `total=0` 和正文。
- 未重复提交同一空查询。

## 页面控件观察

- 站点是按钮排（美国站/日本站/英国站/德国站/法国站/意大利/西班牙/加拿大/印度站/墨西哥），不是下拉。
- 月份是按钮排，默认「最近30天」，可选 2024-10 到 2026-10 等自然月。
- 关键词匹配是 radio：模糊匹配（默认，checked）/ 词组匹配 / 精准匹配；不是月份模式。
- 查询按钮是筛选面板底部的「开始筛选」，另有「重置条件」「保存当前模式」。
- 结果工具栏：导出、导出明细、搜索结果数、展示所有变体、列表/大图、自定义列。
- 输出 URL 中 `size=60`、`page=1`、`order[field]=amz_unit&order[desc]=true`。

## 异常与备注

- 分页组件 `total=2000` 与页面「搜索结果数: 5,000+」不一致；分别记录，报告时注明来源。
- 本页未提交导出任务（按计划只观察按钮和「我的导出」入口）。
- 结果表为 div 版 Element UI 表格，读取使用 `scripts/read-table.js`（`el-table-store`）。

## 结论

选产品页在 US 站完成代表查询与空查询：60 行/页、分页 total 2000、表头与文档一致；空查询 `total=0` 并显示「很抱歉，暂无结果！」。查询按钮与关键词匹配方式已确认，可作为 CA 抽查页面（Task 12）。
