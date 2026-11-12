# 只读片段

两个片段都只读取**当前页面已经渲染出来的状态**，不接收参数、不点击、不填表、不导航、不发请求、不读凭据。

| 文件 | 用途 | 返回 |
|---|---|---|
| `read-table.js` | 读 Element UI / Vue 表格 | `{ok,url,title,headers,items,rowCount,total,pageSize,currentPage,loading,empty,source,serializationErrors}` |
| `read-page-state.js` | 读页面现场：URL、标题、弹窗/提示、遮罩、空态、分页 | `{ok,url,title,bodyText,messages,loading,emptyText,total,currentPage}` |

`read-table.js` 依赖 **Vue 2 的 `el.__vue__`**（Element UI）。卖家精灵升级到 Vue 3 / Element Plus 后它会失效；此时 `source` 为 `none` 或字段为空，改用 `bsk extract table|list`、`observe` 或 `get-html`，不要反复重试片段。

## 运行方式

```sh
# <skill-dir> 是 skill 安装目录，例如
# ~/Library/Application Support/CherryStudio/Data/Skills/sellersprite-web
bsk evaluate "$(cat "<skill-dir>/scripts/read-table.js")" \
  --session "<SID>" --context "<CTX>" --observation "<OBS>" --json

bsk evaluate "$(cat "<skill-dir>/scripts/read-page-state.js")" \
  --session "<SID>" --context "<CTX>" --observation "<OBS>" --json
```

不要在用户项目目录里直接写 `scripts/read-table.js`；用 skill 目录的绝对路径，或先 `cd` 到 skill 目录。

- DOM 动作只需要 `bsk cooperate sync` 返回的 `context_id`，可复用；但 `evaluate` 是脚本（严格动作），需要 `--context` + **顶层** `observation_id`，一次一个。导航、用户接管或文档替换后重新 sync；新会话不需要 `cooperate wait`。
- bsk 可能把结果包在 `value` 里；先看 `ok` 再看 `source`。
- `source` 取值：`el-table-store`（命中 Element UI store）、`vue-tableData`（遍历 Vue 组件命中）、`none`（没找到表格数据）。
- `ok:false` 或 `source:"none"` 时**先 `observe` 看页面布局**，不要重试同一片段；换 `bsk extract table|list` 或按页面文档的读取方式处理。
- 片段读的是组件 store，不是"当前视觉上可见的行"：空态或查询未刷新时 store 可能残留上一轮数据。必须结合页面正文/截图判断空结果；`serializationErrors > 0` 表示有行无法完整序列化，已退化为浅层字段（对象/数组置 `null` 并计数）。

## 红线

- 禁止用它读取登录页、支付页或任何密码/token/cookie 输入区域。
- 不得在这些文件里加入 `fetch`、`XMLHttpRequest`、`localStorage`、`sessionStorage`、`document.cookie`、`.click()`、`location.assign/replace`、`location.href =`。**只读 `location.href` 是允许的**（用于报告当前 URL），不要把它当成违规。
- 页面当前显示什么就读什么；不构造查询、不翻页、不改筛选。
