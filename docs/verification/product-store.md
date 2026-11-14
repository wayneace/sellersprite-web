# 产品库验证记录

- 日期：2026-11-14
- bsk：0.5.0；browser-skill：0.5.0；扩展：0.5.0 / protocol 1.9
- 页面：`https://www.sellersprite.com/v3/product-store`
- 站点：US（默认「所有站点」，列表中的库均显示美国站）
- 列表表头：`#`、`产品库名称`、`标签`、`所属站点`、`产品数量`、`创建时间`、`更新时间`、`操作`
- 列表状态：非空
- total：8（库数量）
- pageSize：50
- currentPage：1
- rowCount：8
- 读取方式：`read-table.js` + `bsk evaluate`，`source=el-table-store`，`serializationErrors=0`

## 空态

- 条件：输入不存在的库名 `zzzzzzzz-no-such-library`，点「查询」。
- 结果：`rowCount=0`，但 `read-table.js total` 仍为 8、`empty=false`（组件 store 的 total 未刷新）；页面正文显示「您还未创建产品库~」及安装插件/收集产品的提示。
- 结论：该页空态要同时看 `rowCount` 和页面正文，不能只看 total。

## 备注

- 本页是账号个人数据页；未记录库名、标签、产品数量。
- 未点击「新建产品库」「批量删除」「批量投放广告」「编辑标签」。
- 未执行导出（页面没有导出按钮）。
- CA 未做数据验证；只做站点控件检查（见 `sites.md`）。
