/*
RANKING
*/

--OVERALL PRODUCT RANKING
SELECT TOP 5
	s.product_key,
	p.category,
	p.subcategory,
	p.product_name,
	SUM(s.sales_amount) AS total_sales,
	RANK() OVER(ORDER BY SUM(s.sales_amount) DESC) AS rank
FROM GOLD.fact_sales AS s
LEFT JOIN gold.dim_products as p on  s.product_key = p.product_key
GROUP BY
	s.product_key,
	p.category,
	p.subcategory,
	p.product_name;

--CATEGORICAL RANKING for each product
WITH product_sales AS(
	SELECT
		s.product_key,
		p.category,
		p.subcategory,
		p.product_name,
		SUM(s.sales_amount) AS total_sales,
		RANK() OVER(PARTITION BY p.category ORDER BY SUM(s.sales_amount) DESC) AS rank
	FROM GOLD.fact_sales AS s
	LEFT JOIN gold.dim_products as p on  s.product_key = p.product_key
	GROUP BY
		s.product_key,
		p.category,
		p.subcategory,
		p.product_name
)

SELECT
	*
FROM product_sales
WHERE rank <= 5
ORDER BY total_sales DESC, category, rank

SELECT TOP 10
	c.customer_key,
	c.first_name,
	SUM(s.sales_amount) AS total_sales,
	RANK() OVER(ORDER BY SUM(s.sales_amount)) as rank
FROM GOLD.fact_sales AS s
LEFT JOIN GOLD.dim_customers AS c
ON s.customer_key = c.customer_key
GROUP BY
	c.customer_key,
	c.first_name	
ORDER BY total_sales DESC ;

--TOP PRODUCTS BY COUNTRY

--BY QUANTITY
WITH country_performance AS(
SELECT
	c.country,
	p.product_key,
	p.product_name,
	SUM(s.quantity) AS total_quantity_sold,
	RANK() OVER(PARTITION BY COUNTRY ORDER BY SUM(s.quantity) DESC) AS rank

FROM GOLD.fact_sales AS s
LEFT JOIN GOLD.dim_customers AS c
ON s.customer_key = c.customer_key
LEFT JOIN GOLD.dim_products AS p ON s.product_key = p.product_key
GROUP BY
	c.country,
	p.product_key,
	p.product_name
)
SELECT
	*
FROM country_performance
WHERE RANK = 1 ;

-- BY SALES

WITH country_performance AS(
SELECT
	c.country,
	p.product_key,
	p.product_name,
	SUM(s.sales_amount) AS total_sales,
	RANK() OVER(PARTITION BY COUNTRY ORDER BY SUM(s.sales_amount) DESC) AS rank

FROM GOLD.fact_sales AS s
LEFT JOIN GOLD.dim_customers AS c
ON s.customer_key = c.customer_key
LEFT JOIN GOLD.dim_products AS p ON s.product_key = p.product_key
GROUP BY
	c.country,
	p.product_key,
	p.product_name
)
SELECT
	*
FROM country_performance
WHERE RANK = 1


--fewest orders by customer based on orders count and total sales
SELECT TOP 10
	c.customer_key,
	c.first_name,
	COUNT(s.order_number) AS total_orders,
	SUM(s.sales_amount) as total_sales,
	RANK() OVER(ORDER BY SUM(s.sales_amount)) as rank
FROM GOLD.fact_sales AS s
LEFT JOIN GOLD.dim_customers AS c
ON s.customer_key = c.customer_key
GROUP BY
	c.customer_key,
	c.first_name	
ORDER BY total_orders, total_sales 


