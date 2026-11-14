# 拓展流量词验证记录

- 日期：2026-11-14
- bsk：0.5.0；browser-skill：0.5.0；扩展：0.5.0 / protocol 1.9
- 页面：`https://www.sellersprite.com/v3/traffic/extend`
- 结果 URL：`https://www.sellersprite.com/v3/traffic/extend/asin?q=B089K9L3VY,B07F8S18D5&marketId=1&date=`
- 站点：US / 美国站
- 日期：最近30天
- ASIN：`B089K9L3VY B07F8S18D5`
- 拓词方式：使用全部变体（弹窗显示 2,246；畅销/当前变体为 2,092）
- 总数：2,246
- 读取行数：50
- 页码：1
- 每页条数：50

## 表头（`read-table.js`）

`#`、`关键词 数据解释`、`内测版 流量占比`、`相关ASIN`、`月搜索趋势`、`ABA周排名`、`月搜索量 增长率`、`月购买量`、`展示量 点击量`、`SPR`、`标题 密度`、`需供比 商品数`、`广告 竞品数`、`ABA集中度`、`PPC竞价 精准`、`操作`。

## 首行样例

- 关键词：`phone stand`（手机支架）
- 月搜索量/增长率：283,545 / 8.67
- ABA 周排名：2,139
- 月购买量/购买率：11,795 / 4.16%
- 展示量/点击量：8,193,037 / 114,692
- 商品数/需供比：96,024 / 2.95
- 流量占比：14.85%
- 标题密度：26；CPR：268
- PPC：`bid=0.2`、`exactPpc=1.17`
- 点击前三点击率/转化率：20.05% / 18.37%
- 相关 ASIN：`relationVariationsItems` 里包含 `B08MT53BNK`、`B0BTBJ1MT9`、`B08CJZ6LSK` 等变体及各自流量占比（最高 62.71%）

## 读取方式

- 首选：`read-table.js` + `bsk evaluate`，`source=el-table-store`，`rowCount=50`、`total=2246`、`pageSize=50`、`currentPage=1`、`serializationErrors=0`。

## 空态

- 条件：清空 ASIN 后输入无效 ASIN `B000000000` → 立即查询 → 拓词方式弹窗各选项词数为 0 → 选「使用 全部变体」。
- 结果 URL：`https://www.sellersprite.com/v3/traffic/extend/asin?q=B000000000&marketId=1&date=`
- 结果：`rowCount=0`、`total=0`、`currentPage=1`、`empty=true`，页面显示「主人~暂无相关数据哦！」。

## 备注

- 输入是自定义 token 组件；「清除」按钮第一次点击被遮挡失败，重新 sync 后成功。
- 拓词方式弹窗里点文字标签不一定执行，点右侧词数按钮（如 `2,246`）才会进入结果页。
- 未点「加入词库」「全部加入词库」「导出明细」「导出」。
- CA 未做数据验证；只做站点控件检查（见 `sites.md`）。
