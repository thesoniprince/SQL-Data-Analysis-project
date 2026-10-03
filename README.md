# SQL Data Analysis Project: Bike Retail Sales (2010-2014)

An end-to-end SQL analysis of a bicycle retailer's sales data. The project starts with exploratory data analysis (EDA), moves to advanced analytics (trends, cumulative totals, segmentation, part-to-whole), and ends with two reusable reporting views for customers and products.

> **Full findings:** see [`Analysis_Report.md`](Analysis_Report.md)

---

## Headline Results

| Metric | Value |
|---|---|
| Total revenue | **$29.36M** |
| Orders / Customers / Products sold | 27,659 / 18,484 / 130 of 295 |
| Average order value | $1,061 |
| Gross margin (using product cost) | ~39.8% |
| 2013 revenue growth vs 2012 | **+179.8%** |
| Bikes share of revenue | 96.5% |
| Top 2 countries (US + Australia) | 62.1% of revenue |
| One-time buyers | 62.9% of customers |
| VIP customers (8.9% of base) | 36.7% of revenue |

---

## Business Questions Answered

1. How is the database structured and how clean is the data?
2. How big is the business, and what does it sell and to whom?
3. How has revenue changed over time, and what drove the growth?
4. Which products, categories and countries matter most?
5. Which customers are the most valuable, and how do they behave?
6. Where are the retention and product-portfolio opportunities?

---

## Repository Structure

```
SQL-Data-Analysis-project/
├── Datasets/flat-files/
│   ├── dim_customers.csv        # 18,484 customers
│   ├── dim_products.csv         # 295 products
│   └── fact_sales.csv           # 60,398 order lines
├── EDA/                         # Exploratory scripts 01-06
├── Advance Analysis/            # Advanced scripts 07-13
├── All Scripts/                 # Every script in one place
├── images/                      # Charts used in the report
├── Analysis_Report.md           # Senior-analyst style report
└── README.md
```

---

## Data Model (Star Schema, `gold` schema)

```
dim_customers ──┐
                ├──< fact_sales >──┬── dim_products
(customer_key)  │   (order lines)  │   (product_key)
```

| Table | Grain | Rows | Key columns |
|---|---|---|---|
| `fact_sales` | one row per product per order | 60,398 | order_number, product_key, customer_key, order_date, shipping_date, due_date, sales_amount, quantity, price |
| `dim_customers` | one row per customer | 18,484 | customer_key, country, gender, marital_status, birthdate |
| `dim_products` | one row per product variant | 295 | product_key, category, subcategory, product_line, cost |

---

## Analysis Roadmap

### Part 1: Exploratory Data Analysis (`/EDA`)

| # | Script | What it does |
|---|---|---|
| 01 | `database_exploration` | Lists tables, columns, data types and constraints |
| 02 | `dimension_exploration` | Distinct countries, genders, categories, product lines |
| 03 | `date_exploration` | Date range of orders and customer birthdates |
| 04 | `measure_exploration` | Core KPIs: total sales, quantity, orders, customers |
| 05 | `magnitute_exploration` | Measures broken down by dimension (country, category, year) |
| 06 | `ranking_exploration` | Top/bottom products and customers with `RANK()` |

### Part 2: Advanced Analytics (`/Advance Analysis`)

| # | Script | Technique |
|---|---|---|
| 07 | `change_over_time_analysis` | Monthly trend with `YEAR()` / `MONTH()` aggregation |
| 08 | `cummulative_analysis` | Running totals with window functions |
| 09 | `performance_analysis` | Year-over-year and vs-average using `LAG()` and `AVG() OVER` |
| 10 | `data_segmentation` | `CASE` segmentation of products by cost and customers by behaviour |
| 11 | `part_to_whole_analysis` | Percentage contribution by category and country |
| 12 | `customer_report` | **View** `gold.report_customers` with segments, recency, AOV, monthly spend |
| 13 | `product_report` | **View** `gold.report_products` with segments, lifespan, avg selling price |

---

## SQL Skills Demonstrated

- Joins across a star schema (`LEFT JOIN`)
- CTEs for readable, layered logic
- Window functions: `RANK()`, `LAG()`, `SUM() OVER`, `AVG() OVER`
- Date functions: `DATEDIFF`, `DATETRUNC`, `YEAR`, `MONTH`
- Conditional logic with `CASE`
- Reusable reporting layer with `CREATE VIEW`
- Data-quality checks (nulls, orphan keys, unsold products)

---

## How to Run

**Requirements:** SQL Server 2022+ (`DATETRUNC` is used) or Azure SQL.

1. Create a database and a `gold` schema:
   ```sql
   CREATE DATABASE DataWarehouseAnalysis;
   GO
   USE DataWarehouseAnalysis;
   GO
   CREATE SCHEMA gold;
   ```
2. Import the three CSVs from `Datasets/flat-files/` into `gold.dim_customers`, `gold.dim_products` and `gold.fact_sales` (SSMS: *Tasks > Import Flat File*).
3. Run the scripts in numeric order, `01` to `13`.
4. Query the final views:
   ```sql
   SELECT * FROM gold.report_customers;
   SELECT * FROM gold.report_products;
   ```

---

## Key Insights (Summary)

- **Growth came from 2013.** Revenue rose from $5.84M (2012) to $16.34M (2013), driven by more customers and the launch of accessories and clothing in Dec 2012.
- **Bikes are the business.** Bikes give 96.5% of revenue and about 95% of gross profit. Mountain-200 variants alone give 27% of revenue.
- **Customer value is concentrated.** The top 10% of customers give 40% of revenue, and 5,155 customers (28%) give 80%.
- **Retention is the biggest lever.** 62.9% of customers bought once. The US has the largest base (7,482 customers) but the lowest repeat rate (23.2%).
- **The catalogue is mostly idle.** 165 of 295 products (56%) never sold, including all 127 Components.

---

## Data Quality Notes

- `fact_sales`: 19 rows have no `order_date` (0.02% of revenue).
- `dim_customers`: 337 customers have country `n/a`; 15 have gender `n/a`; 17 have no birthdate.
- `dim_products`: 7 pedal products have no category or subcategory.
- The raw tables carry no primary or foreign key constraints.
- Jan 2014 holds only 28 days and no bike sales, so it is excluded from trend analysis.

See the *Data Quality* and *Script Review* sections of the report for the full list and recommended fixes.

---

## Author

**thesoniprince**: [GitHub](https://github.com/thesoniprince)

*Feedback and suggestions are welcome. Please open an issue.*
