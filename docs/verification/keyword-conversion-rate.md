# 关键词转化率验证记录

- 日期：2026-11-14
- bsk：0.5.0；browser-skill：0.5.0；扩展：0.5.0 / protocol 1.9
- 页面：`https://www.sellersprite.com/v3/keyword-conversion-rate`
- 结果 URL：`https://www.sellersprite.com/v3/keyword-conversion-rate?marketId=1&reverseType=W&bidMatchType=1&keywordMatchType=all&matchType=1&keywordList=lunch%20box`
- 站点：US / 美国站
- 周期：按周；更新至 2026第44周（10/25~10/31）
- 关键词：`lunch box`
- `搜索结果数`：2,471
- 总数：2,471
- 读取行数：50
- 页码：1
- 每页条数：50

## 表头（`read-table.js`，取前 14 项）

`#`、`关键词 数据解释`、`周搜索量`、`周点击量`、`周购买量`、`搜索转化率`、`点击转化率`、`PPC竞价 精准`、`CPA`、`产品均价 自定义价格`、`ACOS`、`广告预算`、`ABA集中度`、`点击前三ASIN`。

注意：`read-table.js` 的 `headers` 会把同一组表头重复一遍（共 28 项），这是页面表头/表体双表结构，不是读取错误。

## 首行样例

- 关键词：`lunch box`（午餐盒）
- 周搜索量/点击量/购买量：152,241 / 59,263 / 3,886
- 搜索转化率/点击转化率：2.55% / 6.56%
- PPC：精准 0.68（0.51–0.85）、词组 0.63、广泛 0.62
- CPA：精准 10.37、词组 9.60、广泛 9.45
- 产品均价：24.99
- ACOS：精准 41.48%、词组 38.43%、广泛 37.82%
- 广告预算：精准 16.32、词组 15.12、广泛 14.88
- 词组个数：2
- 点击前三 ASIN：`B0DBDKT4QC`（点击 12.76% / 转化 12.27%）、`B0GDZLL8BK`（6.10% / 2.49%）、`B0B56CHMSC`（5.00% / 3.82%）

## 读取方式

- 首选：`read-table.js` + `bsk evaluate`，`source=el-table-store`，`rowCount=50`、`total=2471`、`pageSize=50`、`currentPage=1`、`serializationErrors=0`。

## 空态

- 条件：把「搜索量」最小值设为 `999999999`，点「开始筛选」。
- 结果 URL：`...&minSearches=999999999&...`
- 结果：`搜索结果数: 0`，`rowCount=0`、`total=null`、`empty=true`，页面显示「主人-暂无相关数据哦!」。

## 备注

- 关键词输入是自定义组件，`bsk fill` 两次超时（30s/60s，`effect_state=none`）；改用页面示例词链接 `lunch box` 完成查询。fill 超时后先 sync 检查是否已写入，不重放。
- 过滤条件会写入 URL（至少 `minSearches` 已验证）；报告仍以页面回显为准。
- 未点「加入词库」「全部加入词库」「导出」「复制」。
- CA 未做数据验证；只做站点控件检查（见 `sites.md`）。
