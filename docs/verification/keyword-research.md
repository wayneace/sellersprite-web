# 关键词选品验证记录

- 日期: 2026-11-12
- 站点: US（美国）
- 页面: `/v2/keyword-research`
- bsk session: `<session>`

## v2 跳转确认

- 裸路径 `https://www.sellersprite.com/v2/keyword-research` navigate 返回 `final_url` 仍是 v2。
- 等待 3 秒后 `location.href` 仍是 `https://www.sellersprite.com/v2/keyword-research`，标题「关键词选品 - 亚马逊关键词选品工具 | 卖家精灵」。
- 页面查询表单完整可用。**旧笔记「v2 启动即跳 v3 keyword-miner」在本次 live 未复现。**

## 代表查询

- 条件: 站点 US；月份 2026-10（页面默认最新月）；月搜索量 ≥ `1000`；市场周期不限；类目全部；其余默认
- 结果 URL:
  `https://www.sellersprite.com/v2/keyword-research?station=US&order.field=searches&order.desc=true&supplement=N&usestatic=R&exportGkImages=false&marketId=1&limitUserStatic=true&adminDes=S&presetMode=&itemImageRange=2&keywordBidMatchType=exact&month=202610&minSearches=1000&...`
- 工具栏「搜索结果数: 5000+」
- 分页 footer: `1-50/1000+`，`50条/页`
- 结果表头（`bsk extract table`）:
  `# / 关键词 / 展示10条相关产品 / 搜索量趋势 / 月搜索量 / 月购买量 购买率 / 展示量 点击量 / 增长率 / 同比增长 近3月增长 / ABA 集中度 / ABA 排名 / 货流值 / PPC竞价 精准 / 需供比 商品数 / 市场分析 / 操作`
- `bsk extract table` 原始行数: 149（50 个关键词 × 主行+详情行+分隔行，最后一组少一个分隔行）
- 前 3 个关键词（按默认「月搜索量」降序）: `needoh`、`carrie`、`toilet paper`
- 详情行包含: 所属类目占比、市场周期与旺季、SPR、标题密度

### read-table.js

| 字段 | 值 |
|---|---|
| ok | true |
| rowCount | 0 |
| total | null |
| pageSize | null |
| currentPage | null |
| loading | false |
| empty | false |
| source | `none` |

结论：v2 结果不是 Element UI 表格，`read-table.js` 不适用；本页改用 `bsk extract table`（成功，149 行）。

## 空/错误查询

- 条件: 在上面的基础上把月搜索量下限改成 `999999999`
- 结果 URL: 同上，`minSearches=999999999`
- 页面提示（正文）:
  「该关键词暂未收录，可能原因：1、关键词拼写错误，或关键词月度搜索量太低，可以去亚马逊官网校验；2、您选择的国家与关键词不匹配；3、您的检索条件，如搜索量等条件太严格；建议您：用更少的关键词短语重新搜索，比如 face brush set 改为 face brush」
- 空态下没有结果表；未重复提交。

## 页面控件观察

- 站点是 14 个按钮（美国/日本/英国/德国/法国/意大利/西班牙/加拿大/印度/墨西哥/巴西站/澳洲站/阿联酋/沙特）。
- 月份按钮默认 2026-10；市场周期下拉包含 N/S1-S3/S4-S6/S7-S9/S10-S12/I/D。
- PPC 竞价匹配方式在 URL 中为 `keywordBidMatchType=exact`（默认 exact）。
- 「开始筛选」是 `button[type=submit].btn-primary`，全页匹配 2 个 submit 按钮；必须用
  `form:has(input[name='minSearches']) button[type='submit']` 收窄（匹配 1 个）。
- 分页是自定义控件（非 `.el-pagination`），footer 文本含 `1-50/1000+`、`50条/页`、`跳转至 页`。

## 异常与备注

- `read-page-state.js` 的 `total/currentPage` 为 null（本页没有 `.el-pagination`），要读 footer 文本。
- 工具栏「搜索结果数: 5000+」与分页 `1-50/1000+` 不一致；两者分别记录。
- 页面底部另有「输入关键词」单词语义校验框，与主筛选无关。
- 旧 CLI 的 UI 模式只支持 US；本次未验证 CA（Task 12 抽查站点控件）。

## 结论

关键词选品 v2 页本次**没有跳转**到 v3，页面可正常查询；代表查询返回 50 个关键词/页（原始 149 个 `<tr>`），分页 `1-50/1000+`，工具栏 5000+。读取方式确定为 `bsk extract table`，`read-table.js` 不适用。空查询显示「该关键词暂未收录」。
