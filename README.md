# Maven Fuzzy Factory — E-commerce Performance Analysis

Week 2 assignment for the AnalystLab Africa Experience Lab Internship Programme.

## Project objective

Analyze Maven Fuzzy Factory's historical website sessions, pageviews, orders, products, order items, and refunds. Use SQL Server to answer business questions and Power BI to present performance metrics and recommendations.

## Tools

- Power Query in Power BI for data review and preparation
- SQL Server Management Studio for SQL analysis
- Power BI Desktop for the interactive report

## Source files

The analysis uses the supplied CSV files:

- `website_sessions.csv`
- `website_pageviews.csv`
- `orders_mav.csv`
- `order_items.csv`
- `order_item_refunds.csv`
- `products (1).csv`
- `maven_fuzzy_factory_data_dictionary.csv`

Keep source CSVs unchanged. Record any cleanup or label changes in the data preparation log.

## Data model

The report relates website sessions to orders, orders to order items, order items to products, and order items to refunds. Website pageviews relate to website sessions. Review the relationship keys and cardinality in Power BI before refresh.

## Preparation

Data was reviewed in Power Query for field meaning, data types, missing values, and key consistency. The marketing source blank was labelled `Unattributed` for reporting. See `week2_data_preparation_log.md` for the documented preparation steps.

## SQL analysis

The SQL script answers the assignment questions, including unique orders, revenue, top products, sessions by source and device, conversion rate, refunds, monthly revenue, and average order value. Run `week2_sql_analysis.sql` in SQL Server Management Studio after importing the source tables.

## Power BI report

The report includes KPI cards for total orders, total revenue, average order value, website sessions, conversion rate, and total refunds. Its visuals cover revenue by month, top-performing products, sales by product, sessions by marketing source and device type, and refund amount by month. Device Type and Year slicers are interactive.

## Key results

| Metric | Result |
|---|---:|
| Unique orders | 32,313 |
| Total revenue | $1,938,509.75 |
| Average order value | $59.99 |
| Website sessions | 472,871 |
| Session-to-order conversion rate | 6.83% |
| Refund records | 1,731 |
| Total refund value | $85,338.69 |
| Highest-revenue month | December 2014 — $144,823.02 |
| Lowest-revenue month | March 2012 — $2,999.40 |

## Product performance

| Product | Items sold | Revenue |
|---|---:|---:|
| The Original Mr. Fuzzy | 24,226 | $1,211,057.74 |
| The Forever Love Bear | 5,796 | $347,702.04 |
| The Birthday Sugar Panda | 4,985 | $229,260.15 |
| The Hudson River Mini bear | 5,018 | $150,489.82 |

The provided product data has no category/type field, so category-level comparisons were not possible.

## Business recommendations

1. Protect availability and promotion planning for The Original Mr. Fuzzy, which contributes the largest share of revenue.
2. Compare conversion and revenue by marketing source, not session volume alone, before reallocating marketing spend.
3. Investigate the mobile journey because mobile contributes substantial traffic and should be assessed for conversion friction.
4. Monitor refund amounts over time and investigate product or process causes of peaks.
5. Use the monthly revenue pattern to plan inventory and campaigns around stronger demand periods.
6. Track sessions without a recorded source and improve campaign tagging so attribution is more complete.
7. Review the smallest-revenue product for product-page, pricing, merchandising, and inventory opportunities.

## Deliverables

- `week2_sql_analysis.sql` — SQL queries
- `week2_data_preparation_log.md` — cleaning and transformation notes
- `week2_analytical_report.pdf` — report and findings
- Power BI `.pbix` — interactive dashboard
- Dashboard walkthrough `.mp4` — recorded demonstration

## Limitations

The findings describe the supplied historical dataset. They do not establish why a trend occurred. Marketing-source blanks are reported as `Unattributed`. No product category/type field was supplied.
