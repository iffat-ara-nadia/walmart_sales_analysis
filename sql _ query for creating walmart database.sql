
-- Walmart sales database creation
CREATE DATABASE IF NOT EXISTS walmart;

USE walmart;

DROP TABLE IF EXISTS walmart_sales_analysis;
CREATE TABLE walmart_sales_analysis (
	invoice_id INT PRIMARY KEY,
    Branch VARCHAR (50),
    City VARCHAR (50),
    category VARCHAR (50),
    unit_price FLOAT,
    quantity FLOAT,
    date DATE,
    time TIME,
    payment_method VARCHAR(50),
    rating FLOAT,
    profit_margin FLOAT,
    net_price FLOAT
  );