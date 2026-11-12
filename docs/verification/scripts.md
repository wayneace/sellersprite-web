# 只读片段验证（scripts）

- 日期: 2026-11-12
- 页面: 关键词挖掘 `/v3/keyword-miner`
- 查询: 种子词 `yoga mat`，默认精确匹配，最近30天，第 1 页
- 结果 URL: `https://www.sellersprite.com/v3/keyword-miner/?q=yoga%20mat&marketId=1&batch=0`
- 页面标题: `yoga mat|关键词挖掘|卖家精灵`
- 站点: US（美国站）
- bsk: daemon 0.4.2，session `<session>`

## 操作路径

1. `bsk navigate "https://www.sellersprite.com/v3/keyword-miner"`（带 cooperate sync 的 context/observation）。
2. `bsk fill "input[placeholder^='输入关键词']" --value "yoga mat"`（输入框在 observe 中没有独立 ref，用可见 placeholder 的 CSS 定位）。
3. 点击「立即查询」：`button.my-btn` 会匹配 5 个，必须收窄为
   `.el-input:has(input[placeholder^='输入关键词']) .el-input-group__append button.my-btn`。
4. 等待结果后分别运行两个片段。

## read-page-state.js 输出摘要

| 字段 | 值 |
|---|---|
| ok | true |
| url | `https://www.sellersprite.com/v3/keyword-miner/?q=yoga%20mat&marketId=1&batch=0` |
| title | `yoga mat\|关键词挖掘\|卖家精灵` |
| loading | false |
| emptyText | （空） |
| total | 3310 |
| currentPage | 1 |
| messages | `[]` |

## read-table.js 输出摘要

| 字段 | 值 |
|---|---|
| ok | true |
| rowCount | 50 |
| total | 3310 |
| pageSize | 50 |
| currentPage | 1 |
| loading | false |
| empty | false |
| source | `el-table-store` |

表头（去重后）：`#`、`关键词`、`展示10条相关产品`、`所属类目`、`月搜索趋势`、`相关度`、`月搜索量`、`月购买量`、`展示量`、`点击量`、`SPR`、`标题密度`、`需供比`、`商品数`、`广告竞品数`、`ABA 集中度`、`PPC竞价`、`市场分析`、`操作`。

首行字段（节选）：`avgPrice=24.43`、`avgRating=4.5`、`avgReviews=46869`、`bid=1.02`、`clicks=441686`、`adProducts=441`、`currencyUnit="$"`。

## bsk evaluate 返回形状

`bsk evaluate ... --json` 返回 `{ok, tab_id, value}`，片段结果在 **`value`** 里；排障时先看 `value.ok` 和 `value.source`。

## 异常

- `button.my-btn` 全页匹配 5 个元素，bsk 拒绝执行（`selector matched 5 elements`）；改用 `:has()` 收窄后成功。页面文档写点击「立即查询」时要给出可见锚点，不要写全局 `button.my-btn`。
- 输入框和「立即查询」按钮在 `observe`/`snapshot` 中没有稳定 ref；用 placeholder 的 CSS 定位，属于该页的已知读取方式。
- 只读红线检查：计划里的正则会把只读的 `location.href` 也算成违规（片段需要读取当前 URL）；实际执行的检查排除纯读取和文档说明，只查 `scripts/*.js` 的写操作/凭据读取，结果为 `read-only ok (js only)`。

## 结论

两个片段在本页真实数据上可用：`read-table.js` 命中 Element UI store（50 行 / 3310 总数），`read-page-state.js` 正确返回 URL、标题、分页与加载状态。片段只读，未点击、未发请求、未读凭据。
