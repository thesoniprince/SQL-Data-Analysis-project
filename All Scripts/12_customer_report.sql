create view gold.report_customers as

with base_query as (
	select
		c.customer_id,
		CONCAT(c.first_name, ' ', c.last_name) as customer_name,
		DATEDIFF(YEAR, birthdate, GETDATE()) as age,
		c.gender,
		c.country,
		c.customer_key,
		c.customer_number,
		s.order_date,
		--DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) as life_span,
		s.order_number,
		s.product_key,
		s.quantity,
		s.sales_amount
	from gold.fact_sales as s
	left join gold.dim_customers as c
	on c.customer_key = s.customer_key
	where order_date is not null
),
aggregation_query as (
	select
		customer_key,
		customer_number,
		customer_name,
		gender,
		country,
		age,
		SUM(quantity) as total_quantity,
		SUM(sales_amount) as total_sales,
		COUNT(distinct order_number) as total_orders,
		COUNT(distinct product_key) as total_products,
		DATEDIFF(MONTH, MIN(order_date), max(order_date)) as lifespan,
		MAX(order_date) as last_order
	from base_query
	group by
		customer_key,
		customer_number,
		customer_name,
		gender,
		country,
		age
)
select
		customer_key,
		customer_number,
		customer_name,
		gender,
		country,
		age,
		total_quantity,
		total_sales,
		total_orders,
		total_products,
		case 
			when age<20 then 'below 20'
			when age between 20 and 29 then '20-29'
			when age between 29 and 49 then '29-49'
			when age between 50 and 70 then '50-70'
			when age > 70 then 'above 70'
		end as age_category,
		lifespan,
		CASE 
			WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
			WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'regular'
			ELSE 'new'
		END AS customer_segment,
		last_order,
		DATEDIFF(MONTH, last_order, GETDATE()) as recency,

		--avg order value
		case 
			when total_sales = 0 then 0 
			else total_sales/total_orders
		end as avg_order_value,

		--avg onthly spend
		case 
			when lifespan = 0 then 0
			else total_sales/lifespan
		end as avg_monthly_spend

from aggregation_query
