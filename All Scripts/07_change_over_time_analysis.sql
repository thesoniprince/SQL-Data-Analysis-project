/*
CHANGE OVER TME ANALYSIS
*/
SELECT
	YEAR(order_date) AS year,
	MONTH(order_date) AS month,
	SUM(sales_amount) AS total_sales,
	COUNT(distinct customer_key) as total_customers,
	SUM(quantity) as quantity_sold
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY YEAR(order_date), MONTH(order_date)
