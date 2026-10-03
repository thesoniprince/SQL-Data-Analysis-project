/*
Measure Exploration
	--Exploring the measures in the fact table
*/

--Total sales amount
SELECT
	SUM(sales_amount) AS total_sales
FROM GOLD.fact_sales --29356250

--Insights:
--Total sales amount is 29,356,250.


--Average sales amount
SELECT
	AVG(sales_amount) AS avg_sales
FROM GOLD.fact_sales --486

--Insights:
--Average sales amount per sales record is 486.


--Total quantity sold
SELECT
	SUM(quantity) AS total_quantity
FROM GOLD.fact_sales --60423

--Insights:
--Total quantity sold is 60,423.


--Total number of orders
SELECT
	COUNT(DISTINCT order_number) AS total_orders
FROM GOLD.fact_sales --27659

--Insights:
--There are 27,659 distinct orders.


--Customers who placed orders
SELECT
	COUNT(DISTINCT customer_key) AS customers_placed_orders
FROM GOLD.fact_sales --18484

--Insights:
--18,484 customers have placed orders.


--Total customers
SELECT
	COUNT(customer_key) AS total_customers
FROM GOLD.dim_customers --18484

--Insights:
--There are 18,484 customers in the customer table.


--Products in product table
SELECT
	COUNT(product_key) AS total_products
FROM GOLD.dim_products --295

--Insights:
--There are 295 products in the product table.


--Products that have been sold
SELECT
	COUNT(DISTINCT product_key) AS products_sold
FROM GOLD.fact_sales --130

--Insights:
--130 different products have appeared in the sales table.


--Products never sold
SELECT
	(SELECT COUNT(product_key) FROM GOLD.dim_products)
	-
	(SELECT COUNT(DISTINCT product_key) FROM GOLD.fact_sales) AS [products never sold] --165

--Insights:
--165 products in the product table have no corresponding sales records.


--Products not sold
SELECT
	p.product_key,
	p.product_id,
	p.product_name
FROM GOLD.dim_products AS p
LEFT JOIN (
	SELECT DISTINCT
		product_key
	FROM GOLD.fact_sales
) AS s
	ON p.product_key = s.product_key
WHERE s.product_key IS NULL

--Insights:
--This gives the list of products that have no sales records.