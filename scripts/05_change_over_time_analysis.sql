/*
==============================================================================
Script Name : 05_change_over_time_analysis.sql
Purpose     : Analyze sales performance trends over time (yearly & monthly)
Layer       : Advanced Analytics
============================================================================== 
*/

-- ===============================
-- Yearly Sales Overview
-- ===============================

SELECT 
    YEAR(order_date) AS order_year,
    SUM(sales_amount) AS total_sales
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY order_year;

-- Using DATETRUNC for consistency
SELECT 
    DATETRUNC(YEAR, order_date) AS order_year,
    SUM(sales_amount) AS total_sales
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(YEAR, order_date)
ORDER BY order_year;

-- ===============================
-- Yearly Detailed Metrics
-- ===============================

SELECT 
    YEAR(order_date) AS order_year,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY order_year;

-- ===============================
-- Monthly Analysis
-- ===============================

SELECT 
    YEAR(order_date)  AS order_year,
    MONTH(order_date) AS order_month,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY order_year, order_month;

-- Formatted year-month view
SELECT
    FORMAT(order_date, 'yyyy-MMM') AS order_period,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY FORMAT(order_date, 'yyyy-MMM')
ORDER BY order_period;
