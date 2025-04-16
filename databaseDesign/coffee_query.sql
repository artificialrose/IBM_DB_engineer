--- 100 rows from sales_detail table
Select * from sales_detail LIMIT 100

--- create view staff_locations_view
  
CREATE VIEW staff_locations_view AS
SELECT staff.staff_id,
staff.first_name,
staff.last_name,
staff.location
FROM staff
WHERE "position" NOT IN ('CEO', 'CFO');

select * from staff_locations_view

--- create a new materialized view named product_info_m-view 
  
CREATE MATERIALIZED VIEW product_info_mview AS
SELECT product.product_name, product.description, product_type.product_category
FROM product
JOIN product_type
ON product.product_type_id = product_type.product_type_id;

SELECT * FROM product_info_mview
