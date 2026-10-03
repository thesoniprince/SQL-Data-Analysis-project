/*
PERFORMANCE ANALYSIS
*/

/* Analyze the yearly performance of products by comparing their sales 
to both the average sales performance of the product and the previous year's sales */

WITH yearly_product_sales AS (
SELECT
	YEAR(order_date) AS order_date,
	p.product_name,
	SUM(sales_amount) AS current_sales
FROM GOLD.fact_sales AS s
LEFT JOIN GOLD.dim_products AS p
ON s.product_key = p.product_key
WHERE s.order_date IS NOT NULL
GROUP BY YEAR(order_date), p.product_name
--ORDER BY YEAR(order_date) ASC
),

performance AS( --used to calculate performance
	SELECT
		*,
		AVG(current_sales) OVER(PARTITION BY product_name) avg_sales,
		current_sales - AVG(current_sales) OVER(PARTITION BY product_name) AS avg_diff,
		LAG(current_sales) OVER(PARTITION  by product_name ORDER BY order_date) AS prev_year_sales,
		current_sales - LAG(current_sales) OVER(PARTITION  by product_name ORDER BY order_date) AS prev_diff
	FROM yearly_product_sales
)

SELECT --final table with case statement
	order_date,
	product_name,
	current_sales,
	avg_sales,
	avg_diff,
    CASE
        WHEN current_sales > avg_sales THEN 'Above Avg'
        WHEN current_sales < avg_sales THEN 'Below Avg'
        ELSE 'Avg'
    END AS avg_change_flag,

	prev_year_sales,
	prev_diff,

	CASE
        WHEN current_sales > prev_year_sales THEN 'Increase'
        WHEN current_sales < prev_year_sales THEN 'Decrease'
        ELSE 'No Change'
    END AS py_change_flag
FROM performance
ORDER BY product_name ASC, order_date ASC