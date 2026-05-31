-- =============================================================
--  SALES DATA ANALYSIS - SQL Assignment
--  Author  : [Your Name]
--  Dataset : Sales Dataset (CSV → SQLite / MySQL / PostgreSQL)
-- =============================================================


-- =============================================================
-- SECTION 1 : LOAD / CREATE DATASET
-- =============================================================

-- If using SQLite, create the table and import from CSV.
-- Adjust column types to match your actual dataset.

CREATE TABLE IF NOT EXISTS sales (
    order_id       INTEGER,
    order_date     DATE,
    customer_id    VARCHAR(20),
    customer_name  VARCHAR(100),
    region         VARCHAR(50),
    category       VARCHAR(50),
    sub_category   VARCHAR(50),
    product_name   VARCHAR(200),
    quantity       INTEGER,
    unit_price     DECIMAL(10, 2),
    discount       DECIMAL(5, 2),
    sales          DECIMAL(10, 2),
    profit         DECIMAL(10, 2)
);

-- SQLite: load CSV via CLI →  .mode csv
--                             .import sales_data.csv sales
-- MySQL : LOAD DATA INFILE 'sales_data.csv' INTO TABLE sales
--         FIELDS TERMINATED BY ',' ENCLOSED BY '"'
--         LINES TERMINATED BY '\n'
--         IGNORE 1 ROWS;


-- =============================================================
-- SECTION 2 : EXPLORE THE TABLE
-- =============================================================

-- 2a. View table schema (SQLite)
PRAGMA table_info(sales);

-- 2b. Sample rows
SELECT *
FROM   sales
LIMIT  10;

-- 2c. Total row count
SELECT COUNT(*) AS total_rows
FROM   sales;

-- 2d. Column-level null / missing check
SELECT
    COUNT(*)                          AS total_rows,
    COUNT(order_id)                   AS order_id_filled,
    COUNT(customer_id)                AS customer_id_filled,
    COUNT(sales)                      AS sales_filled,
    COUNT(profit)                     AS profit_filled
FROM sales;

-- 2e. Distinct values in key categorical columns
SELECT DISTINCT region   FROM sales ORDER BY region;
SELECT DISTINCT category FROM sales ORDER BY category;


-- =============================================================
-- SECTION 3 : WHERE FILTERS
-- =============================================================

-- 3a. Filter by region
SELECT *
FROM   sales
WHERE  region = 'West'
LIMIT  10;

-- 3b. Filter by category
SELECT *
FROM   sales
WHERE  category = 'Technology';

-- 3c. Filter by date range
SELECT *
FROM   sales
WHERE  order_date BETWEEN '2023-01-01' AND '2023-12-31';

-- 3d. Filter by minimum sales threshold
SELECT *
FROM   sales
WHERE  sales >= 500
ORDER  BY sales DESC;

-- 3e. Combined multi-condition filter
SELECT *
FROM   sales
WHERE  region   = 'East'
  AND  category = 'Furniture'
  AND  order_date >= '2023-01-01';


-- =============================================================
-- SECTION 4 : GROUP BY AGGREGATIONS
-- =============================================================

-- 4a. Total sales by region
SELECT
    region,
    ROUND(SUM(sales), 2)    AS total_sales,
    COUNT(*)                AS order_count
FROM   sales
GROUP  BY region
ORDER  BY total_sales DESC;

-- 4b. Total sales and quantity by category
SELECT
    category,
    ROUND(SUM(sales),    2) AS total_sales,
    SUM(quantity)           AS total_quantity,
    ROUND(AVG(sales),    2) AS avg_order_sales
FROM   sales
GROUP  BY category;

-- 4c. Sales by sub-category
SELECT
    sub_category,
    ROUND(SUM(sales),   2)  AS total_sales,
    ROUND(AVG(profit),  2)  AS avg_profit
FROM   sales
GROUP  BY sub_category
ORDER  BY total_sales DESC;

-- 4d. Average sales per region
SELECT
    region,
    ROUND(AVG(sales), 2) AS avg_sales
FROM   sales
GROUP  BY region;

-- 4e. Profit by region and category
SELECT
    region,
    category,
    ROUND(SUM(profit),  2)  AS total_profit,
    ROUND(AVG(profit),  2)  AS avg_profit
FROM   sales
GROUP  BY region, category
ORDER  BY total_profit DESC;


-- =============================================================
-- SECTION 5 : SORT & LIMIT — TOP PRODUCTS / CATEGORIES
-- =============================================================

-- 5a. Top 10 products by total sales
SELECT
    product_name,
    ROUND(SUM(sales), 2) AS total_sales,
    SUM(quantity)        AS units_sold
FROM   sales
GROUP  BY product_name
ORDER  BY total_sales DESC
LIMIT  10;

-- 5b. Top 5 categories by total quantity sold
SELECT
    category,
    SUM(quantity) AS total_quantity
FROM   sales
GROUP  BY category
ORDER  BY total_quantity DESC
LIMIT  5;

-- 5c. Bottom 5 sub-categories by profit (loss leaders)
SELECT
    sub_category,
    ROUND(SUM(profit), 2) AS total_profit
FROM   sales
GROUP  BY sub_category
ORDER  BY total_profit ASC
LIMIT  5;


-- =============================================================
-- SECTION 6 : BUSINESS USE-CASE QUERIES
-- =============================================================

-- 6a. Monthly sales trend
SELECT
    STRFTIME('%Y-%m', order_date) AS month,   -- SQLite
    -- DATE_FORMAT(order_date, '%Y-%m')        -- MySQL
    -- TO_CHAR(order_date, 'YYYY-MM')          -- PostgreSQL
    ROUND(SUM(sales),  2) AS monthly_sales,
    COUNT(*)              AS total_orders
FROM   sales
GROUP  BY month
ORDER  BY month;

-- 6b. Top 10 customers by total spend
SELECT
    customer_id,
    customer_name,
    ROUND(SUM(sales),  2) AS total_spend,
    COUNT(*)              AS total_orders
FROM   sales
GROUP  BY customer_id, customer_name
ORDER  BY total_spend DESC
LIMIT  10;

-- 6c. Most ordered product (by quantity)
SELECT
    product_name,
    SUM(quantity) AS total_quantity
FROM   sales
GROUP  BY product_name
ORDER  BY total_quantity DESC
LIMIT  1;

-- 6d. Region-wise monthly sales trend
SELECT
    region,
    STRFTIME('%Y-%m', order_date) AS month,
    ROUND(SUM(sales), 2)          AS monthly_sales
FROM   sales
GROUP  BY region, month
ORDER  BY region, month;

-- 6e. High-discount orders (discount > 30%)
SELECT
    order_id,
    product_name,
    discount,
    ROUND(sales,  2) AS sales,
    ROUND(profit, 2) AS profit
FROM   sales
WHERE  discount > 0.30
ORDER  BY discount DESC;

-- 6f. Orders resulting in a loss (negative profit)
SELECT
    order_id,
    product_name,
    region,
    ROUND(sales,  2) AS sales,
    ROUND(profit, 2) AS profit
FROM   sales
WHERE  profit < 0
ORDER  BY profit ASC;

-- 6g. Detect duplicate order IDs
SELECT
    order_id,
    COUNT(*) AS occurrences
FROM   sales
GROUP  BY order_id
HAVING COUNT(*) > 1;

-- 6h. Category contribution to overall sales (%)
SELECT
    category,
    ROUND(SUM(sales), 2)                                        AS category_sales,
    ROUND(SUM(sales) * 100.0 / (SELECT SUM(sales) FROM sales), 2) AS pct_of_total
FROM   sales
GROUP  BY category
ORDER  BY category_sales DESC;


-- =============================================================
-- SECTION 7 : DATA VALIDATION & QUALITY CHECKS
-- =============================================================

-- 7a. Count rows after each major filter to verify logic
SELECT COUNT(*) AS west_region_rows   FROM sales WHERE region = 'West';
SELECT COUNT(*) AS technology_rows    FROM sales WHERE category = 'Technology';
SELECT COUNT(*) AS high_sales_rows    FROM sales WHERE sales >= 500;

-- 7b. Check for negative sales (data anomaly)
SELECT COUNT(*) AS negative_sales_count
FROM   sales
WHERE  sales < 0;

-- 7c. Check for null values in critical columns
SELECT
    SUM(CASE WHEN order_id      IS NULL THEN 1 ELSE 0 END) AS null_order_id,
    SUM(CASE WHEN customer_id   IS NULL THEN 1 ELSE 0 END) AS null_customer_id,
    SUM(CASE WHEN order_date    IS NULL THEN 1 ELSE 0 END) AS null_order_date,
    SUM(CASE WHEN sales         IS NULL THEN 1 ELSE 0 END) AS null_sales,
    SUM(CASE WHEN profit        IS NULL THEN 1 ELSE 0 END) AS null_profit
FROM sales;

-- 7d. Summary statistics for numeric columns
SELECT
    ROUND(MIN(sales),    2) AS min_sales,
    ROUND(MAX(sales),    2) AS max_sales,
    ROUND(AVG(sales),    2) AS avg_sales,
    ROUND(MIN(profit),   2) AS min_profit,
    ROUND(MAX(profit),   2) AS max_profit,
    ROUND(AVG(profit),   2) AS avg_profit,
    ROUND(MIN(quantity), 2) AS min_qty,
    ROUND(MAX(quantity), 2) AS max_qty,
    ROUND(AVG(quantity), 2) AS avg_qty
FROM sales;

-- 7e. Date range of the dataset
SELECT
    MIN(order_date) AS earliest_order,
    MAX(order_date) AS latest_order
FROM sales;

-- =============================================================
-- END OF SCRIPT
-- =============================================================
