# 只读片段

两个片段都只读取**当前页面已经渲染出来的状态**，不接收参数、不点击、不填表、不导航、不发请求、不读凭据。

| 文件 | 用途 | 返回 |
|---|---|---|
| `read-table.js` | 读 Element UI / Vue 表格 | `{ok,url,title,headers,items,rowCount,total,pageSize,currentPage,loading,empty,source,serializationErrors}` |
| `read-page-state.js` | 读页面现场：URL、标题、弹窗/提示、遮罩、空态、分页 | `{ok,url,title,bodyText,messages,loading,emptyText,total,currentPage}` |
| `check-bsk.sh` | 只读检查 bsk CLI 与 browser-skill 版本 | 文本 + exit code（0/1/2/3） |

`read-table.js` 依赖 **Vue 2 的 `el.__vue__`**（Element UI）。卖家精灵升级到 Vue 3 / Element Plus 后它会失效；此时 `source` 为 `none` 或字段为空，改用 `bsk extract table|list`、`observe` 或 `get-html`，不要反复重试片段。

## 运行方式

简单字段优先用 `bsk read`（需要扩展 0.5.0 / protocol 1.9）：

```sh
# 读标题/标签/空态文本
bsk read --selector "h1" --fields-json '[{"key":"text","read":"text"}]' --json
# 读输入值/站点下拉当前值
bsk read --selector "input" --fields-json '[{"key":"value","read":"value"}]' --max-nodes 5 --json
```

`bsk read` 不执行 JS，不需要 `--observation`；它返回 `items[].values`，并带 `page_url` / `title`。

脚本仍用 `bsk evaluate`：

```sh
# <skill-dir> 是 skill 安装目录，例如
# ~/Library/Application Support/CherryStudio/Data/Skills/sellersprite-web
bsk open "<URL>" --json
# 记下 session_id / context_id / observation_id；evaluate 前紧邻再 sync 一次，
# 用这次 sync 的 context_id + 顶层 observation_id（bsk open 的 observation 可能已过期）
bsk evaluate "$(cat "<skill-dir>/scripts/read-table.js")" \
  --session "<SID>" --context "<CTX>" --observation "<OBS>" --json

bsk evaluate "$(cat "<skill-dir>/scripts/read-page-state.js")" \
  --session "<SID>" --context "<CTX>" --observation "<OBS>" --json
```

不要在用户项目目录里直接写 `scripts/read-table.js`；用 skill 目录的绝对路径，或先 `cd` 到 skill 目录。

## bsk 版本自检

```sh
bash "<skill-dir>/scripts/check-bsk.sh"
# 0 通过；1 bsk CLI 或 browser-skill 过旧/不一致；2 未找到 browser-skill；3 bsk CLI 不可用
# 最低版本默认 0.5.0；BSK_MIN_VERSION / BSK_SKILL_MIN_VERSION 可覆盖
# BSK_SKIP_UPDATE_CHECK=1 跳过联网的最新版本检查
# BSK_SKILLS_DIR=<dir> 指定 browser-skill 的父目录
```

脚本只读，不操作页面；会检查 Cherry Studio、Codex、Claude Code、Cursor 的 skills 目录。

- browser-skill 0.5.0 的 `SKILL.md` 没有 `version:` 字段；脚本用 `bsk open` / `bsk close` 工作流标记判断兼容性，并检查 `.bsk-source` 是否存在。
- 脚本还会读取浏览器扩展版本；扩展 0.5.0 / protocol 1.9 打印 ok，版本不一致时打印警告（不改变 exit code）。扩展未更新到 0.5.0 时 `bsk read` 不可用，改用 `bsk extract` 或 `bsk evaluate`。

- bsk 0.5.0：`bsk open` 打开/复用 scope；DOM 动作直接用 `@eN`，不需要每步带 `--session/--context`；导航、用户接管或文档替换后 `bsk sync`。`bsk evaluate` 是严格动作，需要紧邻 sync 的 `--context` + **顶层** `observation_id`；`bsk read` 不需要 observation。收尾 `bsk close`。
- bsk 可能把结果包在 `value` 里；先看 `ok` 再看 `source`。
- `source` 取值：`el-table-store`（命中 Element UI store）、`vue-tableData`（遍历 Vue 组件命中）、`none`（没找到表格数据）。
- `ok:false` 或 `source:"none"` 时**先 `observe` 看页面布局**，不要重试同一片段；换 `bsk extract table|list` 或按页面文档的读取方式处理。
- 片段读的是组件 store，不是"当前视觉上可见的行"：空态或查询未刷新时 store 可能残留上一轮数据。必须结合页面正文/截图判断空结果；`serializationErrors > 0` 表示有行无法完整序列化，已退化为浅层字段（对象/数组置 `null` 并计数）。

## 红线

- 禁止用它读取登录页、支付页或任何密码/token/cookie 输入区域。
- 不得在这些文件里加入 `fetch`、`XMLHttpRequest`、`localStorage`、`sessionStorage`、`document.cookie`、`.click()`、`location.assign/replace`、`location.href =`。**只读 `location.href` 是允许的**（用于报告当前 URL），不要把它当成违规。
- 页面当前显示什么就读什么；不构造查询、不翻页、不改筛选。
