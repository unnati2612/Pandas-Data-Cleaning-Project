# Week 2 Task 2 — E-Commerce Sales Database
### Celebal Summer Internship 2026 | ShopEase Analytics

---

## Section A — SQL Basics

### Q1. Write a query to display all columns and rows from the customers table.

```sql
SELECT *
FROM customers;
```

### Q2. Retrieve only the first_name, last_name, and city of all customers.

```sql
SELECT first_name, last_name, city
FROM customers;
```

### Q3. List all unique categories available in the products table.

```sql
SELECT DISTINCT category
FROM products;
```

### Q4. Identify the Primary Key of each table. Explain why a Primary Key must be unique and NOT NULL.

| Table         | Primary Key   |
|---------------|---------------|
| `customers`   | `customer_id` |
| `products`    | `product_id`  |
| `orders`      | `order_id`    |
| `order_items` | `item_id`     |

**Explanation:**
A Primary Key serves as the unique identifier for every row in a table. It enforces two rules:
- **UNIQUE** — No two rows can share the same key value, ensuring each record can be precisely targeted.
- **NOT NULL** — A key that is NULL cannot uniquely identify anything; every row must have a valid, non-empty key value.

Together these rules guarantee that data retrieval and JOIN operations always refer to exactly one row.

### Q5. What constraints are applied to the email column in the customers table? What would happen if you tried to insert a duplicate email?

From the schema:
```sql
email VARCHAR(100) UNIQUE NOT NULL
```

Two constraints are applied:
- `NOT NULL` — every customer must have an email address.
- `UNIQUE` — no two customers can share the same email.

If you attempt to insert a row with an email that already exists in the table, the database raises a **UNIQUE constraint violation** and the INSERT is rejected entirely. The existing data remains unchanged.

### Q6. Try inserting a product with unit_price = -50. What happens and which constraint prevents it?

```sql
INSERT INTO products
VALUES (209, 'Test Product', 'Electronics', 'SomeBrand', -50, 50);
```

**Result:** The INSERT fails immediately.

**Constraint responsible:**
```sql
CHECK (unit_price > 0)
```

The `CHECK` constraint on the `products` table requires `unit_price` to be strictly greater than zero. A value of `-50` violates this rule, so the database rejects the statement with a check constraint violation error and no row is inserted.

---

## Section B — Filtering & Optimization

### Q7. Retrieve all orders with status = 'Delivered'.

```sql
SELECT *
FROM orders
WHERE status = 'Delivered';
```

### Q8. Find all products in the 'Electronics' category with a unit_price greater than ₹2000.

```sql
SELECT *
FROM products
WHERE category = 'Electronics'
  AND unit_price > 2000;
```

### Q9. List all customers who joined in 2024 and belong to the state 'Maharashtra'.

```sql
SELECT *
FROM customers
WHERE state = 'Maharashtra'
  AND join_date >= '2024-01-01'
  AND join_date < '2025-01-01';
```

### Q10. Find all orders placed between '2024-08-10' and '2024-08-25' (inclusive) that are NOT cancelled.

```sql
SELECT *
FROM orders
WHERE order_date BETWEEN '2024-08-10' AND '2024-08-25'
  AND status != 'Cancelled';
```

### Q11. Explain what the index idx_orders_date does and how it improves performance.

```sql
CREATE INDEX idx_orders_date ON orders(order_date);
```

**What it does:** This index builds an internal sorted data structure (typically a B-tree) on the `order_date` column of the `orders` table.

**Performance benefit:** Without the index, a query filtering by `order_date` would perform a full table scan — reading every row to check if it falls in the desired range. With the index, the database engine jumps directly to the relevant section of the B-tree and reads only the matching rows, dramatically reducing I/O and execution time as the table grows.

**Sample query that benefits:**
```sql
SELECT order_id, customer_id, total_amount
FROM orders
WHERE order_date BETWEEN '2024-08-01' AND '2024-08-31';
```

### Q12. Would `SELECT * FROM customers WHERE YEAR(join_date) = 2024;` use the index on join_date? Rewrite it to be SARGable.

**Answer: No, it would NOT use the index.**

When a column is wrapped inside a function like `YEAR()`, the database cannot directly map function output back to the index entries. The optimizer has no choice but to compute `YEAR(join_date)` for every row — a full table scan.

**SARGable rewrite (Search ARGument able):**
```sql
SELECT *
FROM customers
WHERE join_date >= '2024-01-01'
  AND join_date < '2025-01-01';
```

This expresses the same condition as a plain range on the raw column, allowing the index to be used directly.

---

## Section C — Aggregation

### Q13. Count the total number of orders in the orders table.

```sql
SELECT COUNT(*) AS total_orders
FROM orders;
```

### Q14. Find the total revenue from all 'Delivered' orders.

```sql
SELECT SUM(total_amount) AS delivered_revenue
FROM orders
WHERE status = 'Delivered';
```

### Q15. Calculate the average unit_price of products in each category.

```sql
SELECT category,
       ROUND(AVG(unit_price), 2) AS avg_unit_price
FROM products
GROUP BY category;
```

### Q16. For each order status, find the count of orders and total revenue, sorted by revenue descending.

```sql
SELECT status,
       COUNT(*)           AS order_count,
       SUM(total_amount)  AS total_revenue
FROM orders
GROUP BY status
ORDER BY total_revenue DESC;
```

### Q17. Find the most expensive and cheapest product in each category.

```sql
SELECT category,
       MAX(unit_price) AS most_expensive,
       MIN(unit_price) AS cheapest
FROM products
GROUP BY category;
```

### Q18. List product categories where the average unit_price exceeds ₹2000.

```sql
SELECT category,
       ROUND(AVG(unit_price), 2) AS avg_price
FROM products
GROUP BY category
HAVING AVG(unit_price) > 2000;
```

> **Note:** `HAVING` filters on aggregated results, whereas `WHERE` filters individual rows before aggregation. You must use `HAVING` here because the filter is on a group-level value.

---

## Section D — Joins & Relationships

### Q19. INNER JOIN — each order with the customer's name.

```sql
SELECT o.order_id,
       o.order_date,
       c.first_name,
       c.last_name,
       o.total_amount
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id;
```

### Q20. LEFT JOIN — all customers and their orders (including customers with no orders).

```sql
SELECT c.customer_id,
       c.first_name,
       c.last_name,
       o.order_id,
       o.order_date,
       o.total_amount
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id;
```

Customers who have never placed an order will appear with `NULL` in every `orders` column.

### Q21. Three-table JOIN — order items with product details.

```sql
SELECT o.order_id,
       p.product_name,
       oi.quantity,
       oi.unit_price,
       oi.discount_pct
FROM orders o
JOIN order_items oi ON o.order_id    = oi.order_id
JOIN products    p  ON oi.product_id = p.product_id;
```

### Q22. Difference between LEFT JOIN and RIGHT JOIN; when to use FULL OUTER JOIN.

**LEFT JOIN** returns every row from the **left** table plus any matching rows from the right table. Non-matching right-table columns appear as `NULL`.

Example: All customers, with order details where they exist.
```sql
SELECT c.first_name, o.order_id
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id;
-- Customers with no orders still appear; order_id is NULL for them.
```

**RIGHT JOIN** is the mirror image — every row from the **right** table is kept, and non-matching left-table columns are `NULL`.

Example (less common in this schema):
```sql
SELECT c.first_name, o.order_id
FROM customers c
RIGHT JOIN orders o ON c.customer_id = o.customer_id;
-- Every order appears; customer columns are NULL if the customer_id is missing.
```

**FULL OUTER JOIN** combines both — all rows from both tables are returned, with `NULL` filling in wherever there is no match on either side. Use it when you need to identify orphan records in *both* tables simultaneously (e.g., customers without orders AND orders without valid customers).

### Q23. Foreign Key relationships and what happens with a missing customer_id.

**FK relationships in the schema:**

| Child column | References |
|---|---|
| `orders.customer_id` | `customers.customer_id` |
| `order_items.order_id` | `orders.order_id` |
| `order_items.product_id` | `products.product_id` |

**Attempted insert with a non-existent customer:**
```sql
INSERT INTO orders
VALUES (2001, 999, '2024-09-15', 'Pending', 2500.00);
```

This INSERT fails with a **Foreign Key constraint violation**. The database checks that `customer_id = 999` exists in the `customers` table before allowing the row to be inserted into `orders`. Since no such customer exists, referential integrity is enforced and the statement is rolled back.

---

## Section E — Advanced Concepts

### Q24. CASE — classify products into price tiers.

```sql
SELECT product_name,
       unit_price,
       CASE
           WHEN unit_price < 1000               THEN 'Budget'
           WHEN unit_price BETWEEN 1000 AND 3000 THEN 'Mid-Range'
           ELSE                                       'Premium'
       END AS price_tier
FROM products
ORDER BY unit_price;
```

### Q25. CASE inside aggregate — count Delivered vs Not Delivered orders in one row.

```sql
SELECT
    SUM(CASE WHEN status = 'Delivered' THEN 1 ELSE 0 END) AS delivered_count,
    SUM(CASE WHEN status <> 'Delivered' THEN 1 ELSE 0 END) AS not_delivered_count
FROM orders;
```

### Q26. Explain each letter of ACID with a real-world example.

#### A — Atomicity
A transaction is an all-or-nothing unit of work. If any statement within the transaction fails, the entire transaction is rolled back as though nothing happened.

**Example:** In a bank transfer, debiting Account A and crediting Account B are one atomic unit. If the credit step crashes, the debit is also undone — money never disappears.

#### C — Consistency
A transaction brings the database from one valid state to another. All rules (constraints, triggers, cascades) must hold before and after the transaction.

**Example:** A bank enforces that no account balance can go below zero. A consistent transaction will refuse to allow a withdrawal that would violate this rule, leaving the database in a valid state.

#### I — Isolation
Concurrent transactions execute as if they were run sequentially. Intermediate (uncommitted) changes made by one transaction are not visible to others.

**Example:** If two users simultaneously try to buy the last item in stock, isolation ensures neither reads a half-updated inventory — only one purchase goes through correctly.

#### D — Durability
Once a transaction is committed, its changes are permanent — surviving crashes, power failures, or restarts.

**Example:** After a payment is confirmed to a customer, that record persists in the database even if the server immediately loses power, because it was written to durable storage.

### Q27. Complete transaction block — insert order, items, and update stock.

```sql
START TRANSACTION;

-- Step 1: Insert the new order
INSERT INTO orders (order_id, customer_id, order_date, status, total_amount)
VALUES (1011, 102, CURDATE(), 'Pending', 1598.00);

-- Step 2: Insert first order item (Bedsheet Set — product_id 206)
INSERT INTO order_items (item_id, order_id, product_id, quantity, unit_price, discount_pct)
VALUES (5016, 1011, 206, 1, 1299.00, 0.00);

-- Step 3: Insert second order item (Cushion Covers — product_id 208)
INSERT INTO order_items (item_id, order_id, product_id, quantity, unit_price, discount_pct)
VALUES (5017, 1011, 208, 1, 599.00, 0.00);

-- Step 4: Reduce stock for product 206
UPDATE products
SET stock_qty = stock_qty - 1
WHERE product_id = 206;

-- Step 5: Reduce stock for product 208
UPDATE products
SET stock_qty = stock_qty - 1
WHERE product_id = 208;

-- If all steps succeeded, make changes permanent
COMMIT;

-- If any step fails, execute the following instead to undo all changes:
-- ROLLBACK;
```

**How atomicity works here:** All five statements run within a single transaction. If the server crashes or any constraint is violated after `START TRANSACTION` but before `COMMIT`, a `ROLLBACK` (issued manually or automatically by the engine) undoes every change — the order is not partially created and stock is not partially decremented.
