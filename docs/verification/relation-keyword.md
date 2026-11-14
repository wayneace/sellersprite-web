# 关联流量验证记录

- 日期：2026-11-14
- bsk：0.5.0（browser-skill 0.5.0 / 扩展 0.5.0，protocol 1.9）
- URL：`https://www.sellersprite.com/v3/relation-keyword?market=1&pageNum=1&pageSize=50&desc=true&orderField=createdTime&relations=%5B%5D&queryVariations=false&asinList=%5B%22B0FD3BR3RD%22%5D`
- 页面标题：`B0FD3BR3RD|关联流量|卖家精灵`
- 站点：美国站（US）
- 查询输入：`B0FD3BR3RD`（页面示例 ASIN，单个）
- 查询方式：`用当前变体查询`（`queryVariations=false`）
- 查询次数：1

## 结果

- 搜索结果数：721
- 全部关联：798
- 免费关联：739（92.61%）
- 付费关联：59（7.39%）
- total：721
- pageSize：50
- currentPage：1
- 当前页读取行数：50
- 分页：`1 - 50 / 721`
- 首行：ASIN `B0HKJT6PHJ`，关联类型 `看了还看`（`relationList=["AVP"]`），关联数 1，引流时间 `2026-11-14`，价格 `$32.99`，评分/评分数 `4.7 / 29`，BSR `#109,923 in Kitchen & Dining` / `#561 in Lunch Boxes`
- 关联 ASIN 列表首项：`B0FD3BR3RD`

## 表头（`read-table.js`，16 列）

`#`、`产品信息 数据解释`、`BSR排名`、`关联类型`、`关联ASIN`、`销量趋势(父)销量趋势(子)`、`销量(父)`、`销售额`、`子体销量 子体销售额`、`价格`、`评分数 留评率`、`评分 月新增`、`配送 买家运费`、`上架时间`、`引流时间`、`操作`

## 读取方式

- `read-table.js` 成功：`source=el-table-store`、`rowCount=50`、`total=721`、`pageSize=50`、`currentPage=1`。
- 页面默认开启大图模式，卡片容器是 `.relation-content-card`；卡片和隐藏表格行数一致（50）。
- 首卡用 `bsk observe` 读到关联类型/关联数/引流时间；完整字段用 `read-table.js` 读。
- `bsk extract discover` 未返回结果表 target；本页优先 `read-table.js`。

## 查询方式弹窗

- 点 `立即查询` 后弹出「选择关联流量查询方式」。
- 实测两个按钮：`用全部变体查询 (730)`、`用当前变体查询 (721)`。
- 本次只选 `用当前变体查询 (721)`，没有同时点全部变体。

## 空态与异常

- 本次未触发空态，未验证空态文案。
- 未切换关联类型筛选，未切换大图模式。
- 未点 `导出`、`加入产品库`、`复制ASIN`。

## CA 控件

- 站点下拉实测包含「加拿大」；本次只确认存在，未选择、未查询，CA 数据/币种未验证。
