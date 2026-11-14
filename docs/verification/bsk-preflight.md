# bsk 预检

- 日期: 2026-11-12
- bsk 版本/doctor: daemon 0.4.2 / protocol 1.8；浏览器扩展 0.4.2；`bsk doctor` 全部 ok
- 浏览器: Chrome 157.0.0.0（browser instance `<browser-instance>`，1 个在线浏览器，扩展已连接）
- session id 字段: `session_id`（`bsk session start --json` 顶层，值为 `<session>`）；同返回还含 `agent_window_id`、`browser_instance_id`、`interaction`
- 登录状态: 已登录（工作台右上角头像 `用户账号`）
- 当前站点: US —— `/v3/keyword-miner` 查询栏最左侧显示「美国站」+ 美国国旗
- 站点选择器位置: 每个 `/v3` 工具页查询栏最左侧的国家下拉（位于日期范围「最近30天」左边）；首页本身不显示站点选择器，进入工作台后可见

## 真实命令形状（本机 bsk 0.4.2）

```sh
# 1. 启动 session
bsk session start --json
# → {"session_id":"<session>","agent_window_id":<agent-window-id>,"browser_instance_id":"<browser-instance>",...}

# 2. 新会话/新页面：直接 sync；用户正在操作时先 wait，ready 后再 sync
bsk cooperate sync --session <session> --json
# → {"context_id":"<uuid>", "observation_id":"<uuid>", ...}
# 用户操作中：bsk cooperate wait --session <session> --json

# 3. 导航（DOM 动作只需 context；若 CLI 报 observation_required，再补顶层 --observation）
bsk navigate "https://www.sellersprite.com/v3/keyword-miner" \
  --session <session> --context "<context_id>" --json

# 4. 观察（只读，不需要 context）
bsk observe --session <session> --max-tokens 4000

# 5. 截图（默认 viewport；整页加 --full-page，--timeout 只在 full-page 时可用；截图属严格动作）
bsk screenshot --session <session> --out /tmp/ss.png
bsk screenshot --session <session> --full-page --timeout 30s \
  --context "<context_id>" --observation "<顶层 observation_id>" --out /tmp/ss-full.png
```

## observations

- 首页 `https://www.sellersprite.com/`：正常打开，右上角「进入工作台」+ 头像 `用户账号`。
- `/v3/keyword-miner`：标题「关键词挖掘 - 亚马逊关键词挖掘工具 | 卖家精灵」；页面可见「关键词挖掘 / 关键词反查 / 流量词对比 / 拓展流量词 / 关键词转化率 / 实时查竞价 / 关键词收录 / 关键词词库」子导航；查询栏（截图确认）依次为：国家下拉「美国站」→ 日期「最近30天」→ 输入框「输入关键词，如: flashlight」→ 复选框「重用上次筛选」→「立即查询」→「查询历史」；示例词 phone stand / storage bins / shower organizer。
- 数据说明：页面提示「关键词数据来源于亚马逊真实的用户搜索行为，月初更新上个月数据」。

## 异常与注意

- `navigate` 首次调用报 `permission_denied`（`cooperation_sync_required`，随后 `observation_required`）：根因是还没有可用的 sync context；`cooperate sync` 后用 `--context`（必要时补顶层 `--observation`）重试一次即可。**DOM 动作复用 context；只有 evaluate/截图等严格动作每次要新的顶层 observation；`observe` 不需要。**
- `bsk observe` 对查询栏的自定义输入组件语义暴露不完整（输入框、国家下拉未单独给出 ref），截图可见控件正常；需要定位输入框时以 `bsk extract`/片段或截图辅助。
- 启动时已有 2 个 active sessions（历史遗留），本任务使用新 session `<session>`，未干扰。

## 2026-11-13 复核（browser-skill / bsk 0.4.2）

- `bsk --version` = 0.4.2；`bsk update --check` 返回 `up_to_date`；browser-skill 版本同为 0.4.2。
- 新版 browser-skill 文档明确：
  - 新会话 `navigate` 后直接 `cooperate sync`，`cooperate wait` 只在用户正在操作时用；
  - target-policy 的 `context_id` 可复用于后续 DOM 动作和补充读取；
  - `--observation` 只用于 `evaluate`、截图、无目标按键等严格动作，一次一个；
  - `select` 用 option 的 value，不是可见文本；
  - 截图默认 viewport，`--full-page` 可选，`--timeout` 只在 full-page 时可用；
  - `extract discover` 的 target 5 分钟后过期。
- 新增 `scripts/check-bsk.sh`：同时检查 **bsk CLI** 与 **browser-skill** 版本（最低版本、两者一致性、最新版本），退出码 0/1/2/3；skill 版本升到 **1.0.2**。
- 已据此更新 `SKILL.md`、`workflow.md`、`scripts/README.md` 和本页命令形状。

## 2026-11-14 复核（bsk 0.5.0 / 扩展 0.5.0）

- `bsk --version` = 0.5.0；browser-skill 0.5.0 已装入 Cherry Studio（安装副本补了 `version: 0.5.0`）；浏览器扩展 0.5.0 / protocol 1.9。
- 新工作流：`bsk open` → `bsk sync` → `bsk click/fill @eN` → `bsk extract` / `bsk read` → `bsk close`；DOM 动作不再逐步带 `--session/--context`。
- `bsk read` 实测可用：读取 `page_url` / `title`、`h1` 文本和输入值，不需要 observation；简单字段优先用它。
- `bsk evaluate` 仍是严格动作：动态页面上先紧邻 `bsk sync`，再用这次 sync 的 `context_id` + 顶层 `observation_id`。
- 自检输出：

```text
bsk CLI: 0.5.0（最低 0.5.0）ok
browser-skill: 0.5.0（最低 0.5.0）ok
最新 bsk: 0.5.0
browser extension: 0.5.0（protocol 1.9）ok
exit=0
```

- 旧扩展 0.4.2 环境回退到 `bsk extract` / `bsk evaluate`；`bsk read` 会报 `unsupported`。
