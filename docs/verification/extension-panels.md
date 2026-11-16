# 扩展面板与 Amazon 搜图验证

- 日期: 2026-11-16
- 环境: bsk 0.5.0 / browser-skill 0.5.0 / 浏览器扩展 0.5.0（protocol 1.9）
- 浏览器: Chrome 157.0.0.0，Amazon US `https://www.amazon.com/`
- 扩展: SellerSprite Chrome 扩展已注入 `#main-sellersprite-extension`；登录浮层页脚显示 `v5.0.6`
- 账号信息: 不记录账号名、密码、cookie、token、余额

## 关键词收录

- 入口: Amazon 页 → 扩展面板 → `关键词收录`
- 表单: ASIN `B0B5XQ8WFT`；关键词 `tie down anchors`、`truck bed tie down`
- 条件: 指定页码 `前20页`（默认）；查询变体未勾选
- 完成: `共 2 个关键词， 其中 2 个关键词被收录`
- 结果:

| 关键词 | 广告位 | 自然位 | 商品数 | ABA周排名 | 月搜索量 | 购买率 |
|---|---|---|---|---|---|---|
| tie down anchors | 40 | 25 | 10,137 | 1,293,487 | 1,506 | 2.52% |
| truck bed tie down | 19 | 8 | 7,030 | 无值（显示 i） | 355 | 0.41% |

- 表结构: `table.el-table__header` + `table.el-table__body`；列 `# / 关键词 / 子ASIN / 当前页码 / 绝对位置 / 商品数 / ABA周排名 / 月搜索量 / 购买率`
- 说明: `当前页码`/`绝对位置` 各两行，绿色为含广告位排名，灰色为排除广告的自然排名；没有单独的广告类型列。
- 未执行: 导出、保存书签、从监控导入。

## 筛查相关性

- 入口: Amazon 页 → 扩展面板 → `筛查相关性`
- 输入: 页面「示例数据：点击填入」→ 48 个竞品 ASIN × 20 个关键词
- 完成: `共筛查 20 个关键词`
- 结果: 20 行，按相关性降序
  - 高相关 3 个：68.23%、66.32%、61.46%
  - 中相关 13 个
  - 低相关 1 个：8.51%
  - 不相关 3 个：2.60%、1.91%、1.22%
- 表结构: `table.vxe-table--header` + `table.vxe-table--body`；列 `# / 关键词 / 相关性 / 关键词表现分 / 商品数 / ABA周排名 / 月搜索量 / 购买率`
- 默认阈值: `5 / 20 / 60`（不相关 / 低相关 / 中相关 / 高相关），关闭设置弹窗时点「取消」，未修改。
- 渐进渲染: 查询中先显示 `正在检索中... 已完成 6 / 20 个关键词`，结果行随完成度增加并重新排序；完成后读取。
- 未执行: 加入词库、导出、AI-找竞品「去使用」。

## StyleSnap 搜图

- 入口: `https://www.amazon.com/stylesnap?q=local`；标题 `Welcome to Shop the Look`
- 输入: 页面公开时尚图（JPEG，163KB，900×950）；`#file` 的 `accept="image/avif,image/*"`
- 结果: 同页出现 `SIMILAR PRODUCTS`，`article.cellContainer` 共 28 个；滚动到底仍为 28 个，无分页/加载更多
- 结果区: `div.results-container[data-testid="resultsContainer"]` → `div.product-grid#product_grid_container` → `div.similar-styles`
- 卡片: `data-csa-c-item-id="amzn1.asin.<ASIN>"`；同时显示 Amazon 商品信息和扩展叠加字段（ASIN、品牌、卖家、BSR、近30天销量/销售额、FBA费用、毛利率、变体数、价格、评分、Size、Color、上架时间、流量词）
- 示例 ASIN: `B0FMK19DFC`、`B0GYZ5Q816`、`B0GR4KP1RT`、`B0G1MJZR71`；全部属于 `Clothing, Shoes & Jewelry`，以 Women's Dresses 为主
- UI 不显示 `matchScore`；相似度需用 CLI `ssw product image-search`。
- 未执行: 加入产品库、导出、下载。

### 上传限制

- `bsk upload --selector "#file"` 报 CDP `-32000 Not allowed`；`--mode input` 和 `--mode drop` 都失败
- `#file` 可见、未禁用；失败后文件 input 的 `files.length` 仍为 0
- 本次用页面内 `File` + `DataTransfer` 触发 `change` 后跑通；该方式只用于验证，不写进 skill 的默认步骤
- skill 的处理顺序: CLI `--image` / `--image-url` → `bsk request-help` 让用户手动选公开图 → 不在页面里注入 `fetch`/`XMLHttpRequest`

## 备注

- 两个扩展面板不走卖家精灵 AI 额度；扩展自身限制未逐项验证。
- 未记录账号名、余额、session id、cookie、token。
- 关键词收录是模拟搜索排名，受浏览/搜索历史影响，不能和关键词反查/流量词排名混用。
- StyleSnap 是服饰导向的相似款，不是全品类商品搜图；结果 28 个不代表全站同款总数。

## 文档

- `skill/sellersprite-web/references/extension-panels.md`
- 反馈: `https://github.com/wayneace/sellersprite-web/issues`
