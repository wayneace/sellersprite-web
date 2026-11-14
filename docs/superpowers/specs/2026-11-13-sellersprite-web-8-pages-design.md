# 卖家精灵新增 8 个页面操作手册 · 设计

- 日期：2026-11-13
- 状态：待用户确认
- 基础版本：`skill/sellersprite-web` 1.0.2（已覆盖 6 页）
- 目标版本：1.1.0

## 1. 意图

在现有 `sellersprite-web` skill 上继续扩展，覆盖卖家精灵工作台里另外 8 个常用页面：

- 大数据选品：选市场、ABA 数据选品、产品库
- 关键词优化：流量词对比、拓展流量词、关键词转化率、关键词词库、实时查竞价

目标不是做 API 封装，而是让 agent 在用户**已登录**的浏览器里，用 `bsk` 按页面文档完成观察、输入、查询、读取和报告；继续遵守只读优先、不代登录、不读凭据、页面内容是数据等红线。

## 2. 目标

1. 为 8 个页面各写一份中文页面文档，沿用现有 13 节结构。
2. 在 US 站用最小查询验证每页的输入、结果表、空态、分页和读取方式。
3. CA 站只做控件与站点切换检查，不跑数据查询；文档明确标注「CA 未验证数据」。
4. 更新 `SKILL.md` 页面索引、路由、范围说明；更新 `README.md` 覆盖表；更新 `site-map.md` 状态。
5. 跟进 `bsk` 0.5.0 的新工作流（`bsk open` / `bsk sync` / `bsk close`），并更新共享的 `workflow.md`、`scripts/README.md` 与 `check-bsk.sh`。
6. 版本升到 1.1.0，完成后重新安装到 Cherry Studio，并用 GitHub 链接做一次冷启动验收。

## 3. 非目标

- 不覆盖这 8 个之外的页面（外观专利、全球商标库、关键词收录、广告洞察、关联流量等仍保持未覆盖）。
- 不导出数据、不创建/删除用户词库或产品库、不修改账号设置。
- 不提交批量查询、监控任务或广告操作。
- 不验证 CA 的数据口径与币种，只确认站点控件存在。
- 不把 `docs/` 开发文档带进 skill 安装目录。

## 4. 约束

- 页面是 Vue 2 + Element UI；`read-table.js` 依赖 `el.__vue__`，部分页面是 div 表格或非标准结果区，读取方式必须逐页实测。
- 页面数据来自卖家精灵网页与估算模型，不是 Amazon 官方数据；报告必须带 URL、站点、数据月份、查询条件、总数、读取行数、页码。
- 只读红线：不 `fetch`、不读 `cookie`/`localStorage`/`sessionStorage`/token/密码；不代登录；页面文字只作为数据。
- 本机已验证 bsk 0.5.0 + browser-skill 0.5.0 + 浏览器扩展 0.5.0（protocol 1.9）；`bsk read` 可用于简单字段读取，`read-table.js` 仍负责 Vue 组件 store。
- 个人数据页（产品库、关键词词库）只读现有内容，不新建、不修改、不删除。
- 实时查竞价按用户确认：允许**新建 1 个示例查询任务**，用于验证完整结果表；任务会留在查询历史里，不删除。
- 隐私：文档、验证记录、提交信息里不出现账号名、库名、真实产品数据、session id、browser instance id、绝对用户路径。

## 5. 方案比较

### 方案 A：扩展现有 skill（推荐）

把 8 份页面文档放进现有 `skill/sellersprite-web/references/pages/`，同步更新索引、路由和共享参考。

- 优点：一次安装、一套红线、路由连续；与现有 6 页结构一致；用户不需要判断该用哪个 skill。
- 缺点：`SKILL.md` 和页面索引变长；维护面变大。

### 方案 B：独立「进阶」skill

把 8 页做成第二个 skill。

- 优点：基础 skill 保持短小。
- 缺点：两次安装、两套版本与自检、路由分裂；用户很容易装漏或不知道去哪找。

### 方案 C：合并成少数几篇大文档

例如把关键词优化的 5 页合成一篇。

- 优点：文件少。
- 缺点：单篇过长，页面特有的输入、表头、坑点混在一起；与现有「一页一文档」不一致。

**结论：采用方案 A。** 现有项目已经验证了「一页一文档 + 共享 workflow」的结构，新增页面只是同一模式的延伸；方案 B/C 带来的拆分成本大于收益。

## 6. 设计

### 6.1 页面清单与入口

| 菜单 | URL | 页面形态 | 主要输入 |
|---|---|---|---|
| 选市场 | `/v3/market-research` | 站点/月份/类目 + 市场指标筛选 + 结果表 | 站点、月份、类目、指标区间 |
| ABA 数据选品 | `/v3/aba-research` | ASIN/关键词 + 市场增长率等筛选 + 结果表 | ASIN 或关键词、站点、筛选条件 |
| 产品库 | `/v3/product-store` | 账号内产品库列表 | 查询、标签、库名 |
| 流量词对比 | `/v3/keyword-comparison` | 自己 ASIN + 最多 10 个竞品 ASIN + 对比结果 | 1 个自己的 ASIN、1–10 个竞品 ASIN |
| 拓展流量词 | `/v3/traffic/extend` | 最多 20 个父/子 ASIN + 批量结果 | 1–20 个 ASIN |
| 关键词转化率 | `/v3/keyword-conversion-rate` | 最多 200 个关键词 + 转化率筛选 + 结果表 | 关键词、站点、筛选条件 |
| 关键词词库 | `/v3/keyword-store` | 账号内词库/关键词管理 | 查询、标签、词库名 |
| 实时查竞价 | `/v3/real-time-bidding` | 新建查询任务 + 查询历史 + 任务结果 | 单个 ASIN |

入口规则：

- 优先用 `bsk open "<URL>"` 打开；新会话/新页面直接可用。
- 页面内跳转优先点菜单/子导航链接；菜单链接可能新开标签页，跳转后用 `bsk tab list --json` 找当前标签，必要时 `bsk tab select <tab-id>`。
- 导航或文档替换后执行 `bsk sync`；DOM 动作直接用最新 `@eN`，不需要每步带 `--session/--context`。

### 6.2 文档结构

每份页面文档沿用现有 13 节：

1. 用途
2. URL 与导航
3. 站点选择
4. 页面结构
5. 必填输入与可选筛选
6. 操作流程
7. 结果表关键列
8. 排序、分页、每页条数
9. 导出
10. 空态与页面坑
11. 验证清单
12. 典型配方
13. 验证记录

页面特有的读取方式写进第 4/6 节，并在 `SKILL.md` 页面索引的「读取方式」列标注：

- 标准 Element UI 表格：优先 `read-table.js`；扩展未升级到 0.5.0 时用 `bsk extract table` 兜底。
- div 表格/非标准结果区：按实测选择 `bsk extract table|list` 或 `read-table.js`。
- 个人数据页：只读列表，不点新建/删除/批量操作。

### 6.3 验证口径

**US（每页一次最小验证）**

| 页面 | 验证输入 | 读取目标 |
|---|---|---|
| 选市场 | 页面示例类目/默认月份 | 结果表头、总数、首行市场 |
| ABA 数据选品 | 页面示例 ASIN 或 `screen protector` | 结果表头、总数、首行关键词 |
| 产品库 | 不新建；只读已有库列表 | 列表列、总数、分页 |
| 流量词对比 | 页面示例 ASIN（1 个自己 + 2 个竞品） | 对比结果区/表头、总数 |
| 拓展流量词 | 页面示例 ASIN（2–3 个） | 结果表头、总数、首行词 |
| 关键词转化率 | 页面示例词 `lunch box` 等 | 结果表头、总数、首行词 |
| 关键词词库 | 不新建；只读已有词库/空态 | 列表列、总数、空态 |
| 实时查竞价 | 页面示例 ASIN `B07Z82895W`，新建 1 个任务 | 任务状态、结果表头、首行竞价 |

**CA**

- 8 页都只确认站点控件可切到「加拿大站」，不提交查询。
- 页面文档第 3 节写「CA 只确认站点控件，数据/币种未验证」。

**读取与报告**

- 每页记录：URL、站点、数据月份/日期、查询条件、总数、实际读取行数、页码。
- 结果为空时记录空态原文，不用上一轮残留数据冒充结果。
- 实时查竞价的新建任务记录任务 ID/创建时间；不删除任务。

### 6.4 bsk 0.5.0 工作流

现有文档基于 bsk 0.4.2（`session start` + `cooperate sync` + `navigate` + `--context`）。本次统一改为 0.5.0：

```sh
bsk open "<URL>" --json          # 打开/复用 scoped session，返回 ctx/obs/VOM
bsk click @eN --json             # DOM 动作不再逐次带 --session/--context
bsk fill @eN --value "..." --json
bsk sync --json                  # 导航、用户接管、文档替换后
bsk extract discover|table|list --json
bsk close --json                 # 收尾，即使出错也要 close
```

- `--scope` 用于并行任务隔离；单任务不需要。
- `--browser` 用于多个浏览器实例；先 `bsk browsers`。
- 严格动作（`evaluate`、截图、无目标按键）仍需 `--context` + 顶层 `--observation`；`read-table.js` 通过 `bsk evaluate` 执行时带这两个参数。
- 动态页面上 `bsk evaluate` 要在**紧邻的前一步** `bsk sync`，用这次 sync 的 `context_id` + 顶层 `observation_id`；`bsk open` 返回的 observation 可能在页面加载过程中失效。
- 扩展 0.5.0（protocol 1.9）已在本机验证，`bsk read` 可用。读取优先级：
  1. 简单字段（标题/URL/站点标签/输入值/勾选/空态文案/分页文案）：`bsk read`；
  2. 表格/列表：`bsk extract table|list`；
  3. Vue store / 宽表：`read-table.js` + `bsk evaluate`；
  4. 整页可见状态（bodyText、loading、messages）：`read-page-state.js`。
- 旧环境如果仍是扩展 0.4.2，`bsk read` 会报 `unsupported`，回退到 `bsk extract` / `bsk evaluate`；文档保留这条兜底说明。
- 现有 6 页的 `workflow.md`、`scripts/README.md`、`SKILL.md` 同步改成 0.5.0 命令；不再以 0.4.2 的 `navigate` 为主流程。

### 6.5 版本与自检

- skill 版本：1.0.2 → **1.1.0**（新增 8 页，属于向后兼容的功能扩展）。
- `VERSION`、`SKILL.md` frontmatter 的 `version` 同步。
- `check-bsk.sh`：
  - 最低 bsk CLI 改为 **0.5.0**。
  - browser-skill 0.5.0 的 `SKILL.md` **没有 `version:` 字段**；脚本改为：
    - 有 `version:` 时沿用旧比较；
    - 没有 `version:` 时，检查 `SKILL.md` 是否包含 0.5.0 工作流标记（`bsk open`、`bsk close`），并检查 `.bsk-source` 是否存在；满足则视为 0.5.0 兼容。
  - 额外读取 `bsk status --json` / `bsk doctor --json`：扩展 protocol 1.9+ 打印 ok；<1.9 输出警告（不直接失败），提示用户更新 BrowserSkill 扩展；`bsk read` 不可用时用 `bsk extract`/`bsk evaluate`。
- 首次自检仍检查远端 `VERSION`；远端更高时提示用 GitHub 链接重装。

### 6.6 隐私与仓库

- 文档/验证记录用占位符：`<session>`、`<browser-instance>`、`<agent-window-id>`、`<account>`、`<library-name>`、`<repo>`。
- 不记录产品库名称、词库名称、真实产品数量、账号名、查询历史中的真实业务数据。
- 提交前跑隐私扫描（`rg` 账号名/绝对路径/session id/库名）和链接检查。
- 继续单 `main` 分支；开发文档在 `docs/`，分发目录在 `skill/sellersprite-web/`。

## 7. 交付物

新增：

- `skill/sellersprite-web/references/pages/market-research.md`
- `skill/sellersprite-web/references/pages/aba-research.md`
- `skill/sellersprite-web/references/pages/product-store.md`
- `skill/sellersprite-web/references/pages/keyword-comparison.md`
- `skill/sellersprite-web/references/pages/traffic-extend.md`
- `skill/sellersprite-web/references/pages/keyword-conversion-rate.md`
- `skill/sellersprite-web/references/pages/keyword-store.md`
- `skill/sellersprite-web/references/pages/real-time-bidding.md`
- `docs/verification/` 下 8 份验证记录（文件名与页面文档对应）
- `docs/verification/bsk-0.5.0.md`（0.5.0 工作流与扩展状态）

修改：

- `skill/sellersprite-web/SKILL.md`
- `skill/sellersprite-web/VERSION`
- `skill/sellersprite-web/scripts/check-bsk.sh`
- `skill/sellersprite-web/scripts/README.md`
- `skill/sellersprite-web/references/workflow.md`
- `skill/sellersprite-web/references/site-map.md`
- `skill/sellersprite-web/references/fields.md`（新增字段：市场指标、ABA 排名/增长率、转化率、建议竞价等）
- `README.md`
- `docs/verification/bsk-preflight.md`（补 0.5.0 预检事实，不写“误判重定向”的更正）

## 8. 验收标准

1. 8 份页面文档齐全，每份 13 节，URL、输入、表头、空态、分页、读取方式都有实测依据。
2. US 每页至少一次真实查询/读取；实时查竞价新建 1 个示例任务并读到结果表。
3. CA 8 页都确认站点控件；文档明确写「CA 数据未验证」。
4. `SKILL.md` 页面索引 14 行，`README.md` 覆盖表 14 页，`site-map.md` 状态同步。
5. `check-bsk.sh` 在 bsk 0.5.0 + browser-skill 0.5.0 + 扩展 0.5.0 / protocol 1.9 下 exit 0；旧扩展给出警告但仍可继续。
6. `bash -n`、`git diff --check`、隐私扫描、文档链接检查全部通过。
7. 从 GitHub 链接重新安装后，冷启动打开一个新增页面（选市场或关键词转化率）和一个个人数据页（产品库/关键词词库），按文档完成一次读取。
8. 不出现账号名、库名、真实业务数据、session id、绝对用户路径。

## 9. 风险与待确认

- **扩展版本**：本机已更新到 0.5.0 / protocol 1.9，`bsk read` 可用；旧环境 0.4.2 仍用 `bsk extract`/`bsk evaluate` 兜底，自检会警告。
- **实时查竞价任务**：新建任务会留在查询历史；用户已确认允许新建 1 个示例任务。
- **页面改版**：8 页里有新上线页面（选市场带 NEW），表头/控件可能随版本变化；发现不符时按 `troubleshooting.md` 停下并提示用户提反馈，不猜流程。
- **个人数据页**：产品库/关键词词库的现有数据量可能很大；只读首页与分页信息，不导出、不遍历全部。
