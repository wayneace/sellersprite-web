# 实时查竞价验证记录

- 日期：2026-11-14
- bsk：0.5.0；browser-skill：0.5.0；扩展：0.5.0 / protocol 1.9
- 页面：`https://www.sellersprite.com/v3/real-time-bidding`
- 详情页：`https://www.sellersprite.com/v3/real-time-bidding/detail?marketId=1&parentTaskId=<task-id>&taskId=<task-id>&adType=sp&q=B07Z82895W...`
- 站点：US / 美国站
- ASIN：`B07Z82895W`
- 任务类型：亚马逊推荐关键词（AC）
- 任务状态：已完成（`taskStatus=3`；查询中时为 `taskStatus=2`）
- 创建/查询时间：2026-11-14 20:03:13
- 数据周：页面显示更新至 2026 第45周（VOM 中区间被截断，未完整读取）
- 任务列表：1 个任务（`total=1`）
- 详情总数：200
- 读取行数：50
- 页码：1
- 每页条数：50

## 详情表头（`read-table.js`，取前 14 项）

`#`、`关键词 数据解释`、`周搜索量`、`现排名`、`展示量 点击量`、`提高和降低 (精准)`、`提高和降低 (广泛)`、`提高和降低 (词组)`、`仅降低/固定 (精准)`、`仅降低/固定 (广泛)`、`仅降低/固定 (词组)`、`ABA集中度`、`点击前三ASIN`、`操作`。

注意：`read-table.js` 的 `headers` 会重复 3 次（页面多表结构），不是读取错误。

## 首行样例

- 关键词：`iphone duo case`（iPhone 双件手机壳），`AC`
- 周搜索量：526,644
- 现排名：46
- 展示量/点击量：12,709,025 / 223,351
- 六种竞价策略：首行均为 `$1.00`，区间 `$0.79 - $1.25`
- ABA 集中度：20.16%
- 点击前三 ASIN：`B0HGQK86HR`（7.73% / 4.35%）、`B0HHF2JT8G`（7.19% / 4.06%）、`B0HB4M1C4T`（5.24% / 1.89%）
- `autoSponsor*` / `manualSponsor*` 字段返回 `1`；实际金额以页面列为准

## 读取方式

- `read-table.js` + `bsk evaluate`，`source=el-table-store`，`rowCount=50`、`total=200`、`pageSize=50`、`currentPage=1`、`serializationErrors=0`。
- 任务列表也是 `read-table.js`：`rowCount=1`、`total=1`、`pageSize=50`、`currentPage=1`。

## 过程记录

1. 新建查询任务 → 任务类型默认「亚马逊推荐关键词」→ ASIN `B07Z82895W` → 确定。
2. 任务出现在列表，状态「查询中」（`taskStatus=2`）；只创建了 1 个任务，没有重复提交。
3. 轮询后状态变为「已完成」（`taskStatus=3`）。
4. 点任务行「查看」打开了新详情标签页；`bsk tab list` 找到新标签，`bsk tab select` 后读取。

## 备注

- 本次未触发空态；用户只授权创建 1 个示例任务，因此没有为验证空态再建任务。
- 未点「再次查询」「删除」「批量删除」「导出」；任务保留在查询历史。
- 任务详情 URL 里的 taskId 用 `<task-id>` 代替，不记录账号信息。
- CA 未做数据验证；只做站点控件检查（见 `sites.md`）。
