# sellersprite-web

用 `bsk` 驱动用户**已经登录**的浏览器，操作卖家精灵（SellerSprite）网页端的中文手册。
这不是 CLI：没有命令树、没有 Python 包、没有注入 API。agent 按页面文档自己观察、点击、
填表、验证，只有读取宽表格时才用只读片段兜底。

不需要 API Key，也不读取、复制或保存 cookie、token、密码。

## 覆盖范围

按卖家精灵真实页面覆盖 27 个功能：

| 菜单 | 页面 |
|---|---|
| 竞品分析 | `/v3/competitor-lookup` |
| 选产品 | `/v3/product-research` |
| 选市场 | `/v3/market-research` |
| 关键词选品 | `/v2/keyword-research` |
| ABA数据选品 | `/v3/aba-research` |
| 产品库 | `/v3/product-store` |
| 关键词挖掘 | `/v3/keyword-miner` |
| 关键词反查 | `/v3/keyword-reverse` |
| 流量词对比 | `/v3/keyword-comparison` |
| 拓展流量词 | `/v3/traffic/extend` |
| 关键词转化率 | `/v3/keyword-conversion-rate` |
| 关键词词库 | `/v3/keyword-store` |
| 实时查竞价 | `/v3/real-time-bidding` |
| 查流量来源 | `/v3/reversing` |
| 广告洞察 | `/v3/ads-insights` |
| 关联流量 | `/v3/relation-keyword` |
| 出单词反查 | `/v2/aba/reverse/search` |
| AI评论分析2.0 | `/v3/ai-review-analysis` |
| 销量预测 | `/v2/tools/sales-estimator` |
| 利润计算器 | `/v3/calculator/index` |
| 批量下载图片 | `/v3/batch-download-pictures` |
| 竞品运营拆解 | `/v3/ai-history/kp` |
| 市场洞察 | `/v3/ai-history/ma` |
| AI-找竞品 | `/v3/ai-history/cl` |
| Listing诊断 | `/v3/ai-history/la` |
| AI-拓产品 | `/v3/ai-history/ep` |
| 关键词需求洞察 | `/v3/ai-history/krt` |

站点覆盖 US（USD，页面显示 `$`）和 CA（CAD，页面显示 `C$`）；US 做完整验证；CA 仅选产品完成数据验证，其余页面只确认站点控件，CA 数据未验证。

## 安装到 Cherry Studio

在 Cherry Studio 的 Skills 设置里用 **GitHub 链接**安装，粘贴：

```text
https://github.com/wayneace/sellersprite-web/blob/main/skill/sellersprite-web/SKILL.md
```

也可以让 agent 用 skills 工具解析该链接后安装（install source 为
`github:https://github.com/wayneace/sellersprite-web/blob/main/skill/sellersprite-web/SKILL.md`）。

该链接指向 `main` 的 `skill/sellersprite-web/SKILL.md`；`skill/sellersprite-web/` 是分发目录
（`SKILL.md`、`references/`、`scripts/`、`VERSION`），仓库根目录的 `docs/` 只用于开发，不参与安装。
安装目录由 Cherry Studio 管理，不要手工覆盖。

## 版本与更新

当前版本见 `skill/sellersprite-web/VERSION`（与 `skill/sellersprite-web/SKILL.md` frontmatter 的 `version` 一致）。

- 最低要求 **bsk CLI 0.5.0** 与 **browser-skill 0.5.0**。每个新会话第一次使用时，运行 `skill/sellersprite-web/scripts/check-bsk.sh` 同时检查两者版本；再对比本地/远端 sellersprite-web 版本。有旧版本时提示更新，不自动覆盖安装目录。
- browser-skill 0.5.0 的 `SKILL.md` 没有 `version:` 字段，自检脚本按 `bsk open` / `bsk close` 工作流标记判断兼容性。浏览器扩展 0.5.0 / protocol 1.9 已验证，`bsk read` 可用；旧环境仍为 0.4.2 时自检会打印警告，改用 `bsk extract` / `bsk evaluate`。
- 更新方式：在 Cherry Studio 里用**同一 GitHub 链接**重新安装；或 `git -C "<仓库目录>" pull` 后重新安装。
- 远端仓库：`https://github.com/wayneace/sellersprite-web`

## 使用方式

agent 先读 `skill/SKILL.md`，按任务打开对应页面文档。核心循环是：

1. `bsk open "<URL>" --json` 打开页面；
2. `bsk sync --json` / `bsk observe --session <SID>` 看页面现场；
3. 用最新 `@eN` 操作一个控件（click/fill/select 不需要逐次带 `--session/--context`）；
4. 再做一次 `bsk sync` / `bsk observe` 确认页面变化；
5. 用 `bsk read` 读简单字段，`bsk extract table|list` 读表格/列表，必要时用 `<skill-dir>/scripts/read-table.js` 或 `read-page-state.js` 兜底；
6. 核对 URL、站点、数据月份、筛选条件、总数、读取行数；
7. `bsk close` 收尾。

点击没有反应时先观察，不要在没有任何新信息的情况下重复同一动作。

AI 页面会消耗次数：生成前确认页面按钮标注的次数，每页本次只生成 1 份，失败/超时不重试；本版不下载、不删除 AI 报告。创建关键词词库属于写操作，必须先得到用户明确同意。AI 通用规则见 `skill/sellersprite-web/references/ai-reports.md`。

## 只读片段

`<skill-dir>/scripts/read-table.js` 和 `<skill-dir>/scripts/read-page-state.js` 只读取当前页面状态，不点击、不填表、
不导航、不发请求、不读 cookie/localStorage。页面当前显示什么，就返回什么。

## 数据说明

数据来自卖家精灵网页接口及其估算模型，不是 Amazon 官方口径。使用前请自行确认符合卖家精灵
的服务条款和会员协议。报告数据时必须带 URL、站点、数据月份、查询条件、总数和读取行数。

网页版查询没有额度限制；仍不要重复跑同一查询，批量数据优先用页面导出。

## 反馈

页面改版、文档错误或漏页，请到 `https://github.com/wayneace/sellersprite-web/issues` 提反馈，附上：

- 页面 URL、站点、日期；
- 操作步骤与期望/实际结果；
- 截图（不要包含账号、密码、cookie 或 token）。

agent 在页面改版时会停下来提示用户提反馈，而不是继续猜新流程。

## 开发文档（仓库根目录，不随 skill 安装）

设计、计划、反馈和验证记录在仓库根目录的 `docs/`：

- 设计：`https://github.com/wayneace/sellersprite-web/blob/main/docs/superpowers/specs/2026-11-12-sellersprite-web-manual-design.md`
- 计划：`https://github.com/wayneace/sellersprite-web/blob/main/docs/superpowers/plans/2026-11-12-sellersprite-web-manual.md`
- 验证记录：`https://github.com/wayneace/sellersprite-web/tree/main/docs/verification`

GitHub 安装链接指向 `skill/`，不会把开发文档带进 Cherry Studio。

## 仓库结构

```text
README.md                    # 开发与安装说明
skill/                       # 分发目录
  sellersprite-web/          # 安装到 Cherry Studio 的 skill 本体
    SKILL.md
    VERSION
    references/
    scripts/
docs/                        # 开发文档（不随 skill 安装）
  superpowers/
  verification/
```
