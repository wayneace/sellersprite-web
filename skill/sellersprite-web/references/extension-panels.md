# 扩展面板与 Amazon 搜图

本文件覆盖两个 SellerSprite Chrome 扩展面板和 Amazon `Shop the Look / StyleSnap` 搜图。它们不在卖家精灵工作台菜单里，也不计入 27 个页面；入口都是 Amazon 页面。

## 共同前置

- 扩展必须已安装并登录。未登录时扩展会显示「卖家精灵用户登录」浮层（`.ext-sign-in-card-box`）；按红线用 `bsk request-help --session <SID> --prompt "请在 Agent 窗口完成卖家精灵扩展登录"`，由用户本人完成。
- 不代点「同步网页端账号」「我要手动登录」，不输入或读取密码、cookie、token。
- 扩展在任意 Amazon 页面注入 `#main-sellersprite-extension`，面板容器是 `#ext-main-box`；功能标签是 `li.nav-item-ext a.nav-web`，文本为 `关键词收录` / `筛查相关性`。
- 面板是 UI，不是 API；扩展升级后选择器可能变化。发现标签、表单或表头与本文不符时，按 `troubleshooting.md` 复核，不要猜新流程。
- 两个面板不消耗卖家精灵 AI 次数；扩展自身的使用限制以页面提示为准。
- 「加入产品库」「加入词库」「导出」「去使用」等按钮有副作用，必须单独得到用户同意；本文的样例都不点这些按钮。

## 关键词收录

### 入口与表单

1. 打开任意 Amazon 站点页面，例如 `https://www.amazon.com/`。
2. 打开扩展面板，点「关键词收录」标签。
3. 表单有两个 `textarea`：
   - ASIN：占位文案「最多输入200个ASIN，一行一个ASIN，回车换行」；
   - 关键词：占位文案「一行一个关键词，回车换行」。
4. 当前实测的查询条件：
   - `指定页码`：下拉，选项为 `前1页` … `前20页`，默认 `前20页`；
   - `查询变体`：checkbox，默认关闭；
   - `从书签选择` / `保存书签` / `从监控导入` 是辅助入口，不改变本次输入。

### 查询与等待

1. 填 ASIN 和关键词，点「开始检索」。
2. 进行中显示 `正在检索中... 已完成 X / Y 个关键词。请勿刷新页面，刷新后任务将中断并清除`。
3. 完成显示 `检索已完成：<ASIN> 等 N 个ASIN` 和 `共 N 个关键词， 其中 M 个关键词被收录`。
4. 完成前不要刷新、不要重复点「开始检索」；表格是渐进渲染，先出现行不代表结果已稳定。

### 结果表

当前实测表结构：

- 表头：`#ext-main-box table.el-table__header`；
- 表体：`#ext-main-box table.el-table__body`；
- 列：`# / 关键词 / 子ASIN / 当前页码 / 绝对位置 / 商品数 / ABA周排名 / 月搜索量 / 购买率`。

`当前页码` 和 `绝对位置` 各显示两行：

- 第一行绿色：包含广告位的排名；
- 第二行灰色：排除广告后的自然排名。

例如 `第1页第40位` / `第1页第25位`，对应的绝对位置是 `40` / `25`。**不要只读第一行，也不要把它当成单一自然排名。**

读取片段（只读，不改页面）：

```js
(() => {
  const box = document.querySelector('#ext-main-box');
  const header = box && box.querySelector('table.el-table__header');
  const body = box && box.querySelector('table.el-table__body');
  if (!header || !body) throw new Error('关键词收录结果表未出现');
  return {
    headers: [...header.querySelectorAll('th')]
      .map(th => (th.innerText || '').trim()).filter(Boolean),
    rows: [...body.querySelectorAll('tbody tr')].map(tr =>
      [...tr.querySelectorAll('td')].map(td => (td.innerText || '').trim()))
  };
})()
```

`bsk evaluate` 是严格动作：紧邻一次 `bsk sync`，用这次 sync 的 `context_id` + 顶层 `observation_id`。`read-table.js` 未在该表验证；不要套用页面表格的 `.el-table__body-wrapper` 假设。

### 实测样例（US，2026-11-16）

- 输入：`B0B5XQ8WFT`；关键词 `tie down anchors`、`truck bed tie down`。
- 完成：`共 2 个关键词， 其中 2 个关键词被收录`。
- `tie down anchors`：广告位 40 / 自然位 25；商品数 10,137；ABA 周排名 1,293,487；月搜索量 1,506；购买率 2.52%。
- `truck bed tie down`：广告位 19 / 自然位 8；商品数 7,030；ABA 周排名显示 `i`（无值）；月搜索量 355；购买率 0.41%。

这些是模拟搜索排名，会受浏览/搜索历史影响；不能和关键词反查、流量词等页面的排名混用。

## 筛查相关性

### 入口与表单

1. 打开任意 Amazon 页面，点扩展面板的「筛查相关性」标签。
2. 表单有两个 `textarea`：
   - 竞品 ASIN：最多 48 个，占位文案「最多48个竞品ASIN，更加精准！一行一个ASIN，回车换行」；
   - 关键词：最多 400 个，占位文案「最多400个精准关键词！一行一个关键词，回车换行」。
3. 页面有「示例数据：点击填入」，会填入 48 个 ASIN × 20 个关键词；第一次探索优先用它，避免自己构造竞品集。
4. 「设置相关性高低标准」可改阈值；当前默认是 `5 / 20 / 60`：
   - `<5%` 不相关；
   - `5–20%` 低相关；
   - `20–60%` 中相关；
   - `≥60%` 高相关。
5. 顶部「AI-找竞品」是独立 AI 功能，不属于本面板；不要为了相关性筛查点「去使用」。

### 查询与等待

1. 点「开始检索」。
2. 进行中显示 `正在检索中... 已完成 X / Y 个关键词。请勿刷新页面，刷新后任务将中断并清除`。
3. 完成显示 `检索已完成：<ASIN> 等 N 个ASIN`、`N 个关键词` 和底部 `共筛查 N 个关键词`。
4. 结果是渐进渲染，**行会随着结果到达按相关性重新排序**；必须等完成文案出现且行稳定后再读，不能读第一屏就当最终顺序。

### 结果表

当前实测表结构：

- 表头：`#ext-main-box table.vxe-table--header`；
- 表体：`#ext-main-box table.vxe-table--body`；
- 列：`# / 关键词 / 相关性 / 关键词表现分 / 商品数 / ABA周排名 / 月搜索量 / 购买率`；
- 相关性单元格是两行：等级（高相关/中相关/低相关/不相关）+ 百分比；
- `关键词表现分` 可以为负数。

读取片段（只读，不改页面）：

```js
(() => {
  const box = document.querySelector('#ext-main-box');
  const header = box && box.querySelector('table.vxe-table--header');
  const body = box && box.querySelector('table.vxe-table--body');
  if (!header || !body) throw new Error('筛查相关性结果表未出现');
  return {
    headers: [...header.querySelectorAll('th')]
      .map(th => (th.innerText || '').trim()).filter(Boolean),
    rows: [...body.querySelectorAll('tbody tr')].map(tr =>
      [...tr.querySelectorAll('td')].map(td => (td.innerText || '').trim()))
  };
})()
```

`read-table.js` 未在该表验证；关键词收录用 `el-table`，本页用 `vxe-table`，不要把两页的选择器互换。

### 实测样例（US，2026-11-16）

- 输入：页面「示例数据」→ 48 个 ASIN × 20 个关键词。
- 完成：`共筛查 20 个关键词`，结果 20 行，按相关性降序。
- 高相关 3 个：68.23%、66.32%、61.46%。
- 中相关 13 个；低相关 1 个（8.51%）；不相关 3 个（2.60%、1.91%、1.22%）。
- 关键词表现分出现负值（例如 `-1.7`），它是排序辅助分，不是百分比，也不是销量。

## 搜图（Amazon Shop the Look / StyleSnap）

### UI 入口

- 入口一：Amazon 搜索栏的卖家精灵相机图标 `#seller-sprite-extension-quick-search-by-img .search-by-img-icon`。
- 入口二：直接打开 `https://www.amazon.com/stylesnap?q=local`。
- 页面标题是 `Welcome to Shop the Look`；按钮 `Upload a Photo`，文件 input 是 `#file`，`accept="image/avif,image/*"`。
- 上传后同一页面出现 `SIMILAR PRODUCTS`，URL 仍是 `/stylesnap?q=local`，**没有独立的结果页**。

### 结果结构

- 容器：`div.results-container[data-testid="resultsContainer"]`；
- 结果区：`div.product-grid#product_grid_container` → `div.similar-styles`；
- 标题：`h1` 文本 `Similar Products`；
- 卡片：`article.cellContainer[data-csa-c-item-type="asin"]`，ASIN 在 `data-csa-c-item-id="amzn1.asin.<ASIN>"`；
- 实测一次上传返回 **28 张卡片**；滚动到底仍是 28，没有分页或「加载更多」；
- 卡片同时有 Amazon 商品信息和扩展叠加数据：ASIN、品牌、卖家、配送方式、BSR、近30天销量/销售额、FBA 费用、毛利率、变体数、价格、评分、Size、Color、上架时间、流量词等；
- 卡片上的「加入产品库」是写操作，未得到用户同意不要点。

### 结果限制

- StyleSnap 偏服饰：本次 28 个结果都在 `Clothing, Shoes & Jewelry`，主要是 Women's Dresses；它不是全品类通用搜图。
- UI 结果卡**不显示相似度分数**；只能看到商品列表和扩展叠加字段。需要 `matchScore` 时用下面的 CLI。
- 上传的图片会被发送到 Amazon；使用公开商品图或用户明确提供的图，不要上传个人照片、证件、聊天截图等敏感图片。

### CLI 补充（需要相似度时）

本 skill 默认走 UI，不封装 CLI。如果用户已安装同作者的 `sellersprite-web-cli`（命令 `ssw`，仓库 `https://github.com/wayneace/sellersprite-web-cli`），搜图优先用 CLI 取相似度；CLI 的 `image-search` 会返回 `matchScore`（缺失时不要补造），UI 不返回这个字段。

```sh
# 用一个 ASIN 的主图搜索（需要卖家精灵会话解析主图）
ssw product image-search --asin B0XXXXXXXX

# 用公开图片 URL
ssw product image-search --image-url "https://m.media-amazon.com/images/I/....jpg"

# 用本地 jpg/png（≤3MB）
ssw product image-search --image ./product.jpg
```

- 输入 ASIN 默认从结果中排除；要保留加 `--include-self`。
- 常见字段：`asin`、`brand`、`title`、`price`、`rating`、`reviews`、`matchScore`、`category`。
- `matchScore` 是 Amazon 的内部视觉相似度，约 0–1；不是百分比，不能跨查询比较，也不能当销量/评论质量。某条结果没有分数时写「未提供」，不要补造。
- `category` 是 Amazon 对上传图检测出的区域标签，可能很粗（例如把平鼠标垫标成 rug），只能当提示，不是商品类目。
- CLI 不消耗卖家精灵 AI 次数；它和 UI 的 StyleSnap 是同一个 Amazon 入口，但 CLI 走普通 HTTP，不依赖浏览器扩展。
- CLI 未安装、不可用或用户要求纯 UI 时，继续用 UI；不要为了让 UI 返回分数去注入 `fetch` / `XMLHttpRequest` 或复刻请求。

### 已知坑：bsk 上传被拒

当前实测 `bsk upload` 对 `#file` 报 CDP `Not allowed`，`--mode input` 和 `--mode drop` 都失败；文件 input 本身可见且未禁用。处理顺序：

1. 先用 CLI `--image` / `--image-url`（如果用户已安装 CLI）；
2. 否则用 `bsk request-help` 请用户在 Agent 窗口手动选择一张公开图片；
3. 不要为了绕过上传在页面里执行 `fetch` / `XMLHttpRequest`，也不要复刻 StyleSnap 请求。

## 报告格式

````text
入口: 扩展面板 关键词收录 / 扩展面板 筛查相关性 / Amazon StyleSnap
Amazon 站点: amazon.com（US）
输入: ASIN / 关键词 / 竞品 ASIN / 上传图片
结果: 关键词数或 ASIN 数 / 完成文案 / 实际读取行数
相似度: 仅 CLI 有 matchScore；UI 写「未显示」
备注: 渐进渲染 / 空值 / 验证码 / 写操作未执行
````

- 关键词收录：写关键词数、被收录数、实际行数；排名写清“广告位/自然位”。
- 筛查相关性：写筛查关键词数、实际行数、阈值（如果不是默认 5/20/60）。
- StyleSnap：写返回卡片数、是否有分页/加载更多；UI 不写相似度分数，除非另有 CLI 输出。
- 两个面板都不走卖家精灵 AI 额度；扩展自身限制以页面提示为准。

## 验证记录

- [docs/verification/extension-panels.md](../../../docs/verification/extension-panels.md)
- 反馈：`https://github.com/wayneace/sellersprite-web/issues`
