--country
SELECT
	country,
	COUNT(*) AS total_customers
FROM GOLD.dim_customers
GROUP BY country
ORDER BY total_customers

SELECT
	country,
	SUM(s.quantity) as total_sold_item,
	SUM(s.sales_amount) AS total_sales
FROM GOLD.dim_customers AS c
LEFT JOIN GOLD.fact_sales AS s
ON c.customer_key = s.customer_key
GROUP BY country
ORDER BY total_sales DESC

--customer
SELECT
	customer_key,
	COUNT(*) times_purchased,
	SUM(sales_amount) as total_sales
FROM GOLD.fact_sales
GROUP BY customer_key
ORDER BY total_sales DESC

SELECT
	gender,
	COUNT(*) AS gender_count
FROM GOLD.dim_customers
GROUP BY gender
ORDER BY gender_count DESC

---- products
SELECT
	category,
	COUNT(*) total_products
FROM GOLD.dim_products
GROUP BY category
ORDER BY total_products DESC

SELECT TOP 10
	product_key,
	COUNT(*) as total_product_sold
FROM GOLD.fact_sales
GROUP BY product_key
ORDER BY total_product_sold DESC

SELECT
	category,
	AVG(cost) avg_cost
FROM GOLD.dim_products
GROUP BY category
ORDER BY avg_cost DESC

SELECT
	p.category,
	AVG(p.cost) avg_cost,
	AVG(s.sales_amount) AS avg_sales,
	SUM(s.sales_amount) total_sales
FROM GOLD.dim_products AS p
LEFT JOIN GOLD.fact_sales AS s
ON p.product_key = s.product_key
GROUP BY category
ORDER BY total_sales DESC

--time
SELECT
	YEAR(order_date),
	SUM(sales_amount) AS total_sales
FROM GOLD.fact_sales
GROUP BY YEAR(order_date)
ORDER BY total_sales DESC
