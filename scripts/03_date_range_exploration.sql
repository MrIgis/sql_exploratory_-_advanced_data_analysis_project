/*
==============================================================================
Script Name : 03_date_range_exploration.sql
Purpose     : Explore date coverage and time range of sales data
Layer       : Analytics / EDA
==============================================================================
*/

-- Find the first and last order dates
-- Determine how many years of sales data are available
SELECT
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS latest_order_date,
    DATEDIFF(YEAR, MIN(order_date), MAX(order_date)) AS years_of_sales
FROM gold.fact_sales;
