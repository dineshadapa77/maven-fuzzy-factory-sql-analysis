CREATE SCHEMA maven_toys;
USE maven_toys;
 show tables
 
 select * from products;
 
 
 DESCRIBE orders;
DESCRIBE order_items;
DESCRIBE products;
DESCRIBE website_sessions;
DESCRIBE website_pageviews;
DESCRIBE order_item_refunds;




SELECT COUNT(*) AS total_sessions
FROM website_sessions;


SELECT COUNT(*) AS total_orders
FROM orders;


SELECT
    COUNT(DISTINCT o.order_id) * 100.0 /
    COUNT(DISTINCT ws.website_session_id) AS conversion_rate
FROM website_sessions ws
LEFT JOIN orders o
ON ws.website_session_id = o.website_session_id;

SELECT
    ROUND(SUM(price_usd),2) AS total_revenue
FROM orders;



SELECT
    ROUND(SUM(price_usd - cogs_usd),2) AS total_profit
FROM orders;


SELECT
    utm_source,
    COUNT(*) AS total_sessions
FROM website_sessions
GROUP BY utm_source
ORDER BY total_sessions DESC;


SELECT
    ws.utm_source,
    COUNT(o.order_id) AS total_orders
FROM website_sessions ws
LEFT JOIN orders o
ON ws.website_session_id = o.website_session_id
GROUP BY ws.utm_source
ORDER BY total_orders DESC;


SELECT
    ws.utm_source,
    ROUND(SUM(o.price_usd),2) AS total_revenue
FROM website_sessions ws
JOIN orders o
ON ws.website_session_id = o.website_session_id
GROUP BY ws.utm_source
ORDER BY total_revenue DESC;



SELECT
    ws.utm_source,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT ws.website_session_id) AS total_sessions,
    ROUND(
        COUNT(DISTINCT o.order_id) * 100.0 /
        COUNT(DISTINCT ws.website_session_id),
        2
    ) AS conversion_rate
FROM website_sessions ws
LEFT JOIN orders o
ON ws.website_session_id = o.website_session_id
GROUP BY ws.utm_source
ORDER BY conversion_rate DESC;



SELECT
    p.product_name,
    ROUND(SUM(oi.price_usd),2) AS total_revenue
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_revenue DESC;



SELECT
    p.product_name,
    ROUND(SUM(oi.price_usd - oi.cogs_usd),2) AS total_profit
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_profit DESC;

SELECT
    p.product_name,
    COUNT(*) AS total_items_sold
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_items_sold DESC;


SELECT
    p.product_name,
    ROUND(SUM(r.refund_amount_usd),2) AS total_refund
FROM order_item_refunds r
JOIN order_items oi
ON r.order_item_id = oi.order_item_id
JOIN products p
ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_refund DESC;



SELECT
    p.product_name,
    COUNT(r.order_item_refund_id) AS refunded_items,
    COUNT(oi.order_item_id) AS sold_items,
    ROUND(
        COUNT(r.order_item_refund_id) * 100.0 /
        COUNT(oi.order_item_id),
        2
    ) AS refund_rate
FROM order_items oi
LEFT JOIN order_item_refunds r
ON oi.order_item_id = r.order_item_id
JOIN products p
ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY refund_rate DESC;


SELECT
    is_repeat_session,
    COUNT(*) AS total_sessions
FROM website_sessions
GROUP BY is_repeat_session;



select * from website_sessions



SELECT
    device_type,
    COUNT(*) AS total_sessions
FROM website_sessions
GROUP BY device_type
ORDER BY total_sessions DESC;

SELECT
    ws.device_type,
    COUNT(DISTINCT ws.website_session_id) AS sessions,
    COUNT(DISTINCT o.order_id) AS orders,
    ROUND(
        COUNT(DISTINCT o.order_id) * 100.0 /
        COUNT(DISTINCT ws.website_session_id),
        2
    ) AS conversion_rate
FROM website_sessions ws
LEFT JOIN orders o
ON ws.website_session_id = o.website_session_id
GROUP BY ws.device_type
ORDER BY conversion_rate DESC;


SELECT
    pageview_url,
    COUNT(*) AS visits
FROM website_pageviews
GROUP BY pageview_url
ORDER BY visits DESC;


SELECT
    HOUR(created_at) AS hour_of_day,
    COUNT(*) AS total_sessions
FROM website_sessions
GROUP BY hour_of_day
ORDER BY hour_of_day;


SELECT
    DAYNAME(created_at) AS day_name,
    COUNT(*) AS total_orders
FROM orders
GROUP BY day_name
ORDER BY total_orders DESC;