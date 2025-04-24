CREATE TABLE	DimDate	(
dateid	INT	,
date	DATE	,
Year	INT	,
Quarter	INT	,
QuarterName	VARCHAR(20)	,
Month	INT	,
Monthname	VARCHAR(20)	,
Day	INT	,
Weekday	INT	,
WeekdayName	VARCHAR(20)	);



CREATE TABLE DimTruck	(
Truckid	INT	,
TruckType	VARCHAR(255)	);


CREATE TABLE DimStation		(
Stationid	INT	,
City	VARCHAR(255)	);


CREATE TABLE	FactTrips	(
Tripid	INT	,
Dateid	INT	,
Stationid	INT	,
Truckid	INT	,
Wastecollected	FLOAT(2)	);


SELECT * FROM DimDate LIMIT 5;

SELECT * FROM DimTruck LIMIT 5;

SELECT * FROM DimStation LIMIT 5;

SELECT * FROM FactTrips LIMIT 5;


SELECT f.stationid, tr.trucktype, SUM(f.wastecollected) AS total_Wastecollected
FROM facttrips f
LEFT JOIN dimtruck tr ON f.truckid = tr.truckid
GROUP BY f.stationid, tr.trucktype;


SELECT f.stationid, tr.trucktype, SUM(f.wastecollected) AS total_Wastecollected
FROM facttrips f
LEFT JOIN dimtruck tr ON f.truckid = tr.truckid
GROUP BY GROUPING SETS (f.stationid, tr.trucktype);


SELECT d.year, s.city, f.stationid, SUM(f.wastecollected) AS total_wastecollected
FROM facttrips f
LEFT JOIN dimdate d ON f.dateid = d.dateid
JOIN dimstation s ON f.stationid = s.stationid
GROUP BY ROLLUP (d.year, s.city, f.stationid)
ORDER BY d.year, s.city, f.stationid;

SELECT d.year, s.city, f.stationid, AVG( f.wastecollected ) AS average_wastecollected
FROM facttrips f 
LEFT JOIN dimdate d ON f.dateid = d.dateid
join dimstation s ON f.stationid = s.stationid 
GROUP BY CUBE (d.year, s.city, f.stationid)
ORDER BY (d.year, s.city, f.stationid);

CREATE MATERIALIZED VIEW  max_waste_stats (city, stationid, trucktype, max_wastecollected ) AS 
SELECT s.city, f.stationid, tr.trucktype, MAX(f.wastecollected) AS max_wastecollected 
FROM facttrips f
LEFT JOIN dimtruck tr ON f.truckid = tr.truckid
LEFT JOIN dimstation s ON f.stationid = s.stationid 
GROUP BY (s.city, f.stationid, tr.trucktype);

SELECT * FROM max_waste_stats;




