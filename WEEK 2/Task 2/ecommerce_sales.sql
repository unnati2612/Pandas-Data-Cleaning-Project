-- ============================================================
-- Project   : ShopEase E-Commerce Sales Database
-- Week      : 2 | Celebal Summer Internship 2026
-- Description: Schema creation and sample data load for
--              customers, products, orders, and order_items
-- ============================================================

-- Create and select the database
CREATE DATABASE IF NOT EXISTS ecommerce_sales_db;
USE ecommerce_sales_db;

-- ============================================================
-- TABLE: customers
-- Stores registered customer profiles
-- ============================================================

CREATE TABLE customers (
    customer_id  INT           PRIMARY KEY,
    first_name   VARCHAR(50)   NOT NULL,
    last_name    VARCHAR(50)   NOT NULL,
    email        VARCHAR(100)  UNIQUE NOT NULL,
    city         VARCHAR(50)   NOT NULL,
    state        VARCHAR(50)   NOT NULL,
    join_date    DATE          NOT NULL,
    is_premium   BOOLEAN       DEFAULT FALSE
);

-- Indexes to speed up city/state-based filtering
CREATE INDEX idx_customers_city  ON customers(city);
CREATE INDEX idx_customers_state ON customers(state);

-- ============================================================
-- TABLE: products
-- Catalogue of all items available for purchase
-- ============================================================

CREATE TABLE products (
    product_id   INT             PRIMARY KEY,
    product_name VARCHAR(100)    NOT NULL,
    category     VARCHAR(50)     NOT NULL,
    brand        VARCHAR(50)     NOT NULL,
    unit_price   DECIMAL(10, 2)  NOT NULL CHECK (unit_price > 0),
    stock_qty    INT             NOT NULL DEFAULT 0 CHECK (stock_qty >= 0)
);

-- Index to speed up category-based filtering
CREATE INDEX idx_products_category ON products(category);

-- ============================================================
-- TABLE: orders
-- Each row represents one order placed by a customer
-- ============================================================

CREATE TABLE orders (
    order_id     INT             PRIMARY KEY,
    customer_id  INT             NOT NULL,
    order_date   DATE            NOT NULL,
    status       VARCHAR(20)     NOT NULL DEFAULT 'Pending'
                                 CHECK (status IN ('Pending', 'Shipped', 'Delivered', 'Cancelled')),
    total_amount DECIMAL(12, 2)  NOT NULL CHECK (total_amount >= 0),

    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Indexes to speed up date-based and status-based filtering
CREATE INDEX idx_orders_date   ON orders(order_date);
CREATE INDEX idx_orders_status ON orders(status);

-- ============================================================
-- TABLE: order_items
-- Line items belonging to each order (one row per product)
-- ============================================================

CREATE TABLE order_items (
    item_id      INT             PRIMARY KEY,
    order_id     INT             NOT NULL,
    product_id   INT             NOT NULL,
    quantity     INT             NOT NULL CHECK (quantity > 0),
    unit_price   DECIMAL(10, 2)  NOT NULL CHECK (unit_price > 0),
    discount_pct DECIMAL(5, 2)   DEFAULT 0 CHECK (discount_pct BETWEEN 0 AND 100),

    CONSTRAINT fk_items_order
        FOREIGN KEY (order_id)   REFERENCES orders(order_id),

    CONSTRAINT fk_items_product
        FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- ============================================================
-- SAMPLE DATA: customers
-- ============================================================

INSERT INTO customers
    (customer_id, first_name, last_name, email, city, state, join_date, is_premium)
VALUES
    (101, 'Aarav',  'Sharma', 'aarav.s@email.com',  'Mumbai',    'Maharashtra', '2024-01-15', TRUE),
    (102, 'Priya',  'Patel',  'priya.p@email.com',  'Ahmedabad', 'Gujarat',     '2024-02-20', FALSE),
    (103, 'Rohan',  'Gupta',  'rohan.g@email.com',  'Delhi',     'Delhi',       '2024-03-10', TRUE),
    (104, 'Sneha',  'Reddy',  'sneha.r@email.com',  'Hyderabad', 'Telangana',   '2024-04-05', FALSE),
    (105, 'Vikram', 'Singh',  'vikram.s@email.com', 'Jaipur',    'Rajasthan',   '2024-05-12', TRUE),
    (106, 'Ananya', 'Iyer',   'ananya.i@email.com', 'Chennai',   'Tamil Nadu',  '2024-06-18', FALSE),
    (107, 'Karan',  'Mehta',  'karan.m@email.com',  'Pune',      'Maharashtra', '2024-07-22', TRUE),
    (108, 'Divya',  'Nair',   'divya.n@email.com',  'Kochi',     'Kerala',      '2024-08-30', FALSE);

-- ============================================================
-- SAMPLE DATA: products
-- ============================================================

INSERT INTO products
    (product_id, product_name, category, brand, unit_price, stock_qty)
VALUES
    (201, 'Wireless Earbuds',     'Electronics', 'BoAt',          1499.00, 250),
    (202, 'Cotton T-Shirt',       'Clothing',    'Levis',          799.00, 500),
    (203, 'Smart Watch',          'Electronics', 'Noise',         2999.00, 150),
    (204, 'Running Shoes',        'Clothing',    'Nike',          4599.00, 120),
    (205, 'Bluetooth Speaker',    'Electronics', 'JBL',           3499.00, 200),
    (206, 'Bedsheet Set',         'Home',        'Spaces',        1299.00, 300),
    (207, 'Laptop Stand',         'Electronics', 'AmazonBasics',   899.00, 180),
    (208, 'Cushion Covers (Set)', 'Home',        'HomeCenter',     599.00, 400);

-- ============================================================
-- SAMPLE DATA: orders
-- ============================================================

INSERT INTO orders
    (order_id, customer_id, order_date, status, total_amount)
VALUES
    (1001, 101, '2024-08-01', 'Delivered', 4498.00),
    (1002, 102, '2024-08-03', 'Delivered',  799.00),
    (1003, 103, '2024-08-05', 'Shipped',   7498.00),
    (1004, 101, '2024-08-10', 'Delivered', 3499.00),
    (1005, 104, '2024-08-12', 'Cancelled', 2999.00),
    (1006, 105, '2024-08-15', 'Delivered', 5898.00),
    (1007, 106, '2024-08-18', 'Pending',   1299.00),
    (1008, 103, '2024-08-20', 'Delivered',  899.00),
    (1009, 107, '2024-08-25', 'Shipped',   6098.00),
    (1010, 108, '2024-08-28', 'Delivered', 1598.00);

-- ============================================================
-- SAMPLE DATA: order_items
-- ============================================================

INSERT INTO order_items
    (item_id, order_id, product_id, quantity, unit_price, discount_pct)
VALUES
    (5001, 1001, 201, 2, 1499.00,  0.00),
    (5002, 1001, 207, 1,  899.00, 10.00),
    (5003, 1002, 202, 1,  799.00,  0.00),
    (5004, 1003, 203, 1, 2999.00,  0.00),
    (5005, 1003, 204, 1, 4599.00,  5.00),
    (5006, 1004, 205, 1, 3499.00,  0.00),
    (5007, 1005, 203, 1, 2999.00,  0.00),
    (5008, 1006, 201, 1, 1499.00, 10.00),
    (5009, 1006, 204, 1, 4599.00,  5.00),
    (5010, 1007, 206, 1, 1299.00,  0.00),
    (5011, 1008, 207, 1,  899.00,  0.00),
    (5012, 1009, 205, 1, 3499.00,  0.00),
    (5013, 1009, 208, 2,  599.00, 15.00),
    (5014, 1010, 206, 1, 1299.00,  0.00),
    (5015, 1010, 208, 1,  599.00,  0.00);

-- ============================================================
-- END OF SCRIPT
-- ============================================================
