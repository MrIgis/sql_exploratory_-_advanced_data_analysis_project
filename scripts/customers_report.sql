/*
==============================================================================
VIEW NAME : gold.customers_report
==============================================================================
Purpose:
    Consolidates customer-level metrics and behavioral insights to support
    analytical reporting and segmentation.

Key Highlights:
    1. Captures essential customer attributes:
        - Customer identity, demographics, and geography
        - Transaction history and activity dates
    2. Segments customers by:
        - Age group
        - Behavioral segment (VIP, Regular, New)
    3. Aggregates customer-level performance metrics:
        - Total orders
        - Total products purchased
        - Total sales and quantity
        - Customer lifespan (months)
    4. Calculates analytical KPIs:
        - Recency (months since last order)
        - Average order value
        - Average monthly spend
============================================================================== 
*/

CREATE VIEW gold.customers_report AS 

-- ==========================================================
-- 1) Base Query: Join fact sales with customer attributes
-- ==========================================================
WITH base_query AS (
    SELECT 
        f.order_number,
        c.customer_key,
        f.product_key,
        f.order_date,
        f.sales_amount,
        f.quantity,
        c.customer_number,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        c.country,
        c.gender,
        DATEDIFF(YEAR, c.birthdate, GETDATE()) AS age
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_customers c
        ON f.customer_key = c.customer_key
),

-- ==========================================================
-- 2) Customer Aggregations: Metrics at customer grain
-- ==========================================================
customer_aggregation AS (
    SELECT 
        customer_key,
        customer_number,
        customer_name,
        country,
        gender,
        age,
        COUNT(DISTINCT order_number) AS total_orders,
        COUNT(DISTINCT product_key) AS total_products,
        DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan,
        SUM(sales_amount) AS total_sales,
        SUM(quantity) AS total_quantity_purchased,
        MAX(order_date) AS last_order_date
    FROM base_query
    GROUP BY 
        customer_key,
        customer_number,
        customer_name,
        country,
        gender,
        age
)

-- ==========================================================
-- 3) Final Output: Customer KPIs & Segmentation
-- ==========================================================
SELECT
    customer_key,
    customer_number,
    customer_name,
    country,
    gender,
    age,
    CASE
        WHEN age < 20 THEN 'Under 20'
        WHEN age BETWEEN 20 AND 29 THEN '20–29'
        WHEN age BETWEEN 30 AND 39 THEN '30–39'
        WHEN age BETWEEN 40 AND 49 THEN '40–49'
        ELSE '50 and above'
    END AS age_group,
    CASE
        WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
        WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
        ELSE 'New'
    END AS customer_segment,
    last_order_date,
    DATEDIFF(MONTH, last_order_date, GETDATE()) AS recency,
    total_orders,
    total_products,
    lifespan,
    total_sales,
    total_quantity_purchased,
    -- Average order value
    CASE
        WHEN total_orders = 0 THEN 0
        ELSE total_sales / total_orders
    END AS avg_order_value,
    -- Average monthly spend
    CASE 
        WHEN lifespan = 0 THEN total_sales
        ELSE total_sales / lifespan
    END AS avg_monthly_spend
FROM customer_aggregation;
