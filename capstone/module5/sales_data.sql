-- sales_data ( rowid, product_id, customer_id, price, quantity, timeestamp)

CREATE TABLE sales_data (
  rowid INT PRIMARY KEY, 
  product_id INT, 
  customer_id INT, 
  price decimal DEFAULT 0.0 NOT NULL,
  quantity INT,
  timeestamp timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
  );
