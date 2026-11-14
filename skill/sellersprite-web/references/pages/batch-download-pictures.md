# 批量下载图片（batch download pictures）

## 1. 用途

输入子体 ASIN，批量下载这些 ASIN 的商品主图压缩包。

- 适合：给选品/竞品分析收集主图素材；一次下载多个 ASIN 的主图。
- 限制：一次最多 **50 个子体 ASIN**；免费工具；若文件夹里没有某个 ASIN 的图片，可能是 Keepa 暂无数据。
- 不适合：下载评论图片/视频/A+ 图片（本页只下载主图）；替代图片版权审核（下载后仍需自行确认使用权）。

## 2. URL 与导航

- URL：`https://www.sellersprite.com/v3/batch-download-pictures`
- 导航：工作台「免费工具」→ **批量下载图片**。
- 页面标题：`批量下载图片 - 亚马逊图片批量下载工具 | 卖家精灵`。

## 3. 站点选择

- 表单有站点下拉，默认「美国站」；US 用 USD（价格字段只用于识别，不参与下载）。
- 站点下拉实测包含：美国站、日本站、英国站、德国站、法国站、意大利、西班牙、加拿大、印度站、墨西哥、巴西站、澳洲站。
- 本页 US 已完整验证；CA 只确认站点控件含「加拿大」，未选择、未下载，CA 数据未验证。

## 4. 页面结构

1. **站点下拉**：默认美国站。
2. **ASIN 输入**：v3 自定义 combobox + 文本框，placeholder `最多输入50个子体ASIN，回车提交单个ASIN；或直接从txt或Excel按列复制粘贴。`
3. **操作**：`清除`、`立即下载`。
4. **提示**：一次最多 50 个 ASIN；免费；Keepa 无数据时文件夹可能没有对应图片。
5. **下载弹窗**：`温馨提示`、进度条（本次显示 0%）、`数据导出中，需要 1-5 分钟`、`为确保下载成功，请不要离开当前页面哦！`、`取消下载`。
6. **下载文件**：zip，内含每个 ASIN 一个文件夹和多张 `image_N.jpg`。

## 5. 必填输入与可选筛选

- **ASIN**：必填，子体 ASIN；最多 50 个；可回车提交单个，也可从 txt/Excel 按列粘贴。
- **站点**：默认美国站。
- **没有筛选/排序/分页**；一次提交一批，下载一个 zip。
- 本次只用 **1 个**示例 ASIN `B07Z82895W`。

## 6. 操作流程

1. `bsk open "https://www.sellersprite.com/v3/batch-download-pictures" --json`；确认标题「批量下载图片」、站点美国站。
2. 在 ASIN 输入框填 1 个示例子体 ASIN `B07Z82895W`；确认页面出现 ASIN chip。
3. 只点一次 `立即下载`，并用 `bsk download` 捕获下载：
   `bsk download --out /tmp/sellersprite-batch-images.zip @<立即下载ref> --json`
4. 记录 `suggested_filename`、`byte_size`、`mime`；本次为 `B07Z82895W(1)-US-product-image.zip`、1,289,265 bytes、`application/zip`。
5. 用 `unzip -l` 只列文件，不执行压缩包内任何内容；本次 10 个条目（1 个文件夹 + 9 张 jpg）。
6. `unzip -t` 校验压缩包完整性；本次 `No errors detected`。
7. 不要点 `取消下载`；不要重复下载；结束 `bsk close`。

## 7. 下载结果关键字段

实测（2026-11-14，US，ASIN `B07Z82895W`）：

- 保存路径：`/tmp/sellersprite-batch-images.zip`
- 页面建议文件名：`B07Z82895W(1)-US-product-image.zip`
- MIME：`application/zip`
- 大小：1,289,265 bytes（约 1.2 MB）
- 压缩包目录：`B07Z82895W/`
- 图片：`image_1.jpg` 到 `image_9.jpg`，共 9 张
- `unzip -l` 条目：10（1 个文件夹 + 9 张图）
- 完整性：`unzip -t` 通过

## 8. 批量、分页与等待

- 一次最多 50 个子体 ASIN；没有分页/每页条数。
- 下载弹窗提示 `数据导出中，需要 1-5 分钟`；本次 `bsk download` 已捕获 zip，但页面进度仍显示 0%，不要因此重复点击或点取消。
- 一个 ASIN 也可能下载 9 张主图；图片数量不固定。
- 多个 ASIN 会在 zip 里各建一个文件夹；本版没有做多 ASIN 批量下载。

## 9. 导出/下载规则

- 本页本身就是下载工具；`立即下载` 有副作用（写文件）。
- 本次只对 1 个示例 ASIN 下载 1 次，保存到 `/tmp`；**不下载用户真实 ASIN 批量数据**。
- 不点 `取消下载`（会中断页面任务）；不要重复点 `立即下载`。
- 下载后用 `unzip -l`/`unzip -t` 检查，不运行压缩包内容。

## 10. 空态与页面坑

- **v3 自定义 combobox**：`bsk fill` 返回的 `actual_value` 可能是空，但页面会出现 ASIN chip；以页面 chip/文本为准，不要因为 `actual_value` 为空就重复填。
- **下载弹窗可能停在 0%**：`bsk download` 已拿到 zip，页面仍显示 `0%` 和 `1-5 分钟`；不要重复下载，也不要点取消，直接记录并关闭 session。
- **文件名带 `(1)`**：同名文件已存在时浏览器/页面会加序号；本次建议文件名是 `B07Z82895W(1)-US-product-image.zip`，不是错误。
- **Keepa 无数据**：页面提示文件夹里可能没有相关 ASIN 图片；如果 zip 内没有该 ASIN 文件夹，记录“Keepa 暂无数据”，不要反复下载。
- **最多 50 个**：超过上限会被截断/拒绝；本版只用 1 个。
- **图片版权**：下载只代表拿到文件，不代表有使用权；报告提醒用户自行确认版权。
- 本次未触发空态/失败文案；不要猜。

## 11. 验证清单

- [ ] URL 是 `/v3/batch-download-pictures`，标题含「批量下载图片」。
- [ ] 站点是美国站。
- [ ] 只输入 1 个示例 ASIN `B07Z82895W`，只下载 1 次。
- [ ] `bsk download` 返回 zip 路径/大小/MIME。
- [ ] zip 内有 `B07Z82895W/` 和 `image_1.jpg`–`image_9.jpg`。
- [ ] `unzip -t` 通过。
- [ ] 未点取消下载、未重复下载、未下载用户真实 ASIN 批量数据。
- [ ] CA 只确认站点控件含「加拿大」，未选择/未下载。

## 12. 典型配方

1. **下载竞品主图**：输入 1 个竞品子 ASIN → 立即下载 → 检查 zip 内图片数量。
2. **批量收集素材**：从选产品导出 ASIN 列表 → 最多 50 个粘贴 → 下载（本版未做）。
3. **检查缺图**：zip 内没有某 ASIN 文件夹 → 记录 Keepa 无数据，不重复下载。
4. **后续处理**：把图片交给设计/分析；本页不修改图片、不下载评论图。
5. **合规**：使用前确认图片版权和卖家精灵服务条款。

## 13. 验证记录

[验证记录](https://github.com/wayneace/sellersprite-web/blob/main/docs/verification/batch-download-pictures.md)（dev 文档，不随 skill 安装）
