SELECT
	MIN(order_date),
	MAX(order_date)
FROM GOLD.fact_sales --2010-12-29	2014-01-28

SELECT
	DATEDIFF(YEAR, MIN(order_date),MAX(order_date)) as order_range_in_years
FROM GOLD.fact_sales --4 years

SELECT
	MAX(birthdate) AS oldest_birthdate,
	MIN(birthdate) AS youngest_birthdate,
	DATEDIFF(YEAR, MAX(birthdate), getdate()) as oldest_age,
	DATEDIFF(YEAR, MIN(birthdate), getdate()) as youngest_age
FROM GOLD.dim_customers --1986-06-25	1916-02-10	40	110

select * from gold.fact_sales
