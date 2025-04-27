-- CREATE DATABSE Test1;


-- Create the table

---------------------------------------
CREATE TABLE public."DimDate"
(
    dateid integer NOT NULL,
    date date,
    Year integer,
    Quarter integer,
    QuarterName character(50),
    Month integer,
    Monthname character(50),
    Day integer,
    Weekday integer,
    WeekdayName character(50),
    CONSTRAINT "DimDate_pkey" PRIMARY KEY (dateid)
);

-------------------------------------------------------

CREATE TABLE public."DimCategory"
(
    categoryid integer NOT NULL,
    category character(50),
    CONSTRAINT "DimCategory_pkey" PRIMARY KEY (categoryid)
);

-------------------------------------------------------

CREATE TABLE public."DimCountry"
(
    countryid integer NOT NULL,
    country character(50),
    CONSTRAINT "DimCountry_pkey" PRIMARY KEY (countryid)
);

-----------------------------------------------------------

CREATE TABLE public."FactSales"
(
    orderid integer NOT NULL,
    dateid integer,
    countryid integer,
    categoryid integer,
    amount integer,
    CONSTRAINT "FactSales_pkey" PRIMARY KEY (orderid)
);

-----------------------------------------

-- import csv using pgAdmin into /var/lib/pgadmin/
-- MAKE THE TABLENAME lowercase !!! 

-----------------------------------------


SELECT * FROM dimdate LIMIT 5;
SELECT * FROM dimcategory LIMIT 5;
SELECT * FROM dimcountry LIMIT 5;
SELECT * FROM factsales LIMIT 5;

----------------------------------------

-- Create a grouping sets query using the columns country, category, totalsales.
SELECT     n.country, g.category, SUM(f.amount) AS totalsales
FROM factsales AS f
JOIN dimcountry AS n ON f.countryid = n.countryid
JOIN dimcategory AS g ON f.categoryid = g.categoryid
GROUP BY GROUPING SETS (  g.category, n.country  );
-- 61 rows 

---------------------------------
-- Create a rollup query using the columns year, country, and totalsales.
SELECT d.year, n.country, SUM(f.amount) AS  totalsales
FROM factsales AS f
JOIN dimcountry AS n ON f.countryid = n.countryid
JOIN dimdate AS d ON f.dateid = d.dateid 
GROUP BY ROLLUP (d.year, n.country)
ORDER BY (d.year, n.country);
-- 172 rows 


---------------------------------
-- Create a cube query using the columns year, country, and average sales.

SELECT  d.year, n.country, AVG(f.amount) averagesales
FROM factsales AS f
JOIN dimcountry AS n ON f.countryid = n.countryid
JOIN dimdate AS d ON f.dateid = d.dateid 
GROUP BY CUBE (d.year, n.country);
-- 228 rows 

---------------------------------
-- Create an MQT named total_sales_per_country that has the columns country and total_sales.

CREATE MATERIALIZED VIEW total_sales_per_country AS
SELECT n.country, SUM(f.amount) AS total_sales
FROM factsales AS f
JOIN dimcountry AS n ON f.countryid = n.countryid
GROUP BY n.country;
-- 56 rows 



