# 批量下载图片验证记录

- 日期：2026-11-14
- bsk：0.5.0（browser-skill 0.5.0 / 扩展 0.5.0，protocol 1.9）
- URL：`https://www.sellersprite.com/v3/batch-download-pictures`
- 页面标题：`批量下载图片 - 亚马逊图片批量下载工具 | 卖家精灵`
- 站点：美国站（US）
- 输入 ASIN：`B07Z82895W`（1 个示例子体 ASIN）
- 下载次数：1

## 下载结果

- 保存路径：`/tmp/sellersprite-batch-images.zip`
- 页面建议文件名：`B07Z82895W(1)-US-product-image.zip`
- MIME：`application/zip`
- 大小：1,289,265 bytes（约 1.2 MB）
- zip 条目：10（`B07Z82895W/` 文件夹 + `image_1.jpg`–`image_9.jpg` 共 9 张）
- `unzip -t`：`No errors detected in compressed data`

## 读取/操作方式

- ASIN 输入是 v3 自定义 combobox；`bsk fill` 返回 `actual_value=""`，但页面出现 `B07Z82895W` chip，以页面为准。
- `bsk download --out /tmp/sellersprite-batch-images.zip @<立即下载ref> --json` 捕获下载。
- 下载后页面仍显示 `数据导出中，需要 1-5 分钟`、进度 0%、`为确保下载成功，请不要离开当前页面哦！`；没有重复下载，也没有点 `取消下载`。
- 只列/校验 zip，没有解压运行任何内容。

## 空态与异常

- 本次 zip 内 1 个 ASIN 文件夹、9 张图，未触发 Keepa 无数据/空态。
- 未点 `取消下载`，未重复下载，未下载用户真实 ASIN 批量数据。

## CA 控件

- 站点下拉实测包含「加拿大」；本次只确认存在，未选择、未下载，CA 数据未验证。
