-- ==========================================================
-- Maven Fuzzy Factory SQL Business Analysis
-- Author: Dinesh Adapa
-- Database: MySQL
-- Description:
-- This project analyzes an e-commerce database to evaluate
-- website performance, marketing effectiveness, product
-- performance, customer behavior, and business profitability.
-- ==========================================================

-- Create and select database

CREATE SCHEMA maven_toys;
USE maven_toys;

-- Display all tables available in the database

SHOW TABLES;

-- Preview products table

SELECT * FROM products;

-- ==========================================================
-- Explore Database Structure
-- ==========================================================

DESCRIBE orders;
DESCRIBE order_items;
DESCRIBE products;
DESCRIBE website_sessions;
DESCRIBE website_pageviews;
DESCRIBE order_item_refunds;

-- ==========================================================
-- Business Question 1
-- How many website sessions did the company receive?
-- ==========================================================

SELECT COUNT(*) AS total_sessions
FROM website_sessions;

-- ==========================================================
-- Business Question 2
-- How many orders were placed?
-- ==========================================================

SELECT COUNT(*) AS total_orders
FROM orders;

-- ==========================================================
-- Business Question 3
-- What is the website conversion rate?
-- ==========================================================

SELECT
    COUNT(DISTINCT o.order_id) * 100.0 /
    COUNT(DISTINCT ws.website_session_id) AS conversion_rate
FROM website_sessions ws
LEFT JOIN orders o
ON ws.website_session_id = o.website_session_id;

-- ==========================================================
-- Business Question 4
-- What is the total revenue generated?
-- ==========================================================

SELECT
    ROUND(SUM(price_usd),2) AS total_revenue
FROM orders;

-- ==========================================================
-- Business Question 5
-- What is the total profit earned?
-- ==========================================================

SELECT
    ROUND(SUM(price_usd - cogs_usd),2) AS total_profit
FROM orders;

-- ==========================================================
-- Business Question 6
-- Which marketing source generates the highest website traffic?
-- ==========================================================

SELECT
    utm_source,
    COUNT(*) AS total_sessions
FROM website_sessions
GROUP BY utm_source
ORDER BY total_sessions DESC;

-- ==========================================================
-- Business Question 7
-- Which marketing source generates the highest number of orders?
-- ==========================================================

SELECT
    ws.utm_source,
    COUNT(o.order_id) AS total_orders
FROM website_sessions ws
LEFT JOIN orders o
ON ws.website_session_id = o.website_session_id
GROUP BY ws.utm_source
ORDER BY total_orders DESC;

-- ==========================================================
-- Business Question 8
-- Which marketing source generates the highest revenue?
-- ==========================================================

SELECT
    ws.utm_source,
    ROUND(SUM(o.price_usd),2) AS total_revenue
FROM website_sessions ws
JOIN orders o
ON ws.website_session_id = o.website_session_id
GROUP BY ws.utm_source
ORDER BY total_revenue DESC;

-- ==========================================================
-- Business Question 9
-- Which marketing source has the highest conversion rate?
-- ==========================================================

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

-- ==========================================================
-- Business Question 10
-- Which products generate the highest revenue?
-- ==========================================================

SELECT
    p.product_name,
    ROUND(SUM(oi.price_usd),2) AS total_revenue
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_revenue DESC;

-- ==========================================================
-- Business Question 11
-- Which products generate the highest profit?
-- ==========================================================

SELECT
    p.product_name,
    ROUND(SUM(oi.price_usd - oi.cogs_usd),2) AS total_profit
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_profit DESC;

-- ==========================================================
-- Business Question 12
-- Which products have the highest sales volume?
-- ==========================================================

SELECT
    p.product_name,
    COUNT(*) AS total_items_sold
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_items_sold DESC;

-- ==========================================================
-- Business Question 13
-- Which products have the highest refund amount?
-- ==========================================================

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

-- ==========================================================
-- Business Question 14
-- Which products have the highest refund rate?
-- ==========================================================

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

-- ==========================================================
-- Business Question 15
-- What is the distribution of new and repeat website sessions?
-- ==========================================================

SELECT
    is_repeat_session,
    COUNT(*) AS total_sessions
FROM website_sessions
GROUP BY is_repeat_session;

-- Preview website sessions table

SELECT *
FROM website_sessions;

-- ==========================================================
-- Business Question 16
-- Which device type generates the most website sessions?
-- ==========================================================

SELECT
    device_type,
    COUNT(*) AS total_sessions
FROM website_sessions
GROUP BY device_type
ORDER BY total_sessions DESC;

-- ==========================================================
-- Business Question 17
-- Which device type has the highest conversion rate?
-- ==========================================================

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

-- ==========================================================
-- Business Question 18
-- Which website pages receive the highest number of visits?
-- ==========================================================

SELECT
    pageview_url,
    COUNT(*) AS visits
FROM website_pageviews
GROUP BY pageview_url
ORDER BY visits DESC;

-- ==========================================================
-- Business Question 19
-- At what hour of the day does the website receive the most traffic?
-- ==========================================================

SELECT
    HOUR(created_at) AS hour_of_day,
    COUNT(*) AS total_sessions
FROM website_sessions
GROUP BY hour_of_day
ORDER BY hour_of_day;

-- ==========================================================
-- Business Question 20
-- Which day of the week generates the highest number of orders?
-- ==========================================================

SELECT
    DAYNAME(created_at) AS day_name,
    COUNT(*) AS total_orders
FROM orders
GROUP BY day_name
ORDER BY total_orders DESC;
