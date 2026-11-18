-- AnalystLab Africa Experience Lab - Week 2
-- Maven Fuzzy Factory SQL business analysis
-- SQL Server / SSMS
-- Source tables are dbo.website_sessions, dbo.website_pageviews,
-- dbo.orders_mav, dbo.order_items, dbo.order_item_refunds, and dbo.products.

-- Q1. Total unique orders (expected: 32,313)
SELECT COUNT(DISTINCT order_id) AS total_unique_orders
FROM dbo.orders_mav;
GO

-- Q2. Gross revenue from orders (expected: $1,938,509.75)
SELECT SUM(price_usd) AS total_revenue_usd
FROM dbo.orders_mav;
GO

-- Q3. Top five products by item revenue.
-- Four products are present in the supplied products table, so four rows are expected.
SELECT TOP 5
    p.product_id,
    CAST(p.product_name AS nvarchar(100)) AS product_name,
    COUNT(*) AS items_sold,
    SUM(oi.price_usd) AS product_revenue_usd
FROM dbo.order_items AS oi
JOIN dbo.products AS p
    ON p.product_id = oi.product_id
GROUP BY p.product_id, CAST(p.product_name AS nvarchar(100))
ORDER BY product_revenue_usd DESC;
GO

-- Q4. Product category/type performance is unavailable because the supplied
-- products table has no category or type field.

-- Q5. Sessions by marketing source. NULL represents sessions with no source recorded.
SELECT
    utm_source AS marketing_source,
    COUNT(DISTINCT website_session_id) AS total_sessions
FROM dbo.website_sessions
GROUP BY utm_source
ORDER BY total_sessions DESC;
GO

-- Q6. Sessions by device type
SELECT
    device_type,
    COUNT(DISTINCT website_session_id) AS total_sessions
FROM dbo.website_sessions
GROUP BY device_type
ORDER BY total_sessions DESC;
GO

-- Q7. Session-to-order conversion rate.
-- Definition: distinct sessions with an order / all distinct website sessions.
SELECT
    COUNT(DISTINCT s.website_session_id) AS total_sessions,
    COUNT(DISTINCT o.website_session_id) AS sessions_with_orders,
    CAST(
        100.0 * COUNT(DISTINCT o.website_session_id)
        / NULLIF(COUNT(DISTINCT s.website_session_id), 0)
        AS decimal(10,2)
    ) AS conversion_rate_percent
FROM dbo.website_sessions AS s
LEFT JOIN dbo.orders_mav AS o
    ON o.website_session_id = s.website_session_id;
GO

-- Q8. Refund record count and refunded value.
-- Refund records are not necessarily the same as unique refunded orders.
SELECT
    COUNT(DISTINCT order_item_refund_id) AS refund_records,
    SUM(refund_amount_usd) AS total_refunds_usd
FROM dbo.order_item_refunds;
GO

-- Q9a. Highest-revenue month among months with orders
SELECT TOP 1
    YEAR(created_at) AS revenue_year,
    DATENAME(MONTH, created_at) AS revenue_month,
    SUM(price_usd) AS monthly_revenue_usd
FROM dbo.orders_mav
GROUP BY YEAR(created_at), MONTH(created_at), DATENAME(MONTH, created_at)
ORDER BY SUM(price_usd) DESC;
GO

-- Q9b. Lowest-revenue month among months with orders
SELECT TOP 1
    YEAR(created_at) AS revenue_year,
    DATENAME(MONTH, created_at) AS revenue_month,
    SUM(price_usd) AS monthly_revenue_usd
FROM dbo.orders_mav
GROUP BY YEAR(created_at), MONTH(created_at), DATENAME(MONTH, created_at)
ORDER BY SUM(price_usd) ASC;
GO

-- Q10. Average order value (gross revenue / unique orders)
SELECT
    CAST(
        SUM(price_usd) / NULLIF(COUNT(DISTINCT order_id), 0)
        AS decimal(12,2)
    ) AS average_order_value_usd
FROM dbo.orders_mav;
GO

-- Reconciliation check: order-level revenue and item-level revenue should agree.
SELECT
    (SELECT SUM(price_usd) FROM dbo.orders_mav) AS order_revenue_usd,
    (SELECT SUM(price_usd) FROM dbo.order_items) AS order_item_revenue_usd;
GO

-- Item revenue and units sold by product (keeps every item in the result).
SELECT
    oi.product_id,
    COALESCE(MAX(CAST(p.product_name AS nvarchar(100))), N'Product name missing') AS product_name,
    COUNT(*) AS items_sold,
    SUM(oi.price_usd) AS product_revenue_usd
FROM dbo.order_items AS oi
LEFT JOIN dbo.products AS p
    ON p.product_id = oi.product_id
GROUP BY oi.product_id
ORDER BY product_revenue_usd DESC;
GO
