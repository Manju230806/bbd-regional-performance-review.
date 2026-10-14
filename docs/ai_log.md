# AI-Assisted Analysis and Human-in-the-Loop Verification Log

## Task 1 — Five-part prompt for Part A q13

**Role:** You are a careful SQL business analyst writing auditable reporting queries.

**Task:** Write the q13 query that reports each sales representative's completed-order revenue by month and classifies performance against the representative's monthly target.

**Context:** The real tables are `reps(rep_id, rep_name, region, monthly_target)`, `customers(customer_id, first_name, last_name, city, region, age, rep_id)`, and `orders(order_id, customer_id, item, quantity, amount, status, order_month)`. The SQL dialect used in this project is SQLite.

**Constraints:** Count completed orders only (`orders.status = 'completed'`). Group by representative, month and monthly target. Use `Below Target` when revenue is below the target, `On Target` when revenue is at least the target but below 1.1 times the target, and `Above Target` otherwise. Do not use `WITH` clauses or stored procedures. Do not reference aggregate aliases inside `WHERE` or `GROUP BY`; write the aggregate expression in the tier calculation.

**Format:** Return raw SQL only, with inline comments.

## Task 2 — Inspect Scenario D1 defects

| Defect | Classification | Why it is wrong | Correct clause or fix |
|---|---|---|---|
| `sales` table does not exist in the supplied schema | fake method/function | The actual schema contains `orders`, `customers`, `products` and `reps`, not `sales`. | Query `orders` joined to `customers` to obtain region. |
| `region_name` and `total_sales` do not exist | fake method/function | The real columns are `customers.region` and `orders.amount`. | Use qualified real columns and `SUM(o.amount) AS revenue`. |
| `SUM(total_sales) > 80000` appears in `WHERE` | logic error | Aggregate filters are evaluated after grouping and cannot be placed in `WHERE`. | Put `SUM(o.amount) > 80000` in `HAVING`. |
| “North revenue grew 38% month over month” | phantom statistic | The number is unsupported and conflicts with the actual q11 month values. | Calculate the percentage from completed-order revenue by region and month. |

## Task 3 — Corrected query and verification

The runnable corrected query is stored in `sql/d1_corrected.sql`. It counts only completed orders, groups by customer region, and keeps regions whose completed-order revenue exceeds INR 80,000.

**Recorded result:**

| region | revenue |
| --- | --- |
| North | 119300 |
| South | 82500 |

**North month-over-month verification from q11:**
- North 2026-09 revenue: INR 53,500
- North 2026-10 revenue: INR 41,300
- Percentage change = `((October - September) / September) × 100` = **-22.8%**.
- The assistant's claim of 38% growth is contradicted by the data: North revenue declined rather than grew.

## Task 4 — Human-in-the-loop protocol

**Specification:** The original question, “which regions sell the most?”, is ambiguous. I specified the project's actual revenue definition, the real schema, completed orders only, and the INR 80,000 threshold.

**Execution:** I ran the corrected SQL against the supplied SQLite seed tables. The query returned North at INR 119,300 and South at INR 82,500.

**Inspection:** I checked table and column names against the schema and inspected the grouping, `WHERE`, `HAVING`, and sort clauses. The aggregate condition is in `HAVING`, and only completed orders are counted.

**Verification:** I compared the regional output with q11's month-level completed revenue. North changed from INR 53,500 in September to INR 41,300 in October, or -22.8%, which does not support the 38% growth claim.

**Decision:** **Reject** the original answer because it uses nonexistent schema objects, puts an aggregate in `WHERE`, and states a phantom 38% growth figure. **Accept** the corrected query because it runs on the real seed, returns the expected two rows (North INR 119,300; South INR 82,500), and uses the specified revenue definition and threshold.

## Task 5 — Five-part prompt for Scenario D2

**Role:** You are a spreadsheet troubleshooting analyst.

**Task:** Diagnose why a VLOOKUP returns “not found” even though the lookup item exists, then provide a repaired formula.

**Context:** The `products` tab occupies `A1:C10`, with headers in row 1, item names in column A and unit prices in column C. On the `orders` tab, cell `G2` contains ` Smart Watch` (a leading space before `Smart Watch`). The formula is `=VLOOKUP(G2, $A$2:$C$10, 3, FALSE)`. The expected behaviour is to return the matching product's unit price.

**Constraints:** Do not change the product table's correct item names. Use exact matching and remove unwanted whitespace from the lookup key. Do not use approximate matching.

**Format:** Explain the root cause in plain language and provide the repaired formula.

**Root cause:** The lookup value in `G2` starts with a leading space, so exact-match VLOOKUP searches for a different text string from `Smart Watch`.

**Repaired formula:** `=VLOOKUP(TRIM(G2), products!$A$2:$C$10, 3, FALSE)`

## Task 6 — Skeptical-analyst check on the first Part C recommendation

**Prompt:** “Act as a skeptical business analyst. Challenge my recommendation to run a targeted North promotion on the top-revenue category. Identify unstated assumptions, distinguish correlation from evidence of cause, and specify the exact data checks or additional evidence needed before claiming the promotion will increase revenue. Do not simply agree with the recommendation.”

| Unstated assumption | Data figure/check that would confirm or weaken it |
|---|---|
| The top-revenue category also has enough demand in North to justify a regional promotion. | Check the Region x Category Detail table for North's revenue in the chosen category and compare it with other North categories. |
| The lower October North revenue was caused by weaker promotion or exposure. | The current dataset has revenue and order counts by month, but no campaign-spend or exposure field; campaign records are needed to test causation. |
| Increasing promotion will raise incremental revenue rather than merely discount existing purchases. | Compare a controlled campaign group with a similar non-campaign group and track completed-order revenue, units, discount cost and margin. The current dataset does not include discount or margin fields. |
| Stock can support additional demand without creating stock-outs or excess inventory. | Check stock-on-hand and stock-out records by item and region; these fields are not present in this dataset. |
