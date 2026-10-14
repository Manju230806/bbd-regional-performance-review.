# Big Billion Days Regional Performance Review

**Project title:** Big Billion Days Regional Performance Review — SQL, Spreadsheet, Dashboard and AI-Verified Analysis

## Tools and assumptions
- **SQL compiler:** SQLite in-memory execution for validation; SQL dialect: SQLite.
- **Spreadsheet tool:** Google Sheets (formulas documented in `docs/spreadsheet_notes.md`).
- **Dashboard in Tableau Public:** No; the dashboard is specified in `docs/dashboard_spec.md` as allowed by the brief.
- **Assumption:** Revenue is the sum of `amount` for `completed` orders only. Missing amounts are left blank in the exported raw data and are not imputed. `revenue_calc` is `unit_price × quantity`; it is retained as a check and does not replace the brief's revenue definition (`amount`).

## Three important findings
1. The completed-order revenue is INR 346,200 across 63 completed orders; the average completed order value is INR 5,495.24.
2. North is the largest regional revenue contributor in the completed-order dataset, but its revenue falls from September to October; the AI claim of 38% growth is contradicted by the query result.
3. The product, region and month tables in the dashboard specification reconcile to the same INR 346,200 revenue total, giving managers a consistent basis for comparing performance.

## File index
| File | Part | Purpose |
|---|---|---|
| `sql/00_schema_and_seed.sql` | A | Creates and seeds all four source tables |
| `sql/q01.sql`–`sql/q13.sql` | A | Required SQL reporting queries |
| `sql/d1_corrected.sql` | D | Corrected regional revenue query |
| `results/query_results.md` | A, D | Seed checks and query outputs |
| `data/orders_enriched.csv` | A | Full 90-row q09 order-level fact table |
| `data/orders_clean.csv` | B | 63 completed orders, cleaned and enriched |
| `docs/spreadsheet_notes.md` | B | Formulas, aggregates, pivots, validation and reconciliation |
| `docs/dashboard_spec.md` | C | Dashboard fields, KPI cards, chart data, layout and recommendations |
| `docs/ai_log.md` | D | Prompt design, AI response verification and human-in-the-loop log |

All project files are plain text or CSV, as required by the brief.
