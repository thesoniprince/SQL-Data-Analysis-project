SELECT
	order_date,
	total_sales,
	SUM(total_sales) OVER(PARTITION BY order_date ORDER BY order_date) AS cumulative_sales
FROM
(
	SELECT
		DATETRUNC(MONTH, order_date) AS order_date,
		SUM(sales_amount) AS total_sales
	FROM GOLD.fact_sales
	WHERE order_date IS NOT NULL
	GROUP BY DATETRUNC(MONTH, order_date)	
) t

