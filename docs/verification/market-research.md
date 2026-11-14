# 选市场验证记录

- 日期：2026-11-14
- bsk：0.5.0；browser-skill：0.5.0；扩展：0.5.0 / protocol 1.9
- 页面：`https://www.sellersprite.com/v3/market-research`
- 站点：US / 美国站
- 数据维度：单月静态数据
- 月份：最近30天（URL `monthName=bsr_sales_nearly`，页面默认）
- 类目：`Home & Kitchen`（家居用品），`nodeIdPaths=["1055398"]`
- URL（结果页）：
  `https://www.sellersprite.com/v3/market-research?dataDimension=singleMonth&market=US&page=1&size=60&monthName=bsr_sales_nearly&nodeIdPaths=%5B%221055398%22%5D...`
- 总数：1,611
- 读取行数：60
- 页码：1
- 每页条数：60

## 表头（`read-table.js`）

`#`、`细分市场数据解释`、`样本数量`、`月总销量`、`月均销量 头部商品`、`月均销售额 头部商品`、`平均评分数 平均星级`、`平均BSR 头部商品`、`平均卖家数 平均价格`、`卖家类型`、`集中度指标`、`新品数量 新品占比`、`商品总数`、`退货率 同类目均值`、`操作`。

## 首行样例

- 细分市场：`Panels`（面板）
- 类目路径：`Home & Kitchen:Home Décor Products:Window Treatments:Curtains & Drapes:Panels`
- 月总销量：1,329,996
- 月均销量：13,299
- 头部商品月均销售额：292,350
- 平均价格：23.41
- 平均星级：4.6
- 平均BSR：33,826
- 品牌数/卖家数：44 / 45
- 新品数量/占比：0 / 0
- 币种：USD

## 读取方式

- 首选：`read-table.js` + `bsk evaluate`，`source=el-table-store`，`rowCount=60`、`total=1611`、`pageSize=60`、`currentPage=1`、`serializationErrors=0`。
- `bsk extract table`：表头表和表体表分开；表头 target 0 行，表体 target 120 行但列名是 `c1..c16`，没有表头。因此本页不建议用 extract 作为主读取方式。

## 空态

- 条件：月总销量最小值 `999999999`，点「开始筛选」。
- 结果：`total=0`、`currentPage=1`，页面正文显示：
  - 「很抱歉，暂无结果！」
  - 「建议：」
  - 「1、重新选择类目；」
  - 「2、重新选择过滤条件（先重置条件）；」
  - 「3、系统内置了一些推荐选品模式，您可以直接拿来参考。」

## 备注

- 第一次查询后登录态失效，页面跳到 `/w/user/login`；用户手动登录后，用结果页 URL 重新打开并读取。
- 本次未提交导出、未保存模式、未修改账号数据。
- CA 未做数据验证；只做站点控件检查（见 `sites.md`）。
