/*
Dimesion Exploration
	--Exploring the dimensions of all tables to get useful insights
*/

-- Customers table dimension exploration

-- Getting the countries of our customers
SELECT DISTINCT
	country
FROM gold.dim_customers

-- Insights:
-- Customers are from 6 countries: Australia, Canada, France, Germany,
-- United Kingdom and United States.
-- There are also some n/a values.


-- Getting customer count by gender
SELECT 
	gender,
	COUNT(*) AS gender_count
FROM gold.dim_customers
GROUP BY gender

-- Insights:
-- Male customers = 9341
-- Female customers = 9128
-- n/a = 15
-- Male and female customers are almost equally distributed.
-- Only a very small number of records have n/a gender.


-- PRODUCT TABLE EXPLORATION

-- Checking products with their category and subcategory
SELECT DISTINCT
	category,
	subcategory,
	product_name
FROM gold.dim_products


-- Counting categories, subcategories and products
SELECT 
	COUNT(DISTINCT category) AS category_count,
	COUNT(DISTINCT subcategory) AS subcategory_count,
	COUNT(DISTINCT product_name) AS products_count
FROM gold.dim_products

-- Insights:
-- There are 4 categories, 36 subcategories and 295 products.


-- Checking products which don't have category or subcategory
SELECT DISTINCT
	product_name AS [products without category or subcategory]
FROM gold.dim_products
WHERE category IS NULL OR subcategory IS NULL

-- Insights:
-- 7 products don't have a category or subcategory.
-- These are:
-- HL Mountain Pedal
-- HL Road Pedal
-- LL Mountain Pedal
-- LL Road Pedal
-- ML Mountain Pedal
-- ML Road Pedal
-- Touring Pedal
-- These products may need to be checked because their product classification is missing.


-- Checking product count by product line
SELECT
	product_line,
	COUNT(*) AS product_line_count
FROM gold.dim_products
GROUP BY product_line

-- Insights:
--Mountain	91
--n/a	17
--Other Sales	35
--Road	100
--Touring	52
-- This shows how the 295 products are distributed across different product lines.
-- The result can be used to find which product line has the most products.