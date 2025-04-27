CREATE DATABASE sales;

CREATE TABLE sales_data (
product_id INT,
customer_id INT,
price INT,
quantity INT,
timestamp DATETIME 
);

SELECT COUNT(*) FROM sales_data;

CREATE INDEX ts
ON sales_data (timestamp);

SHOW INDEX FROM sales_data;
