# US / CA 站点验证记录

- 日期: 2026-11-12
- bsk session: `<session>`

## US

6 个页面均完成 US 代表查询与空/错误查询（详见各页验证记录）：

| 页面 | 代表查询 | total / 行数 | 读取方式 |
|---|---|---|---|
| 竞品分析 | `yoga mat` | 2000 / 60 | `read-table.js`（el-table-store） |
| 选产品 | `yoga mat` + 月销量 ≥100 | 2000 / 60 | `read-table.js`（el-table-store） |
| 关键词选品 | 月搜索量 ≥1000 | 分页 `1-50/1000+` / 50 词 | `bsk extract table`（149 tr） |
| 关键词挖掘 | `yoga mat` | 3310 / 50 | `read-table.js`（el-table-store） |
| 关键词反查 | `B07H9PZDQW` | 1012 / 50 | `read-table.js`（el-table-store） |
| 查流量来源 | `B07H9PZDQW` | 12 / 12 | `read-table.js`（el-table-store） |

币种：US 显示 `$`（USD）。
重量单位观察：选产品 URL 为 `weightUnit=g`，包装重量输入标签是 `g`；本版未验证 lb/oz/in³ 等其他单位。

## CA

### 选产品（完整抽查）

- 操作：打开 `/v3/product-research` → 点站点按钮「加拿大」→ 关键词 `yoga mat`、月销量 ≥ `100`、月份「最近30天」→ 开始筛选
- 结果 URL:
  `https://www.sellersprite.com/v3/product-research?market=CA&page=1&size=60&symbolFlag=true&monthName=bsr_sales_nearly&selectType=2&filterSub=false&weightUnit=g&order%5Bfield%5D=amz_unit&order%5Bdesc%5D=true&productTags=%5B%5D&nodeIdPaths=%5B%5D&sellerTypes=%5B%5D&eligibility=%5B%5D&pkgDimensionTypeList=%5B%5D&sellerNationList=%5B%5D&smallAndLight=N&keywords=yoga%20mat&minSales=100&lowPrice=N&salesGrowthType=30d&video=`
- 分页组件: `total=2000`、`pageSize=60`、`currentPage=1`，页面显示「搜索结果数: 5,000+」
- 表头：与 US 完全一致（产品信息/大类BSR/销量(父)/销售额/子体销量/变体数/价格/Q&A/评分数/评分/留评率/FBA/毛利率/上架时间/配送/买家运费/操作）
- 首行：ASIN `B0BH3BB8GZ`（100 Pack Disposable Changing Pads），价格 `C$25.99`，销售额 `C$62,168`，FBA `C$12.04`，销量(父) `2,392`
- **币种：C$（CAD）**，不是 US 的 `$`

### 其余 5 页的站点控件

| 页面 | 站点控件 | CA 结论 |
|---|---|---|
| 竞品分析 | 站点下拉 | 切到选产品的加拿大后，本页选择器直接显示「加拿大」；可切 CA，未跑 CA 查询 |
| 关键词选品 | 站点按钮排（14 个） | 有「加拿大」按钮；未跑 CA 查询 |
| 关键词挖掘 | 国家下拉 | 下拉含「加拿大」选项；未跑 CA 查询 |
| 关键词反查 | 国家下拉 | 下拉含「加拿大」选项；未跑 CA 查询 |
| 查流量来源 | 国家下拉 | 下拉含「加拿大」选项；未跑 CA 查询 |

以上 5 页只确认控件存在且含加拿大选项，**未逐页验证 CA 数据/币种**；6 份页面文档的站点小节均已标注 CA 状态（选产品为已验证，其余为仅控件确认）。

## 异常与备注

- 站点选择会跨页面保留：在选产品切到加拿大后，竞品分析页的选择器也显示加拿大。每次查询前要重新确认站点，避免把 CA 数据当 US。
- 选产品 CA 的「搜索结果数: 5,000+」与分页 `total=2000` 同样不一致；两个都记录。
- CA 的货币符号是 `C$`；旧文档若写 `CA$`，以页面实际显示为准。
- 同一 ASIN 在不同页面/不同时点的价格可能不同（变体、Coupon、抓取时点）：例如 `B07H9PZDQW` 在竞品分析记录为 `24.24`、在查流量来源记录为 `21.25`。样例价格只用于定位商品，不作为价格结论；需要价格时以目标页当场读取为准。

## 结论

US 6 页全部完成完整验证；CA 在选产品完成一次代表查询，确认 `market=CA`、`C$` 币种、total 2000、表头一致。其余 5 页只确认站点控件可切 CA，未逐页验证，已在 `references/sites.md` 与各页文档标注。
