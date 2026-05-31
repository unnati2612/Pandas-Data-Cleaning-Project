-- Sales Data Analysis Assignment

-- first i created the table to store the sales data

CREATE TABLE sales (
    order_id TEXT,
    order_date DATE,
    customer_id TEXT,
    customer_name TEXT,
    region TEXT,
    category TEXT,
    sub_category TEXT,
    product_name TEXT,
    quantity INTEGER,
    unit_price REAL,
    discount REAL,
    sales REAL,
    profit REAL
);

-- loaded the csv file into the table using sqlite
-- .mode csv
-- .import sales_data.csv sales


-- SECTION 2 - exploring the table first

-- checking how the table looks
SELECT * FROM sales LIMIT 10;

-- total number of rows
SELECT COUNT(*) FROM sales;

-- what all regions are there
SELECT DISTINCT region FROM sales;

-- what categories we have
SELECT DISTINCT category FROM sales;


-- SECTION 3 - filtering data using WHERE

-- orders from west region only
SELECT * FROM sales
WHERE region = 'West';

-- only technology products
SELECT * FROM sales
WHERE category = 'Technology';

-- orders placed in 2023
SELECT * FROM sales
WHERE order_date BETWEEN '2023-01-01' AND '2023-12-31';

-- orders where sales is more than 500
SELECT * FROM sales
WHERE sales > 500
ORDER BY sales DESC;

-- east region furniture orders
SELECT * FROM sales
WHERE region = 'East' AND category = 'Furniture';


-- SECTION 4 - aggregations using GROUP BY

-- total sales by region
SELECT region, ROUND(SUM(sales), 2) AS total_sales
FROM sales
GROUP BY region
ORDER BY total_sales DESC;

-- total sales and quantity sold per category
SELECT category,
       ROUND(SUM(sales), 2) AS total_sales,
       SUM(quantity) AS total_qty,
       ROUND(AVG(sales), 2) AS avg_sales
FROM sales
GROUP BY category;

-- sub category wise sales
SELECT sub_category, ROUND(SUM(sales), 2) AS total_sales
FROM sales
GROUP BY sub_category
ORDER BY total_sales DESC;

-- region and category combined
SELECT region, category, ROUND(SUM(profit), 2) AS total_profit
FROM sales
GROUP BY region, category
ORDER BY total_profit DESC;


-- SECTION 5 - top products and categories

-- top 10 products by sales
SELECT product_name, ROUND(SUM(sales), 2) AS total_sales
FROM sales
GROUP BY product_name
ORDER BY total_sales DESC
LIMIT 10;

-- top 5 categories by quantity
SELECT category, SUM(quantity) AS total_qty
FROM sales
GROUP BY category
ORDER BY total_qty DESC
LIMIT 5;

-- bottom 5 sub categories by profit
SELECT sub_category, ROUND(SUM(profit), 2) AS total_profit
FROM sales
GROUP BY sub_category
ORDER BY total_profit ASC
LIMIT 5;


-- SECTION 6 - business queries / use cases

-- monthly sales trend
SELECT STRFTIME('%Y-%m', order_date) AS month,
       ROUND(SUM(sales), 2) AS monthly_sales,
       COUNT(*) AS orders
FROM sales
GROUP BY month
ORDER BY month;

-- top 10 customers by how much they spent
SELECT customer_name, ROUND(SUM(sales), 2) AS total_spend, COUNT(*) AS orders
FROM sales
GROUP BY customer_id, customer_name
ORDER BY total_spend DESC
LIMIT 10;

-- which product was ordered the most
SELECT product_name, SUM(quantity) AS total_qty
FROM sales
GROUP BY product_name
ORDER BY total_qty DESC
LIMIT 1;

-- orders where discount was very high (more than 30%)
SELECT order_id, product_name, discount, ROUND(sales, 2), ROUND(profit, 2)
FROM sales
WHERE discount > 0.30
ORDER BY discount DESC;

-- orders where we had a loss
SELECT order_id, product_name, region, ROUND(profit, 2) AS profit
FROM sales
WHERE profit < 0
ORDER BY profit ASC;

-- checking for duplicate order ids
SELECT order_id, COUNT(*) AS count
FROM sales
GROUP BY order_id
HAVING COUNT(*) > 1;

-- what % of total sales does each category contribute
SELECT category,
       ROUND(SUM(sales), 2) AS cat_sales,
       ROUND(SUM(sales) * 100.0 / (SELECT SUM(sales) FROM sales), 2) AS percentage
FROM sales
GROUP BY category
ORDER BY cat_sales DESC;


-- SECTION 7 - validating data

-- checking nulls in important columns
SELECT
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS null_order_id,
    SUM(CASE WHEN sales IS NULL THEN 1 ELSE 0 END) AS null_sales,
    SUM(CASE WHEN profit IS NULL THEN 1 ELSE 0 END) AS null_profit,
    SUM(CASE WHEN order_date IS NULL THEN 1 ELSE 0 END) AS null_date
FROM sales;

-- any negative sales values
SELECT COUNT(*) AS negative_sales FROM sales WHERE sales < 0;

-- basic stats
SELECT
    ROUND(MIN(sales), 2), ROUND(MAX(sales), 2), ROUND(AVG(sales), 2),
    ROUND(MIN(profit), 2), ROUND(MAX(profit), 2), ROUND(AVG(profit), 2)
FROM sales;

-- date range of dataset
SELECT MIN(order_date), MAX(order_date) FROM sales;

-- row count after filtering west region (just to verify)
SELECT COUNT(*) FROM sales WHERE region = 'West';
