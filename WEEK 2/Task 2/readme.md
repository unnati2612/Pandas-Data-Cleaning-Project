# E-Commerce Sales Database - SQL Assignment

This is my Week 2 SQL assignment for the Celebal Summer Internship 2026. The task was to analyze an e-commerce sales database for a company called ShopEase which sells electronics, clothing and home products across India.

---

## What this assignment covers

- Creating tables with proper constraints and relationships
- Loading sample data using INSERT statements
- Writing SQL queries from basic to advanced level
- Topics covered: SELECT, WHERE, GROUP BY, JOINs, CASE, Transactions, ACID properties

---

## Files in this repo

- `create_insert.sql` - all CREATE TABLE and INSERT statements to set up the database
- `answers.sql` - SQL answers for all 27 questions (Section A to E)
- `README.md` - this file

---

## Database Schema

There are 4 tables in this database:

- `customers` - stores customer info like name, city, state, join date
- `products` - stores product details like category, brand, price, stock
- `orders` - stores order info linked to customers
- `order_items` - stores individual items in each order linked to products

Relationships:
- one customer can have many orders
- one order can have many order items
- one product can appear in many order items

---

## How to run

i used MySQL for this assignment. Steps to set up:

```
1. Open MySQL Workbench or any SQL client
2. Run create_insert.sql first to create tables and load data
3. Then run answers.sql to see query outputs
```

---

## Sections covered

**Section A - SQL Basics**
questions on SELECT, constraints, primary keys (Q1 to Q6)

**Section B - Filtering & Optimization**
WHERE clause, indexes, SARGable queries (Q7 to Q12)

**Section C - Aggregation**
GROUP BY, SUM, COUNT, AVG, MIN, MAX, HAVING (Q13 to Q18)

**Section D - Joins**
INNER JOIN, LEFT JOIN, multi-table joins, foreign keys (Q19 to Q23)

**Section E - Advanced Concepts**
CASE statements, ACID properties, Transactions (Q24 to Q27)

---

## Tools used

- MySQL
- MySQL Workbench
