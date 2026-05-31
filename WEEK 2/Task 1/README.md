# 📊 Sales Data Analysis Using SQL

> **Assignment:** Analyze a sales dataset using SQL — filtering, aggregation, business queries, and data validation.

---

## 📁 Repository Structure

```
sales-sql-analysis/
│
├── sales_analysis.sql     # All SQL queries (organized by section)
├── data/
│   └── sales_data.csv     # Raw dataset (add your CSV here)
├── results/
│   └── screenshots/       # Query output screenshots (optional)
└── README.md
```

---

## 🎯 Objective

Write and execute SQL queries on a sales dataset to extract meaningful business insights using:
- **Filtering** with `WHERE` clauses
- **Aggregation** using `GROUP BY`, `SUM`, `AVG`, `COUNT`
- **Sorting & limiting** results for top-N analysis
- **Business queries** for trends, customers, and anomalies
- **Data validation** for quality and integrity checks

---

## 🗂️ Dataset

| Column | Type | Description |
|---|---|---|
| `order_id` | INTEGER | Unique order identifier |
| `order_date` | DATE | Date the order was placed |
| `customer_id` | VARCHAR | Customer identifier |
| `customer_name` | VARCHAR | Customer full name |
| `region` | VARCHAR | Sales region (East, West, etc.) |
| `category` | VARCHAR | Product category |
| `sub_category` | VARCHAR | Product sub-category |
| `product_name` | VARCHAR | Name of the product |
| `quantity` | INTEGER | Units ordered |
| `unit_price` | DECIMAL | Price per unit |
| `discount` | DECIMAL | Discount applied (0–1 scale) |
| `sales` | DECIMAL | Final sale amount |
| `profit` | DECIMAL | Profit from the order |

> You can use any standard sales dataset (e.g., [Superstore Dataset on Kaggle](https://www.kaggle.com/datasets/vivek468/superstore-dataset-final)).

---

## 🛠️ Setup Instructions

### Option A — SQLite (recommended for quick setup)

```bash
# Install SQLite
sudo apt install sqlite3       # Linux
brew install sqlite            # macOS

# Open database and load CSV
sqlite3 sales.db
```

```sql
.mode csv
.headers on
.import data/sales_data.csv sales
```

### Option B — MySQL

```sql
CREATE DATABASE sales_db;
USE sales_db;

LOAD DATA INFILE '/path/to/sales_data.csv'
INTO TABLE sales
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
```

### Option C — PostgreSQL

```sql
CREATE DATABASE sales_db;
\c sales_db

\COPY sales FROM 'data/sales_data.csv' CSV HEADER;
```

---

## 📋 Query Sections

### Section 1 — Load Dataset
Create the `sales` table and import CSV data.

### Section 2 — Explore the Table
View schema, sample rows, total row count, null checks, and distinct categorical values.

### Section 3 — WHERE Filters
Filter by:
- Region (e.g., `'West'`)
- Category (e.g., `'Technology'`)
- Date range (`BETWEEN`)
- Minimum sales value
- Multiple combined conditions

### Section 4 — GROUP BY Aggregations
Aggregate:
- Total and average sales by region
- Total sales and quantity by category
- Sales and profit by sub-category
- Profit by region × category

### Section 5 — Sort & Limit (Top-N)
- Top 10 products by revenue
- Top 5 categories by quantity
- Bottom 5 sub-categories by profit

### Section 6 — Business Use Cases
| Query | Purpose |
|---|---|
| Monthly sales trend | Identify growth/decline over time |
| Top 10 customers by spend | Recognize high-value customers |
| Most ordered product | Stock/inventory planning |
| High-discount orders | Measure discount impact on profit |
| Loss-making orders | Identify unprofitable transactions |
| Duplicate order IDs | Data integrity check |
| Category % of total sales | Portfolio contribution analysis |

### Section 7 — Data Validation
- Row counts after filters
- Negative sales anomalies
- NULL value check across all key columns
- Min / Max / Avg statistics
- Dataset date range

---

## 💡 Key Insights

*(Fill these in after running your queries)*

1. **Top Region:** `___` generates the highest revenue at `$___`.
2. **Best Category:** `___` leads in total sales.
3. **Top Product:** `___` is the highest-selling product.
4. **Loss Orders:** `___` orders resulted in a loss, mostly in high-discount cases.
5. **Monthly Trend:** Sales peak in `___` and dip in `___`.
6. **Data Quality:** `___` duplicate order IDs found; `___` null values detected.

---

## 🚀 How to Run

```bash
# SQLite — run all queries at once
sqlite3 sales.db < sales_analysis.sql

# Or interactively
sqlite3 sales.db
sqlite> .read sales_analysis.sql
```

---

## 📌 Notes

- Syntax comments in the SQL file mark alternatives for **MySQL** and **PostgreSQL** where functions differ (e.g., date formatting).
- All monetary values are rounded to 2 decimal places for readability.
- The `discount` column uses a `0–1` scale (e.g., `0.30` = 30% discount).

---

## 👤 Author

| Field | Detail |
|---|---|
| Name | [Your Name] |
| Course | [Your Course / Institution] |
| Submission | GitHub Repository Link |

---

*Assignment completed as part of a SQL data analysis exercise.*
