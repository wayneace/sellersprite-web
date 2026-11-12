# 关键词反查验证记录

- 日期: 2026-11-12
- 站点: US（美国站）
- 页面: `/v3/keyword-reverse`
- bsk session: `<session>`
- 样例 ASIN: `B07H9PZDQW`（来自 Task 6 竞品分析首行，Gaiam Thick Yoga Mat）

## 代表查询

- ASIN: `B07H9PZDQW`；月份：「最近30天」；第 1 页；未加筛选
- 结果 URL: `https://www.sellersprite.com/v3/keyword-reverse/?q=B07H9PZDQW&marketId=1&date=&badges=`
- 分页组件: `total=1012`、`pageSize=50`、`currentPage=1`
- 页面标题: `关键词反查 - 亚马逊关键词反查工具 | 卖家精灵`
- 表头（去重后）:
  `# / 关键词 数据解释 / 流量占比 / 流量词类型 / 流量分布 / 自然排名 / 广告排名 / 月搜索趋势 / ABA 周排名 / 月搜索量 增长率 / SPR / 标题密度 / 月购买量 / 展示量 点击量 / 需供比 商品数 / 广告竞品数 / ABA 集中度 / PPC竞价 / 操作`
- 首行: `keywords=yoga mat`（瑜伽垫），月搜索量 `1,147,222`，月购买量 `28,909`，购买率 `2.52%`，自然排名 page 1 / index 16，广告排名 index 6，流量占比 `36.15%`，ABA 周排名 `415`，PPC 竞价 `1.02`，`avgPrice=22.49`，需供比 `77.62`，标题密度 `43`，CPR `656`，流量分类 `PRIMARY`，转化分类 `STABLE`。

### read-table.js

| 字段 | 值 |
|---|---|
| ok | true |
| rowCount | 50 |
| total | 1012 |
| pageSize | 50 |
| currentPage | 1 |
| loading | false |
| empty | false |
| source | `el-table-store` |

## 空/错误查询

- ASIN: `B000000000`
- 结果 URL: `https://www.sellersprite.com/v3/keyword-reverse/?q=B000000000&marketId=1&date=&badges=`
- `read-page-state.js`: `total=0`、`currentPage=1`、`loading=false`
- 页面提示: 「主人~暂无相关数据哦！ 该商品可能近期更名或存在历史别名，试试使用别名 B000000000 反查看看吧~」
- 未重复提交。

## 页面控件观察

- 查询栏：国家下拉「美国站」→ 月份「最近30天」→ ASIN 输入框「请输入单个ASIN或产品链接，如: B00FLYWNYQ」→ 重用上次筛选 → 立即查询。
- 查询栏下方有 ASIN 概览（标题/卖家/BSR/价格/评分/上架时间）与搜索流量词占比卡片（全部流量词/自然流量/广告流量）。
- 过滤面板：流量词类型（自然搜索词/AC推荐词/ER推荐词/4星推荐词/品牌广告词/视频广告词/HR推荐词/SP广告词）、流量&转化分类（主要流量词/精准流量词/精准长尾词/有效转化词/转化优质词/转化平稳词/转化流失词/无效曝光词）、流量占比、自然/广告排名、ABA周排名、月搜索量、SPR、标题密度、月购买量、购买率、展示量、点击量、商品数、需供比、广告竞品数、点击/转化总占比、PPC竞价。
- ASIN 输入框和「立即查询」有稳定 ref（`e11447`、`e11451`）。

## 异常与备注

- `read-table.js` 的 `headers` 因固定列重复了 2–3 份；报告使用去重后的可见表头。
- 行数据的关键词字段是 `keywords`，不是 `keyword`；中文翻译是 `keywordCn`。
- `avgPrice=22.49` 是**点击第一的 ASIN 价格**，不是关键词均价；按旧字段语义记录。
- 过滤条件不进入 URL。
- 未提交导出任务。

## 结论

关键词反查页在 US 站用 `B07H9PZDQW` 查询成功：50 行/页、total 1012，读取命中 `el-table-store`；首行 `yoga mat` 流量占比 36.15%。无效 ASIN 返回「主人~暂无相关数据哦！」且 total=0。`avgPrice` 语义按点击第一 ASIN 价格记录，避免误报成均价。
