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

# 2. 共享标签页：动作前先同步，拿 context_id 和顶层 observation_id
bsk cooperate wait --session <session> --json
bsk cooperate sync --session <session> --json
# → {"context_id":"<uuid>", "observation_id":"<uuid>", ...}

# 3. 导航（需要 context + sync 返回的顶层 observation_id，不是 observation.observation_id）
bsk navigate "https://www.sellersprite.com/v3/keyword-miner" \
  --session <session> --context "<context_id>" --observation "<顶层 observation_id>" --json

# 4. 观察（只读，不需要 context）
bsk observe --session <session> --max-tokens 4000

# 5. 截图（本版本必须带 --full-page，且属视觉动作，需要 context + observation）
bsk screenshot --session <session> --full-page \
  --context "<context_id>" --observation "<顶层 observation_id>" \
  --out /tmp/ss.png --timeout 30s
```

## observations

- 首页 `https://www.sellersprite.com/`：正常打开，右上角「进入工作台」+ 头像 `用户账号`。
- `/v3/keyword-miner`：标题「关键词挖掘 - 亚马逊关键词挖掘工具 | 卖家精灵」；页面可见「关键词挖掘 / 关键词反查 / 流量词对比 / 拓展流量词 / 关键词转化率 / 实时查竞价 / 关键词收录 / 关键词词库」子导航；查询栏（截图确认）依次为：国家下拉「美国站」→ 日期「最近30天」→ 输入框「输入关键词，如: flashlight」→ 复选框「重用上次筛选」→「立即查询」→「查询历史」；示例词 phone stand / storage bins / shower organizer。
- 数据说明：页面提示「关键词数据来源于亚马逊真实的用户搜索行为，月初更新上个月数据」。

## 异常与注意

- 共享标签页状态下，`navigate` 首次调用报了 `permission_denied`（`cooperation_sync_required`，随后 `observation_required`）；按提示 `cooperate wait` → `cooperate sync` 后，用 `--context` + 顶层 `--observation` 成功。**所有带共享标签页的动作都要走这个流程；`observe` 不需要。**
- `bsk observe` 对查询栏的自定义输入组件语义暴露不完整（输入框、国家下拉未单独给出 ref），截图可见控件正常；需要定位输入框时以 `bsk extract`/片段或截图辅助。
- 启动时已有 2 个 active sessions（历史遗留），本任务使用新 session `<session>`，未干扰。
