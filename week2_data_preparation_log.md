# Week 2 Data Preparation Log

## Purpose

This log documents the preparation and quality checks for the Maven Fuzzy Factory Week 2 analysis. Original CSV files were retained as source data. Cleaning and inspection were performed in Power BI Power Query; SQL Server tables were then imported for the required business queries.

## Source tables and observed row counts

| Source file | SQL table | Rows | Row meaning / primary key |
|---|---|---:|---|
| website_sessions.csv | dbo.website_sessions | 472,871 | One session; website_session_id |
| website_pageviews.csv | dbo.website_pageviews | 1,048,575 | One pageview; website_pageview_id |
| orders_mav.csv | dbo.orders_mav | 32,313 | One order; order_id |
| order_items.csv | dbo.order_items | 40,025 | One order item; order_item_id |
| order_item_refunds.csv | dbo.order_item_refunds | 1,731 | One refund record; order_item_refund_id |
| products (1).csv | dbo.products | 4 | One product; product_id |

## Power Query checks and preparation

- Imported each CSV through Power BI's Transform Data workflow.
- Reviewed column quality, distribution, and profiling against the full dataset.
- Checked primary-key fields for blanks and duplicates; checked foreign-key fields against their related tables.
- Standardized identifiers as whole numbers, timestamps as Date/Time, flags and item counts as whole numbers, and prices/costs/refunds as decimal or currency values.
- Trimmed and cleaned applicable text fields; preserved readable product-name capitalization and did not force all text to uppercase.
- Inspected marketing source, campaign, device, page URL, and referrer values for inconsistent text. Blank marketing sources were retained and analyzed as NULL/unattributed sessions.
- No row deletions were reported. The pageviews CSV was kept in Power Query/SQL rather than an Excel worksheet because of its size.

## Keys and model relationships

- website_sessions.website_session_id -> website_pageviews.website_session_id
- website_sessions.website_session_id -> orders_mav.website_session_id
- orders_mav.order_id -> order_items.order_id
- products.product_id -> order_items.product_id
- order_items.order_item_id -> order_item_refunds.order_item_id

The Power BI model uses one-to-many relationships with single-direction filtering. Refunds connect through order_item_id; a second direct relationship from refunds to orders was avoided to prevent ambiguous filter paths.

## SQL Server import types reviewed

- Session IDs and user IDs were changed from smallint to int; website_session_id was marked as the session table primary key.
- http_referer was widened to nvarchar(max) to avoid truncating URLs.
- Product names remained text; product_id was int and marked as the product primary key.
- For the other tables, primary-key IDs use int, created_at uses datetime2, identifiers use int, 0/1 flags use a small integer type, and monetary values use decimal or money.

## Reconciliation and limitations

- Order-level revenue: $1,938,509.75.
- Order-item revenue: $1,938,509.75. The totals reconcile.
- Four product rows are available. Product categories/types are not present in the supplied products table, so category-level performance cannot be reported.
- 83,328 sessions have a NULL marketing source. These are retained as unattributed rather than assigned to a channel.
- Device results report traffic volume by device, not device-specific conversion rates.
- Refund count is a count of refund records, not necessarily a count of unique refunded orders.

## Analysis definitions

- Gross revenue: SUM(orders_mav.price_usd).
- Product revenue: SUM(order_items.price_usd), grouped by product.
- Refund value: SUM(order_item_refunds.refund_amount_usd).
- Average order value: gross revenue divided by distinct order_id.
- Conversion rate: distinct sessions with an order divided by distinct sessions, multiplied by 100.
- Monthly revenue: order revenue grouped by the order created_at month.
