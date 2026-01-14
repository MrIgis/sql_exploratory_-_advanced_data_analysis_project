/*
==============================================================================
Script Name : 06_cumulative_analysis.sql
Purpose     : Analyze running totals of sales over time
Layer       : Advanced Analytics
==============================================================================
*/

-- ===============================
-- Monthly Running Total
-- ===============================

SELECT 
    order_date,
    total_sales,
    SUM(total_sales) OVER (ORDER BY order_date) AS running_total
FROM (
    SELECT
        DATETRUNC(MONTH, order_date) AS order_date,
        SUM(sales_amount) AS total_sales
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(MONTH, order_date)
) t;

-- ===============================
-- Yearly Running Total
-- ===============================

SELECT 
    YEAR(order_date) AS order_year,
    total_sales,
    SUM(total_sales) OVER (ORDER BY order_date) AS running_total
FROM (
    SELECT
        DATETRUNC(YEAR, order_date) AS order_date,
        SUM(sales_amount) AS total_sales
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(YEAR, order_date)
) t;
