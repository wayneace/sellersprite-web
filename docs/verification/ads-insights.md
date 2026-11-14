# 广告洞察验证记录

- 日期：2026-11-14
- bsk：0.5.0（browser-skill 0.5.0 / 扩展 0.5.0，protocol 1.9）
- URL：`https://www.sellersprite.com/v3/ads-insights?q=B08FLKHG8J&marketId=1&interval=week&months=6&pageNum=1&pageSize=50`
- 页面标题：`广告洞察 - 亚马逊广告洞察工具 | 卖家精灵`
- 站点：美国站（US）
- 时间粒度：按周
- 查询输入：`B08FLKHG8J`（页面示例 ASIN，点击示例自动查询）
- 查询次数：1

## 结果

- 汇总句：`290 个投放小组（289 个SP、1 个SBV），属于 224 个广告活动`
- total：290
- pageSize：50
- currentPage：1
- 当前页读取行数：50
- 首行标签：`广告组YWTX`、`广告活动HZ2E`、`B08FLKHG8J`、`SP`
- 周列：`05/10-05/16` 到 `11/01-11/07`，共 28 列；页面未显示年份
- 单元格：只读矩阵块，本次未展开单元格明细

## 读取方式

- `bsk observe` 找到自定义矩阵 `section.groups-content > ul > li`。
- `read-table.js` 结果：`headers=[]`、`items=[]`、`rowCount=0`、`source=none`，但 `total=290`、`pageSize=50`、`currentPage=1`；本页不是 `.el-table`，不能用 `rowCount=0` 判空。
- 行数/首行用只读 `bsk evaluate` 统计 `section.groups-content > ul > li` 并读文本。
- `bsk extract discover` 只发现导航/页脚 `ul`，没有结果表 target。

## 空态与异常

- 查询后先出现 `主人-暂无相关数据哦!`，随后异步加载为 290 组；加载中不能判空。
- 点示例 ASIN 自动查询，查询按钮随后可用；没有重复点击查询。

## CA 控件

- 站点下拉包含「加拿大」；本次只确认存在，未选择、未查询，CA 数据/币种未验证。

## 未执行

- 未点 `导出`。
- 未展开周列单元格。
- 未重复查询、未修改任何账号数据。
