/*
==============================================================================
VIEW NAME : gold.products_report
==============================================================================
Purpose:
    Provides product-level performance metrics and behavioral insights
    for analytical reporting and decision support.

Key Highlights:
    1. Captures essential product attributes:
        - Product name, category, sub-category, and cost
    2. Segments products by revenue performance:
        - High Performer, Mid-Range, Low Performer
    3. Aggregates product-level metrics:
        - Total orders
        - Total sales and quantity sold
        - Total unique customers
        - Product lifespan (months)
    4. Calculates analytical KPIs:
        - Recency (months since last sale)
        - Average order revenue (AOR)
        - Average monthly revenue
============================================================================== 
*/

CREATE OR ALTER VIEW gold.products_report AS 

-- ==========================================================
-- 1) Base Query: Join fact sales with product attributes
-- ==========================================================
WITH base_query AS (
    SELECT 
        f.order_number,
        f.customer_key,
        f.order_date,
        f.sales_amount,
        f.quantity,
        p.product_key,
        p.product_name,
        p.category,
        p.sub_category,
        p.product_cost
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON f.product_key = p.product_key
    WHERE order_date IS NOT NULL
),

-- ==========================================================
-- 2) Product Aggregations: Metrics at product grain
-- ==========================================================
product_aggregations AS (
    SELECT 
        product_key, 
        product_name,
        category,
        sub_category,
        product_cost,
        ROUND(
            AVG(CAST(sales_amount AS FLOAT) / NULLIF(quantity, 0)), 
            1
        ) AS avg_selling_price,
        DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan,
        COUNT(DISTINCT customer_key) AS total_customers,
        COUNT(DISTINCT order_number) AS total_orders,
        SUM(quantity) AS total_quantity_sold,
        SUM(sales_amount) AS total_sales,
        MAX(order_date) AS last_sale_date
    FROM base_query
    GROUP BY 
        product_key,
        product_name,
        category,
        sub_category,
        product_cost
)

-- ==========================================================
-- 3) Final Output: Product KPIs & Segmentation
-- ==========================================================
SELECT 
    product_key,
    product_name,
    category,
    sub_category,
    product_cost,
    avg_selling_price,
    lifespan,
    CASE
        WHEN total_sales > 5000 THEN 'High Performer'
        WHEN total_sales >= 1000 THEN 'Mid-Range'
        ELSE 'Low Performer'
    END AS product_segment,
    last_sale_date,
    DATEDIFF(MONTH, last_sale_date, GETDATE()) AS recency,
    total_customers,
    total_orders,
    total_quantity_sold,
    total_sales,
    -- Average order revenue (AOR)
    CASE
        WHEN total_orders = 0 THEN 0
        ELSE ROUND(CAST(total_sales AS FLOAT) / total_orders, 2)
    END AS avg_order_revenue,
    -- Average monthly revenue
    CASE
        WHEN lifespan = 0 THEN total_sales
        ELSE ROUND(CAST(total_sales AS FLOAT) / lifespan, 2)
    END AS avg_monthly_revenue
FROM product_aggregations;

-- Optional validation
SELECT *
FROM gold.products_report
WHERE product_segment LIKE 'High%';
