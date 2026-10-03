
CREATE VIEW gold.report_products AS

WITH basic_query AS (
    SELECT
        p.product_id,
        p.product_key,
        p.category,
        p.subcategory,
        p.product_name,
        p.cost,

        s.order_number,
        s.customer_key,
        s.order_date,
        s.quantity,
        s.sales_amount

    FROM gold.fact_sales AS s
    LEFT JOIN gold.dim_products AS p
        ON s.product_key = p.product_key
),

product_aggregations AS (
    SELECT
        product_id,
        product_key,
        category,
        subcategory,
        product_name,

        AVG(cost) AS avg_cost,
        SUM(quantity) AS total_quantity,
        SUM(sales_amount) AS total_sales,

        DATEDIFF(
            MONTH,
            MIN(order_date),
            MAX(order_date)
        ) AS lifespan,

        MAX(order_date) AS last_sale_date,

        COUNT(DISTINCT customer_key) AS total_customers,
        COUNT(DISTINCT order_number) AS total_orders,

        -- Average selling price
        AVG(
            CASE
                WHEN quantity = 0 THEN NULL
                ELSE sales_amount * 1.0 / quantity
            END
        ) AS avg_selling_price

    FROM basic_query

    GROUP BY
        product_id,
        product_key,
        category,
        subcategory,
        product_name
)

SELECT
    product_key,
    product_name,
    category,
    subcategory,

    avg_cost,
    last_sale_date,

    DATEDIFF(
        MONTH,
        last_sale_date,
        GETDATE()
    ) AS recency_in_months,

    CASE
        WHEN total_sales > 50000 THEN 'High-Performer'
        WHEN total_sales >= 10000 THEN 'Mid-Range'
        ELSE 'Low-Performer'
    END AS product_segment,

    lifespan,
    total_orders,
    total_sales,
    total_quantity,
    total_customers,
    avg_selling_price,

    -- Average Order Revenue
    CASE
        WHEN total_orders = 0 THEN 0
        ELSE total_sales * 1.0 / total_orders
    END AS avg_order_revenue,

    -- Average Monthly Revenue
    CASE
        WHEN lifespan = 0 THEN total_sales
        ELSE total_sales * 1.0 / lifespan
    END AS avg_monthly_revenue

FROM product_aggregations
where total_orders != total_quantity;