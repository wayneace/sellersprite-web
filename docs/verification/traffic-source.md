# 查流量来源验证记录

- 日期: 2026-11-12
- 站点: US（美国站）
- 页面: `/v3/reversing`
- bsk session: `<session>`
- 样例 ASIN: `B07H9PZDQW`（来自 Task 6 竞品分析首行）

## 代表查询

- 输入: ASIN `B07H9PZDQW`；月份：「最近30天」
- 结果 URL: `https://www.sellersprite.com/v3/reversing/sources?asin=B07H9PZDQW&marketId=1&date=`
- 页面标题: `B07H9PZDQW|查流量来源|卖家精灵`
- 页面统计文案: 「搜索到 12 个同组变体，另有 0 个变体因未进入前3页而未展示」
- 分页组件: `total=12`、`pageSize=100`、`currentPage=1`
- 表头（实测）:
  `# / 产品信息 数据解释 / 流量来源 / 全部流量词 / 自然搜索词 / AC推荐词 / ER推荐词 / 4星推荐词 / HR推荐词 / SP广告词 / 视频广告词 / 品牌广告词 / 操作`
- 首行:
  `B07H9PZDQW`（Gaiam Thick Yoga Mat），变体数 12，价格 `21.25`（USD），评分 `4.6`，评分数 `46,937`；
  全部流量词 `1,012`，自然搜索词 `954`，AC `0`，ER `0`，4星 `0`，HR `4`，SP `156`，视频 `0`，品牌 `0`；
  自然流量占比 = 954 / 1012 ≈ **94.27%**。

### read-table.js

| 字段 | 值 |
|---|---|
| ok | true |
| rowCount | 12 |
| total | 12 |
| pageSize | 100 |
| currentPage | 1 |
| loading | false |
| empty | false |
| source | `el-table-store` |

行数据关键字段：`asin`、`title`、`price`、`rating`、`reviews`、`variations`、`keywords`（全部流量词）、`counter`（`NATURAL_SEARCHING=954`、`HIGHLY_RATED=4`、`ADS=156`）、`badgeLabels`（`SEARCH`、`AD`）。

## 空/错误查询

- 输入: `B000000000`
- 结果 URL: `https://www.sellersprite.com/v3/reversing/sources?asin=B000000000&marketId=1&date=`
- 页面正文（截图确认）:
  「未能找到近30天或对应月份进入过关键词搜索结果前3页的产品或ASIN对应的流量来源」
  可能原因：1、ASIN码错误或ASIN与站点不匹配；2、ASIN是新创建的或访问量太少，暂无流量词来源；3、关键词拼写错误或关键词与站点语言不匹配。
- **异常**：空态下分页仍显示 `total=12`，`read-table.js` 仍返回 `rowCount=12`（上一次 B07H9PZDQW 的 store 数据）；表格在视觉上已经消失。判断空结果必须看页面正文/截图。
- 未重复提交。

## 页面控件观察

- 查询栏：国家下拉「美国站」→ 月份「最近30天」→ 输入框「输入父(子)体ASIN(最多20个)或关键词，多个ASIN以逗号区分」→ 立即查询 → 查询历史 → 示例。
- 输入框/查询按钮在 observe 中没有稳定 ref；使用 CSS：
  - 输入 `input[placeholder^='输入父(子)体ASIN']`
  - 查询 `.el-input:has(input[placeholder^='输入父(子)体ASIN']) .el-input-group__append button.my-btn`
- 结果页是标准 Element UI 表格（不是卡片/展开行），`read-table.js` 可读。
- 查询后 URL 变为 `/v3/reversing/sources?...`。

## 异常与备注

- 空态 store 残留上一次数据（rowCount/total 仍为 12），是本页最重要的坑。
- `naturalShare` 字段不在页面 store 里；需要用 自然搜索词 / 全部流量词 自己算。
- 各来源计数会重叠，不能相加当分母。
- 未提交导出任务。

## 结论

查流量来源页在 US 站用 `B07H9PZDQW` 查询成功：12 个同组变体、每页 100、自然流量占比 94.27%（954/1012）。结果布局为标准表格，`read-table.js` 可用；但空态会残留 store 旧数据，必须用页面正文确认空结果。读取方式和坑已写入页面文档。
