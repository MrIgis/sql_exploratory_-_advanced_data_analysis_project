/*
==============================================================================
Script Name : 04_measures_exploration.sql
Purpose     : Explore core business measures (sales, quantity, orders)
Layer       : Analytics / EDA
==============================================================================
*/

-- Total sales
SELECT SUM(sales_amount) AS total_sales
FROM gold.fact_sales;

-- Total quantity sold
SELECT SUM(quantity) AS total_quantity
FROM gold.fact_sales;

-- Average selling price
SELECT AVG(price) AS average_price
FROM gold.fact_sales;

-- Total number of orders
SELECT COUNT(order_number) AS total_orders
FROM gold.fact_sales;

SELECT COUNT(DISTINCT order_number) AS total_orders_distinct
FROM gold.fact_sales;

-- Total number of customers who placed an order
SELECT COUNT(DISTINCT customer_key) AS active_customers
FROM gold.fact_sales;

-- Consolidated measures view
SELECT 'total_sales'        AS measure_name, SUM(sales_amount)              AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'total_quantity',    SUM(quantity)                                   FROM gold.fact_sales
UNION ALL
SELECT 'avg_price',         AVG(price)                                      FROM gold.fact_sales
UNION ALL
SELECT 'total_nr_orders',   COUNT(DISTINCT order_number)                    FROM gold.fact_sales
UNION ALL
SELECT 'total_nr_products', COUNT(DISTINCT product_number)                  FROM gold.dim_products
UNION ALL
SELECT 'total_nr_customers',COUNT(DISTINCT customer_number)                 FROM gold.dim_customers;
