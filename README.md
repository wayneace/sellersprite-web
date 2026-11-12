# sellersprite-web

用 `bsk` 驱动用户**已经登录**的浏览器，操作卖家精灵（SellerSprite）网页端的中文手册。
这不是 CLI：没有命令树、没有 Python 包、没有注入 API。agent 按页面文档自己观察、点击、
填表、验证，只有读取宽表格时才用只读片段兜底。

不需要 API Key，也不读取、复制或保存 cookie、token、密码。

## 覆盖范围

第一版按卖家精灵真实页面覆盖 6 个功能：

| 菜单 | 页面 |
|---|---|
| 竞品分析 | `/v3/competitor-lookup` |
| 选产品 | `/v3/product-research` |
| 关键词选品 | `/v2/keyword-research` |
| 关键词挖掘 | `/v3/keyword-miner` |
| 关键词反查 | `/v3/keyword-reverse` |
| 查流量来源 | `/v3/reversing` |

站点覆盖 US（USD，页面显示 `$`）和 CA（CAD，页面显示 `C$`）；US 做完整验证，CA 做站点切换与币种抽查。

## 安装到 Cherry Studio

在 Cherry Studio 的 Skills 设置里用 **GitHub 链接**安装，粘贴：

```text
https://github.com/wayneace/sellersprite-web/blob/main/skill/SKILL.md
```

也可以让 agent 用 skills 工具解析该链接后安装（install source 为
`github:https://github.com/wayneace/sellersprite-web/blob/main/skill/SKILL.md`）。

该链接指向 `main` 的 `skill/SKILL.md`；`skill/` 是分发目录（`SKILL.md`、`references/`、`scripts/`、`VERSION`），
仓库根目录的 `docs/` 只用于开发，不参与安装。安装目录由 Cherry Studio 管理，不要手工覆盖。

## 版本与更新

当前版本见 `skill/VERSION`（与 `skill/SKILL.md` frontmatter 的 `version` 一致）。

- 每个新会话第一次使用时，skill 会检查 `bsk --version`（最低 0.4.2）和本地/远端 skill 版本；远端更高时提示更新，不自动覆盖安装目录。
- 更新方式：在 Cherry Studio 里用**同一 GitHub 链接**重新安装；或 `git -C "<仓库目录>" pull` 后重新安装。
- 远端仓库：`https://github.com/wayneace/sellersprite-web`

## 使用方式

agent 先读 `skill/SKILL.md`，按任务打开对应页面文档。核心循环是：

1. `bsk navigate` 打开页面；
2. `bsk observe` 看页面现场；
3. 用最新 ref 操作一个控件；
4. 再做一次 `bsk observe` 确认页面变化；
5. 用 `bsk extract table` 或 `<skill-dir>/scripts/read-table.js` 读取结果；
6. 核对 URL、站点、数据月份、筛选条件、总数、读取行数；
7. `bsk session stop` 收尾。

点击没有反应时先观察，不要在没有任何新信息的情况下重复同一动作。

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
skill/                       # 分发给 Cherry Studio 的 skill 本体
  SKILL.md
  VERSION
  references/
  scripts/
docs/                        # 开发文档（不随 skill 安装）
  superpowers/
  verification/
```
