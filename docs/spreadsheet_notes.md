# Spreadsheet Cleaning and Pivot Notes

## Setup
- Spreadsheet tool: Google Sheets.
- Tabs created: `orders` and `products`; the filtered-and-sorted values were copied to `completed_orders`.
- Rows imported into `orders`: 90 data rows (plus the header).
- `products` tab range: `A1:C10` (header plus 9 products).
- Before creating `completed_orders`, filtered `status` to `completed` and sorted `amount` largest to smallest. The 63 visible rows were pasted as values.
- `order_month` was kept as plain text, e.g. `2026-09`.
- Missing-key fallback test: `=XLOOKUP("Mystery Item",$A$2:$A$10,$C$2:$C$10,"UNKNOWN_ITEM")` returns `UNKNOWN_ITEM` (on a sheet where the products range is in columns A:C).

## Formulas (first data row; fill down)
Assuming the imported `orders` columns are A:J in this order: `order_id`, `order_month`, `first_name`, `last_name`, `region`, `rep_name`, `item`, `quantity`, `amount`, `status`; the formulas below refer to those columns.
- `clean_first_name` (K2): `=PROPER(TRIM(C2))`
- `clean_last_name` (L2): `=PROPER(TRIM(D2))`
- `category` (M2): `=VLOOKUP(G2,products!$A$2:$C$10,2,FALSE)`
- `unit_price` (N2): `=XLOOKUP(G2,products!$A$2:$A$10,products!$C$2:$C$10,"UNKNOWN_ITEM")`
- `revenue_calc` (O2): `=N2*H2`

The lookup ranges are absolute so they do not drift when formulas are filled down. The `XLOOKUP` fallback is tested separately because all seed items exist in the products table.

## Completed-order aggregates
The `completed_orders` tab contains 63 completed rows. The amount summary is:
| Metric | Spreadsheet result |
| --- | --- |
| COUNT | 63 |
| SUM | 346200 |
| AVERAGE | 5495.24 |
| MIN | 1100 |
| MAX | 15600 |

## Pivot table (i): Sum of amount by category and region
Rows = `category`; columns = `region`; values = SUM of `amount`.

| category | East | North | South | West | Grand Total |
| --- | --- | --- | --- | --- | --- |
| Apparel | 10600 | 19400 | 10000 | 37500 | 77500 |
| Electronics | 21400 | 73400 | 28700 | 18800 | 142300 |
| Home | 37500 | 26500 | 43800 | 18600 | 126400 |
| Grand Total | 69500 | 119300 | 82500 | 74900 | 346200 |

## Pivot table (ii): Sum of amount and count of order_id by month
Rows = `order_month`; values = SUM of `amount` and COUNT of `order_id`.

| order_month | SUM of amount | COUNT of order_id |
| --- | --- | --- |
| 2026-09 | 98300 | 19 |
| 2026-10 | 93100 | 20 |
| 2026-11 | 154800 | 24 |
| Grand Total | 346200 | 63 |

## Reconciliation
| Metric | Spreadsheet | Part A q05 | Match/Mismatch |
| --- | --- | --- | --- |
| COUNT | 63 | 63 | Match |
| SUM | 346200 | 346200 | Match |
| AVERAGE | 5495.24 | 5495.24 | Match |

## Data validation
- **Missing amounts:** q02 identifies the three missing amounts in orders 1001, 1010 and 1064. They are pending orders, so they are excluded from completed-order revenue. The blank values are preserved in `orders_enriched.csv`; no imputation is applied because the brief defines revenue using the recorded `amount` on completed orders only.
- **Data types:** `order_id`, `quantity`, `unit_price`, `amount` and `revenue_calc` are numeric values; `order_month` is text. In Google Sheets, set `order_month` to Plain text before import/pivoting and verify that values still look like `2026-09`.
- **Duplicates:** No duplicate `order_id` values exist in the 90-row source data.
- **Largest amount / outlier check:** The largest completed-order `amount` is INR 15600; order IDs with that amount: 1061, 1065, 1069, 1077. These are high-value observations to inspect, not automatically errors.
- **Inherited-sheet decision:** Keep `amount` as the source-of-truth revenue field and retain `revenue_calc` only as a validation column; investigate any mismatch rather than silently overwriting the source amount.
