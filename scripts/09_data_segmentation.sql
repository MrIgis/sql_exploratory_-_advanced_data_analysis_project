/*
==============================================================================
Script Name : 09_data_segmentation.sql
Purpose     : Segment products and customers for behavioral analysis
Layer       : Advanced Analytics
==============================================================================
*/

-- ===============================
-- Product Cost Segmentation
-- ===============================

WITH product_segments AS (
    SELECT 
        product_key,
        product_name,
        product_cost,
        CASE 
            WHEN product_cost < 100 THEN 'Below 100'
            WHEN product_cost BETWEEN 100 AND 500 THEN '100–500'
            WHEN product_cost BETWEEN 500 AND 1000 THEN '500–1000'
            ELSE 'Above 1000'
        END AS cost_range
    FROM gold.dim_products
)
SELECT
    cost_range,
    COUNT(product_key) AS total_products
FROM product_segments
GROUP BY cost_range
ORDER BY total_products DESC;

-- ===============================
-- Customer Segmentation
-- ===============================

WITH customer_ranking AS (
    SELECT 
        c.customer_key,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        MIN(f.order_date) AS first_order_date,
        MAX(f.order_date) AS latest_order_date,
        DATEDIFF(MONTH, MIN(f.order_date), MAX(f.order_date)) AS customer_lifespan_months,
        SUM(f.sales_amount) AS total_spending,
        CASE 
            WHEN SUM(f.sales_amount) > 5000 
                 AND DATEDIFF(MONTH, MIN(f.order_date), MAX(f.order_date)) >= 12 
                 THEN 'VIP'
            WHEN SUM(f.sales_amount) <= 5000 
                 AND DATEDIFF(MONTH, MIN(f.order_date), MAX(f.order_date)) >= 12 
                 THEN 'Regular'
            ELSE 'New'
        END AS customer_segment
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_customers c
        ON f.customer_key = c.customer_key
    GROUP BY c.customer_key, CONCAT(c.first_name, ' ', c.last_name)
)
SELECT 
    customer_segment,
    COUNT(customer_key) AS total_customers
FROM customer_ranking
GROUP BY customer_segment
ORDER BY total_customers DESC;
