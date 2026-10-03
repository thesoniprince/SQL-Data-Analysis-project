# Sales Performance & Customer Analysis: Bike Retail (Dec 2010 - Jan 2014)

**Prepared by:** thesoniprince
**Data source:** `gold.fact_sales` (60,398 order lines), `gold.dim_customers` (18,484), `gold.dim_products` (295)
**Scope:** EDA, trend analysis, segmentation, profitability, data-quality review, recommendations

---

## 1. Executive Summary

The business generated **$29.36M** in revenue from **27,659 orders** and **18,484 customers** over 37 months. Growth was back-loaded: **2013 produced $16.34M (55.7% of all revenue), up 179.8% on 2012**, after a 17.4% decline in 2012. The business is highly concentrated in three ways: in a single category (bikes), in a handful of models (Mountain-200 and Road-150), and in a minority of customers.

| KPI | Value |
|---|---|
| Total revenue | $29,356,250 |
| Gross profit (revenue less standard product cost) | ~$11.69M (**39.8%** margin) |
| Orders / order lines / units | 27,659 / 60,398 / 60,423 |
| Average order value (AOV) | $1,061 (median $595) |
| Revenue per customer | $1,588 mean vs **$272 median** |
| Products sold / catalogue | 130 of 295 (44%) |
| Repeat-customer rate | 37.1% (62.9% bought once) |

**Five findings that matter most**

1. **2013 was a step-change, not gradual growth.** Active customers jumped from 3,255 (2012) to 17,427 (2013). Monthly active customers went from 627 in Jan 2013 to 1,373 in Feb 2013 (+119% in one month). The cause is not in the data and should be identified.
2. **Bikes are 96.5% of revenue and ~95% of gross profit.** Accessories and clothing, launched Dec 2012, add only 3.5% of revenue, but accessories carry a 62.8% margin against 39.2% for bikes.
3. **Revenue is concentrated in a few models.** The six Mountain-200 variants give **27.0%** of total revenue and the top 10 products give **42.5%**.
4. **Retention is the largest untapped lever.** The US has the biggest customer base (7,482) but a **23.2% repeat rate**; Australia reaches **71.9%**. Overall, 62.9% of customers have bought only once.
5. **Two scripts in the repo return wrong results** (product report and cumulative analysis), and the customer age logic depends on the date the script is run. These are fixed in Section 9 and should be corrected before the views are used for reporting.

---

## 2. Scope, Data & Method

- **Period:** 29 Dec 2010 to 28 Jan 2014 (37 months). The script comment gives "4 years", but `DATEDIFF(YEAR)` counts calendar-year boundaries; the true span is 3 years 1 month.
- **Full years used for trends:** 2011, 2012, 2013. Dec 2010 (3 days) and Jan 2014 (28 days, no bike sales) are partial and are excluded from growth comparisons.
- **Reconciliation:** results were replicated outside SQL and tied back to the totals recorded in your scripts: total sales 29,356,250, quantity 60,423, orders 27,659, customers 18,484, products sold 130. All match.
- **Gross profit** = `sales_amount - (cost x quantity)`, using `dim_products.cost` as unit cost. This is a standard-cost proxy, not actual margin.
- **Customer age** is calculated as of the last order date (28 Jan 2014), not today's date.
- Percentages are of total revenue unless stated.

---

## 3. Data Quality Assessment

| Issue | Scale | Impact | Action |
|---|---|---|---|
| Orders with no `order_date` | 19 rows, $4,992 (0.02%) | Negligible; excluded from time series | Backfill or drop |
| Customers with country `n/a` | 337 (1.8%), $226,820 (0.8%) | Slightly understates country totals | Source from CRM |
| Customers with gender `n/a` / no birthdate | 15 / 17 | Negligible | Document |
| Products with no category or subcategory | 7 pedals (HL/ML/LL Mountain, HL/ML/LL Road, Touring) | None sold, but break category reporting | Classify as Components |
| Products with `product_line = n/a` | 17 | Minor | Classify |
| No primary or foreign keys, all columns nullable | All 3 tables | Risk of duplicates and orphan keys | Add PK/FK constraints |
| `create_date` (customers) | Runs 6 Oct 2025 to 27 Jan 2026, long after the last sale (Jan 2014) | Unusable for cohort analysis | Treat as a load date |
| Bike orders stop on 28 Dec 2013 while other lines continue to 28 Jan 2014 | Jan 2014 | Jan 2014 not comparable | Confirm whether data is incomplete |
| Shipping lag is exactly 7 days and due lag exactly 12 days on all rows | 60,379 shipped lines | No delivery-performance signal | Likely synthetic or defaulted |
| 99.98% of lines have `quantity = 1` | 60,387 of 60,398 | Quantity is effectively a line counter | Interpret "units" as lines |

**Positives:** no duplicate order lines, no orphan product or customer keys, and `sales_amount = price x quantity` on every row.

---

## 4. Revenue Trend

![Monthly revenue by category](images/01_monthly_revenue_by_category.png)

| Year | Revenue | YoY | Orders | Active customers | Avg order value |
|---|---|---|---|---|---|
| 2011 | $7,075,088 | n/a | 2,216 | 2,216 | $3,193 |
| 2012 | $5,842,231 | **-17.4%** | 3,269 | 3,255 | $1,787 |
| 2013 | $16,344,878 | **+179.8%** | 21,287 | 17,427 | $768 |

![Annual revenue](images/02_annual_revenue.png)

**What the numbers say**

- **2012 was a revenue decline despite higher volume.** Bike units grew 47% (2,216 to 3,269) while average bike price fell from $3,193 to $1,786. This is consistent with a shift toward lower-priced models, though price and mix effects have not been separated here.
- **2013 was driven by customers, not price.** Bike units tripled (3,269 to 9,704) at an average price of $1,582.
- **AOV fell from $3,193 to $768 because the order mix changed.** In 2013, 54.4% of orders contained no bike and averaged just $51. Bike orders averaged $1,624. Falling AOV here reflects accessory-only orders, not weaker bike orders.
- **Strong exit run-rate.** Revenue rose from $858K (Jan 2013) to $1.87M (Dec 2013), a 2.2x increase. Q4 2013 was $5.33M against $2.68M in Q1 (+99%), with consistent quarter-on-quarter growth ($2.68M, $3.97M, $4.36M, $5.33M).
- **Cumulative revenue** reached $7.1M by Dec 2011, $13.0M by Dec 2012 and $29.3M by Dec 2013. More than half of lifetime revenue was earned in the final 12 months.

**Caution:** with one strong year and no prior-year seasonality, no seasonal pattern can be reliably claimed. Rising Q1 to Q4 in 2013 is growth, not necessarily seasonality.

---

## 5. Category & Profitability

| Category | Revenue | % of revenue | Units | Avg line value | Gross margin |
|---|---|---|---|---|---|
| Bikes | $28,316,272 | **96.5%** | 15,205 | $1,862 | 39.2% |
| Accessories | $700,262 | 2.4% | 36,112 | $19 | **62.8%** |
| Clothing | $339,716 | 1.2% | 9,106 | $37 | 40.2% |
| Components | $0 | 0% | 0 | n/a | n/a |

**Bike sub-categories**

| Sub-category | Revenue | % of bike revenue | Margin | Gross profit |
|---|---|---|---|---|
| Road Bikes | $14.52M | 51.3% | 36.5% | $5.30M |
| Mountain Bikes | $9.95M | 35.1% | **43.8%** | $4.35M |
| Touring Bikes | $3.84M | 13.6% | 37.8% | $1.45M |

**Insights**

- Accessories are 60% of units sold but 2.4% of revenue. They are a traffic and attach driver, not a revenue driver.
- Mountain bikes earn about 7 margin points more than road bikes, yet road bikes carry more revenue. A mix shift toward mountain would raise blended margin.
- By product line: Road 49.8%, Mountain 34.9%, Touring 13.2%, Other Sales 2.1%.
- **Attach rate:** in 2013, **87.6%** of orders containing a bike also contained an accessory or clothing item. Basket attachment is already high, so the growth opportunity is basket size and standalone accessory orders, not attach.

---

## 6. Product Performance

**Top 5 products by revenue**

| Rank | Product | Revenue | Units | % of total |
|---|---|---|---|---|
| 1 | Mountain-200 Black-46 | $1,373,454 | 620 | 4.68% |
| 2 | Mountain-200 Black-42 | $1,363,128 | 614 | 4.64% |
| 3 | Mountain-200 Silver-38 | $1,339,394 | 596 | 4.56% |
| 4 | Mountain-200 Silver-46 | $1,301,029 | 580 | 4.43% |
| 5 | Mountain-200 Black-38 | $1,294,854 | 582 | 4.41% |

**By model family (bikes)**

| Family | Revenue | % of bike revenue |
|---|---|---|
| Mountain-200 | $7.93M | 28.0% |
| Road-150 | $5.55M | 19.6% |
| Road-250 | $4.45M | 15.7% |
| Touring-1000 | $2.99M | 10.6% |
| Road-350 / Road-550 | $1.58M / $1.51M | 5.6% / 5.3% |

**Volume leaders (units)** are all low-ticket: Water Bottle 30 oz (4,249), Patch Kit (3,191), Mountain Tire Tube (3,096), Road Tire Tube (2,376), Sport-100 Helmet Red (2,230). The best-selling item by units generates only $21K (0.07% of revenue).

**Catalogue utilisation**

- **165 of 295 products (56%) have never sold:** all 127 Components, 15 Clothing, 9 Bikes (Road-450 Red in 5 sizes and Mountain-300 Black in 4 sizes), 7 Accessories and the 7 unclassified pedals.
- Using the thresholds in your product report: **66 High-Performers** (> $50K), **58 Mid-Range** ($10K-$50K) and **6 Low-Performers** (< $10K) among the 130 sold products.
- Catalogue cost bands (all 295 products): 110 under $100, 101 at $100-500, 45 at $500-1,000 and 39 above $1,000. Bike unit cost ranges from $295 to $2,171.

**Year-on-year product movement (script 09):** in 2013, 62 products grew, 3 declined and 37 were new. The 42 "decreases" flagged in 2014 are an artefact of comparing one month to a full year and should be ignored.

**Concentration risk:** one model family (Mountain-200) carries 27% of total revenue. A supply or pricing problem there would be material.

---

## 7. Geography

![Country revenue vs repeat rate](images/03_country_revenue_vs_repeat_rate.png)

| Country | Customers | Revenue | % revenue | Revenue / customer | AOV | Orders / customer | Repeat rate |
|---|---|---|---|---|---|---|---|
| United States | 7,482 | $9,162,327 | 31.2% | $1,225 | $993 | 1.23 | **23.2%** |
| Australia | 3,591 | $9,060,172 | 30.9% | **$2,523** | $1,349 | 1.87 | **71.9%** |
| United Kingdom | 1,913 | $3,391,376 | 11.6% | $1,773 | $1,119 | 1.58 | 45.1% |
| Germany | 1,780 | $2,894,066 | 9.9% | $1,626 | $1,165 | 1.40 | 28.1% |
| France | 1,810 | $2,643,751 | 9.0% | $1,461 | $1,064 | 1.37 | 25.3% |
| Canada | 1,571 | $1,977,738 | 6.7% | $1,259 | $586 | 2.15 | 46.1% |
| Unknown (`n/a`) | 337 | $226,820 | 0.8% | $673 | $673 | 1.00 | 0% |

**Insights**

- **US and Australia together give 62.1% of revenue**, but through different engines. The US wins on customer count (40.5% of customers), Australia on value per customer (2x the US).
- **Australia is the retention benchmark.** It has half the customers of the US but nearly the same revenue, driven by repeat buying.
- **Canada is a different profile:** the highest order frequency (2.15) but the lowest AOV ($586). Non-bike items are 7.9% of Canadian revenue against 2.3% in Australia, so Canadian customers buy more often and smaller.
- **The highest-value individual customers are in Europe and Australia.** The top 100 customers by spend are 36 French, 27 German, 21 UK and 16 Australian, with none from the US or Canada. The five highest spenders are all French customers with 5 orders and about $13.2-13.3K each.
- **Best-selling product by country:** Mountain-200 leads revenue in five of six markets (Black-46 in the US and France, Black-42 in the UK and Canada, Silver-46 in Germany), while Road-150 Red-62 leads in Australia.

---

## 8. Customer Analysis

### 8.1 Concentration

| Cut | Share of revenue |
|---|---|
| Top 1% of customers (184) | 5.6% |
| Top 10% (1,848) | 40.3% |
| Top 20% (3,696) | 66.4% |
| Customers needed for 80% of revenue | 5,155 (27.9%) |

The distribution is heavily skewed: **mean spend $1,588, median $272**. Half of all customers have spent under $272, which is mostly accessories-only buyers.

### 8.2 Segmentation (as defined in the customer report)

![Customer segments](images/04_customer_segments.png)

| Segment | Rule | Customers | % of base | Revenue | % of revenue | Avg spend |
|---|---|---|---|---|---|---|
| VIP | lifespan >= 12 months and spend > $5,000 | 1,653 | 8.9% | $10.76M | **36.7%** | $6,510 |
| Regular | lifespan >= 12 months, spend <= $5,000 | 2,200 | 11.9% | $7.50M | 25.6% | $3,411 |
| New | lifespan < 12 months | 14,629 | 79.2% | $11.09M | 37.8% | $758 |

**Interpretation:** VIPs are 8.9% of customers and 36.7% of revenue. The "New" segment is large because 12,521 customers (67.7%) made their first purchase in 2013, so they cannot yet have a 12-month lifespan. The rule also labels 79 customers who spent over $5,000 as "New". Treat the segment as a lifecycle label, not a value label.

### 8.3 Behaviour

- **Repeat rate: 37.1%.** 11,619 customers bought once, 5,454 twice, 1,166 three times.
- **Customer acquisition by first-order year:** 2011: 2,216 | 2012: 3,225 | 2013: 12,521. Of the 17,427 customers active in 2013, 4,906 had bought in an earlier year and 12,521 were new.
- **Recency (as of 28 Jan 2014):** average 5.8 months since last order; 36.3% bought within the last 3 months; 3.0% have been inactive for more than 12 months.

### 8.4 Demographics

| Dimension | Group | Customers | Revenue / customer |
|---|---|---|---|
| Age (at 28 Jan 2014) | 20-29 | 1,129 | $1,487 |
| | **30-49** | **11,726** | **$1,680** |
| | 50-69 | 5,127 | $1,475 |
| | 70+ | 483 | $732 |
| Gender | Female | 9,128 | $1,622 |
| | Male | 9,341 | $1,554 |
| Marital status | Single | 8,473 | $1,672 |
| | Married | 10,011 | $1,517 |

- The core customer is aged 30-49 (63% of customers, about 67% of revenue). Average age is 44.8; the youngest customer is 27.6.
- Customers aged 70+ spend less than half the average.
- Gender is balanced (49.4% female, 50.5% male). Single customers spend about 10% more than married ones. These differences are modest and **have not been tested for statistical significance**.

---

## 9. Review of the SQL Scripts

These issues affect correctness or reproducibility. Items 1 to 3 should be fixed first.

| # | Script | Issue | Severity |
|---|---|---|---|
| 1 | `13_product_report` | `WHERE total_orders != total_quantity` removes every product where each order contained one unit. This **drops 120 of 130 products, 99.1% of revenue ($29.09M)**, so the view returns only 10 rows. | **High** |
| 2 | `08_cummulative_analysis` | `SUM() OVER (PARTITION BY order_date ORDER BY order_date)` partitions by the same column it sums over, so each row's "cumulative" value equals its own monthly sales. | **High** |
| 3 | `12_customer_report` | Age and recency use `GETDATE()`, so results change on each run date. As of 2026 the youngest customer is 40, so the `below 20` and `20-29` buckets are empty. `'20-29'` and `'29-49'` also overlap at 29. | **High** |
| 4 | `06_ranking_exploration` | Customer rank uses `RANK() OVER (ORDER BY SUM(...))` ascending while rows are sorted descending, so "rank 1" is the lowest spender. | Medium |
| 5 | `03_date_exploration` | `DATEDIFF(YEAR)` returns 4 for a 37-month span; `oldest_birthdate`/`youngest_birthdate` labels are swapped (`MAX(birthdate)` is the youngest). | Medium |
| 6 | `01_database_exploration` | Finds no keys or constraints; none were added afterwards. | Medium |
| 7 | `04_measure_exploration` | `AVG(sales_amount)` on an integer column truncates (486 vs 486.05). Cast to decimal. | Low |
| 8 | `09_performance_analysis` | A partial final year (2014) is flagged as "Decrease" for 42 products. | Low |

**Suggested fixes**

```sql
-- 08: true running total
SELECT order_date,
       total_sales,
       SUM(total_sales) OVER (ORDER BY order_date) AS cumulative_sales
FROM (
    SELECT DATETRUNC(MONTH, order_date) AS order_date,
           SUM(sales_amount)            AS total_sales
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(MONTH, order_date)
) t;

-- 13: remove the WHERE total_orders != total_quantity filter entirely.
-- If the intent was to exclude zero-sales rows, use: WHERE total_sales > 0

-- 12: anchor age and recency to the data, not the run date
-- add to base_query:
CROSS JOIN (SELECT MAX(order_date) AS as_of FROM gold.fact_sales) d
-- then use DATEDIFF(YEAR, c.birthdate, d.as_of) and DATEDIFF(MONTH, last_order, d.as_of)
-- and use non-overlapping age buckets:
CASE WHEN age < 20 THEN 'below 20'
     WHEN age BETWEEN 20 AND 29 THEN '20-29'
     WHEN age BETWEEN 30 AND 49 THEN '30-49'
     WHEN age BETWEEN 50 AND 69 THEN '50-69'
     ELSE '70+' END

-- 06: rank descending
RANK() OVER (ORDER BY SUM(s.sales_amount) DESC)
```

---

## 10. Recommendations

| Priority | Recommendation | Evidence | KPI to track |
|---|---|---|---|
| 1 | **Launch a repeat-purchase programme in the US, Germany and France** (follow-up offers, accessory replenishment, post-purchase email). Use Australia as the benchmark and study what drives its 71.9% repeat rate. | Repeat rate 23.2% / 28.1% / 25.3% vs 71.9%. Illustratively, 10 more repeat customers per 100 in the US is about 748 customers; at the US AOV of $993 that is roughly $0.74M. This is an assumption-based estimate, not a forecast. | Repeat rate, orders per customer |
| 2 | **Investigate and replicate the Feb 2013 acquisition step-change.** | Active customers +119% month on month; 12,521 new customers in 2013. | Cost per acquisition, new customers per month |
| 3 | **Build a VIP retention and referral programme.** | 1,653 VIPs give 36.7% of revenue; top 10% give 40.3%. | VIP count, VIP churn |
| 4 | **Raise accessory basket value and push mountain bikes.** | Accessories margin 62.8%; mountain bikes 43.8% vs road 36.5%. 54% of 2013 orders were accessory-only at $51 AOV. | Blended margin, items per order |
| 5 | **Reduce dependence on Mountain-200 and Road-150.** | 27% of revenue from six Mountain-200 variants. | Top-10 product share |
| 6 | **Rationalise the catalogue.** Confirm whether the 127 Components and 9 unsold bike variants are planned launches or dead SKUs, or whether the fact table is missing data. | 165 of 295 products never sold. | Active SKU ratio |
| 7 | **Tailor Canada.** Highest frequency, lowest basket: bundle bikes with accessories. | Orders per customer 2.15, AOV $586. | Canada AOV |
| 8 | **Fix data and script issues** (Section 3 and Section 9). | High-severity script errors; missing keys; Jan 2014 gap. | Number of open issues |

---

## 11. Limitations & Next Steps

**Limitations**

- Cost is standard cost per product, so margins are estimates; no discounts, returns, freight or marketing costs are included.
- Only one year of strong growth exists, so seasonality and long-run trend cannot be established.
- Quantity is almost always 1, so unit-based metrics are line-based.
- Shipping and due dates are constant, so no service-level analysis is possible.
- Demographic differences were not tested for significance.

**Suggested next steps**

1. Fix scripts 08, 12 and 13 and re-run the views.
2. Add a returns and discount source so true margin can be measured.
3. Build a cohort retention table using first-order month (not `create_date`).
4. Calculate customer lifetime value by acquisition channel once channel data is available.
5. Connect the two views to a BI dashboard (Power BI or Tableau) for ongoing monitoring.

---

## Appendix: Metric Definitions

| Metric | Definition |
|---|---|
| Revenue | `SUM(sales_amount)` |
| AOV | Revenue / distinct `order_number` |
| Repeat rate | Share of customers with more than one distinct order |
| Lifespan | Months between a customer's first and last order |
| Recency | Months between last order and 28 Jan 2014 |
| Gross profit | `sales_amount - cost x quantity` |
| Attach rate | Share of bike-containing orders that also contain an accessory or clothing line |
