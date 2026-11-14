# ABA 数据选品验证记录

- 日期：2026-11-14
- bsk：0.5.0；browser-skill：0.5.0；扩展：0.5.0 / protocol 1.9
- 页面：`https://www.sellersprite.com/v3/aba-research`
- 站点：US / 美国站
- 时间粒度：按周
- 数据周：2026 第45周（11/01~11/07），`tableHistoryDate=ara_20261107`
- 查询词：`screen protector`
- 总数：4,482
- 读取行数：50
- 页码：1
- 每页条数：50

## 表头（`read-table.js`）

`#`、`关键词 数据解释`、`周排名/搜索趋势`、`周搜索量`、`现排名`、`历史排名`、`排名变化`、`排名变化率`、`展示量 点击量`、`PPC竞价 精准`、`SPR`、`标题 密度`、`点击前三ASIN`、`点击前三品牌`、`操作`。

## 首行样例

- 关键词：`iphone 18 pro max screen protector`（iPhone 18 Pro Max 屏幕保护膜）
- 周搜索量：261,908
- 现排名：192
- 历史排名：上周 186 / 4周前 238 / 12周前 549,608
- 排名变化：-6；变化率：-3.23%
- 展示量/点击量：6,101,614 / 128,036
- PPC 竞价：`-- -- --`（本行无数据）
- CPR：171；标题密度：8
- 点击前三点击集中度：38.16%；点击前三转化集中度：35.87%
- 购买量/购买率：2,042 / 0.78%
- 站点域名：`https://www.amazon.com`；`marketId=1`

## 读取方式

- 首选：`read-table.js` + `bsk evaluate`，`source=el-table-store`，`rowCount=50`、`total=4482`、`pageSize=50`、`currentPage=1`、`serializationErrors=0`。
- 结果表是宽表；`bsk extract table` 未作为主读取方式，页面表头/表体结构以 `read-table.js` 的 headers 为准。

## 空态

- 条件：关键词改为 `zzzzzzzzzzzzzz`，点「立即查询」。
- 结果：`rowCount=0`、`total=0`、`currentPage=1`、`empty=true`，页面显示「主人-暂无相关数据哦!」。

## 备注

- 页面有「导出」按钮，本次未点击；未加入词库、未修改账号数据。
- 2023-05-22 规则提示：同一时间范围内搜索频率相同的词显示相同排名，并按字母数字顺序排序。
- CA 未做数据验证；只做站点控件检查（见 `sites.md`）。
