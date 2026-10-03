--PART TO WHOLE ANALYSIS

--CATEGORY
WITH category_sales AS (
    SELECT
        p.category,
        SUM(f.sales_amount) AS total_sales
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON p.product_key = f.product_key
    GROUP BY p.category
)
SELECT
    category,
    total_sales,
    SUM(total_sales) OVER () AS overall_sales,
    ROUND((CAST(total_sales AS FLOAT) / SUM(total_sales) OVER ()) * 100, 2) AS percentage_of_total
FROM category_sales
ORDER BY total_sales DESC;

--COUNTRY
WITH country_sales AS (
    SELECT
        c.country,
        SUM(sales_amount) AS total_sales
    FROM GOLD.fact_sales AS s
    LEFT JOIN GOLD.dim_customers AS c
    ON s.customer_key = c.customer_key

    GROUP BY country
)
SELECT
    *,
    ROUND((CAST(total_sales AS float) / SUM(total_sales) OVER()) * 100, 2) AS percantage_of_total
FROM country_sales