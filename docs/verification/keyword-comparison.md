# 流量词对比验证记录

- 日期：2026-11-14
- bsk：0.5.0；browser-skill：0.5.0；扩展：0.5.0 / protocol 1.9
- 页面：`https://www.sellersprite.com/v3/keyword-comparison`
- 站点：US / 美国站
- 自己的 ASIN：`B0949DWJCV`
- 竞品输入：`B014INJCT4,B0BRN58CXR`
- 变体口径：选择「使用畅销变体对比」；结果中 `B014INJCT4` 被替换为 `B0BFWL7TKP`
- 结果 URL：`https://www.sellersprite.com/v3/keyword-comparison?q=B0949DWJCV&t=B014INJCT4,B0BRN58CXR&marketId=1&date=`
- `搜索结果数(已合并去重)`：1,553
- 总数：1,553
- 读取行数：50
- 页码：1
- 每页条数：50

## 表头（`read-table.js`）

`#`、`关键词 数据解释`、`B0949DWJCV (我的)`、`B0BRN58CXR`、`B0BFWL7TKP`、`有效 竞品数`、`ABA 周排名`、`月搜索量`、`购买量`、`展示量`、`点击量`、`商品数`、`需供比`、`操作`。

## 首行样例

- 关键词：`desk accessories`（办公桌配件）
- 月搜索量：202,471
- 购买量/购买率：1,660 / 0.82%
- 展示量/点击量：5,220,615 / 85,916
- 商品数/需供比：114,315 / 1.77
- ABA 周排名：4,166；月搜索排名：3,116
- 有效竞品数：3
- 自己的 ASIN 在该词上的自然排名：第 3 页 / 位置 152；竞品 `B0BFWL7TKP` 有 `AMAZON_CHOICE` + `ADS`，流量占比 9.78%
- 点击前三 ASIN：`B0CPFTDT6P`（3.05%）、`B0BRMX3SWH`（2.61%）、`B0F6Y5LDMB`（2.41%）

## 读取方式

- 首选：`read-table.js` + `bsk evaluate`，`source=el-table-store`，`rowCount=50`、`total=1553`、`pageSize=50`、`currentPage=1`、`serializationErrors=0`。
- 结果表是宽表，每个 ASIN 一列；`headers` 会随输入/变体替换变化。

## 空态

- 条件：自己的 ASIN 改为无效值 `B000000000`，竞品 ASIN 清空，点「立即查询」。
- 结果：`rowCount=0`、`total=null`、`empty=true`，页面显示「主人-暂无相关数据哦!」，`搜索结果数(已合并去重): 0`。
- 空态下表头不再包含 ASIN 列，只剩通用列。

## 备注

- 变体弹窗有两个动作：「使用畅销变体对比 / 使用当前变体对比」和「用畅销变体拓词 / 用当前变体拓词」；本次选的是对比。
- 未点「加入词库」「全部加入词库」「导出」「筛选关键词」「复制」。
- CA 未做数据验证；只做站点控件检查（见 `sites.md`）。
