/*
==============================================================================
Script Name : 02_dimensions_exploration.sql
Purpose     : Explore dimension tables and their attributes
Layer       : Analytics / EDA
==============================================================================
*/

-- Explore all countries customers come from
SELECT DISTINCT
    country
FROM gold.dim_customers;

-- Explore product hierarchy (category, sub-category, product)
SELECT DISTINCT
    category,
    sub_category,
    product_name
FROM gold.dim_products
ORDER BY 1, 2, 3;

-- Find the youngest and oldest customers
SELECT
    MIN(birthdate) AS oldest_birthdate,
    DATEDIFF(YEAR, MIN(birthdate), GETDATE()) AS oldest_customer_age,
    MAX(birthdate) AS youngest_birthdate,
    DATEDIFF(YEAR, MAX(birthdate), GETDATE()) AS youngest_customer_age
FROM gold.dim_customers;

-- Total number of products
SELECT COUNT(product_number) AS total_products
FROM gold.dim_products;

SELECT COUNT(DISTINCT product_number) AS total_products_distinct
FROM gold.dim_products;

-- Total number of customers
SELECT COUNT(customer_number) AS total_customers
FROM gold.dim_customers;

SELECT COUNT(DISTINCT customer_number) AS total_customers_distinct
FROM gold.dim_customers;
