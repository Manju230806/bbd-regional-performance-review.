# Dashboard Specification

## Data source
Connect Tableau Public to `data/orders_clean.csv`.

| Column | Classification |
|---|---|
| `order_id` | Dimension |
| `order_month` | Dimension |
| `clean_first_name` | Dimension |
| `clean_last_name` | Dimension |
| `region` | Dimension |
| `rep_name` | Dimension |
| `item` | Dimension |
| `category` | Dimension |
| `status` | Dimension |
| `unit_price` | Measure |
| `quantity` | Measure |
| `amount` | Measure |
| `revenue_calc` | Measure |

## KPI cards
- **Total Revenue:** `SUM(amount)` = **INR 346,200**.
- **Total Units Sold:** `SUM(quantity)` = **106 units**.
- The Total Revenue KPI equals Part A q05 `total_revenue` (INR 346,200).

## Chart sheets

### 1. Revenue by Region
- **Chart type:** Bar chart.
- **Rows:** `region`.
- **Columns:** `SUM(amount)`.
- **Colour:** `region`.
- **Reason:** A bar chart makes regional revenue differences easy to compare.
- **Exact data table:**

| region | revenue |
| --- | --- |
| East | 69500 |
| North | 119300 |
| South | 82500 |
| West | 74900 |

### 2. Revenue by Category
- **Chart type:** Bar chart.
- **Rows:** `category`.
- **Columns:** `SUM(amount)`.
- **Colour:** `category`.
- **Reason:** A bar chart quickly identifies which product category contributes the most revenue.
- **Exact data table:**

| category | revenue |
| --- | --- |
| Apparel | 77500 |
| Electronics | 142300 |
| Home | 126400 |

### 3. Revenue Trend by Month and Category
- **Chart type:** Line chart.
- **Rows:** `SUM(amount)`.
- **Columns:** `order_month` (chronological order).
- **Colour:** `category` (one line per category).
- **Reason:** Lines make month-to-month changes and differences among category trends visible.
- **Exact data table:**

| order_month | category | revenue |
| --- | --- | --- |
| 2026-09 | Apparel | 24700 |
| 2026-09 | Electronics | 43000 |
| 2026-09 | Home | 30600 |
| 2026-10 | Apparel | 30600 |
| 2026-10 | Electronics | 49900 |
| 2026-10 | Home | 12600 |
| 2026-11 | Apparel | 22200 |
| 2026-11 | Electronics | 49400 |
| 2026-11 | Home | 83200 |

### 4. Region x Category Detail
- **Chart type:** Text table.
- **Rows:** `region`.
- **Columns:** `category`.
- **Text/colour:** `SUM(amount)`; optional colour intensity based on `SUM(amount)`.
- **Reason:** A text table gives exact values at the intersection of each region and category.
- **Exact data table:**

| region | category | revenue |
| --- | --- | --- |
| East | Apparel | 10600 |
| East | Electronics | 21400 |
| East | Home | 37500 |
| North | Apparel | 19400 |
| North | Electronics | 73400 |
| North | Home | 26500 |
| South | Apparel | 10000 |
| South | Electronics | 28700 |
| South | Home | 43800 |
| West | Apparel | 37500 |
| West | Electronics | 18800 |
| West | Home | 18600 |

## Dashboard layout
Top to bottom:
1. **Top horizontal container:** KPI cards side by side.
2. **Horizontal filter band directly below KPI cards:** `category` filter.
3. **Trend area:** Revenue Trend by Month and Category line chart.
4. **Comparison area:** Revenue by Region and Revenue by Category charts side by side inside a horizontal container.
5. **Bottom area:** Region x Category Detail text table.

Use vertical containers to stack the KPI, filter, trend, comparison and detail bands. Use horizontal containers for the KPI cards and side-by-side comparison charts. Apply the `category` filter to all four worksheets using this data source. With **Use as Filter** enabled on Revenue by Region, clicking a region bar filters the trend, category comparison and detail table to that selected region's records.

## Insight and recommendation narrative

### Visualization summary
The dashboard compares completed-order revenue by region, category and month, while the KPI cards provide the common totals. All visuals are based on the same 63 completed orders and source `amount` field.

### Summary analysis
1. **Regional comparison:** North contributes INR 119300, compared with South at INR 82500; North is higher by INR 36800.
2. **Category comparison:** Electronics is the top category at INR 142300, while Apparel contributes INR 77500.
3. **Month change:** North revenue moves from INR 53,500 in 2026-09 to INR 41,300 in 2026-10, a change of -22.8% (a decline, not growth).

### Recommendations
1. **North regional campaign:** Test a targeted North promotion on the top-revenue category, Electronics. The region contributes INR 119300; monitor North completed-order revenue and order count during the campaign.
2. **Category inventory:** Prioritise availability planning for Electronics, which generated INR 142300. Monitor category revenue, units sold and stock-outs to judge whether the decision improves sales without creating excess inventory.
3. **Investigate North's October decline:** Compare September and October order mix and promotion activity because North revenue fell from INR 53,500 to INR 41,300 (-22.8%). Monitor monthly North revenue and completed-order count after any corrective action.

## Reconciliation
| Measure | Value (INR) |
| --- | --- |
| Total Revenue KPI | 346200 |
| Sum of Revenue by Region | 346200 |
| Sum of Revenue by Category | 346200 |
| Part B pivot grand total | 346200 |
