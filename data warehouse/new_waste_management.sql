
## table 
The solid waste management company has provided you the sample data they want to collect.
Trip_number,  Waste_Type, Waste_Collected_in_tons, Collection_Zone, City, Date
1, Dry, 45.23,  South, Sao Paulo, 23-Jan-20
2, Wet, 43.12,  Central, Rio de Janeiro, 24-Jan-20
3, Electronic, 40.19, South, Sao Paulo, 23-Jan-20
4, Plastic, 34.87, West, Rio de Janeiro, 24-Jan-20
5, Wet, 45.34, West, Rio de Janeiro, 23-Jan-20

CREATE TABLE DimDate (
dateid	INT	PRIMARY KEY,
date	DATE	,
Year	INT	,
Quarter	INT	,
QuarterName	VARCHAR(20)	,
Month	INT	,
Monthname	VARCHAR(20)	,
Day	INT	,
Weekday	INT	,
WeekdayName	VARCHAR(20)	

  );

CREATE TABLE DimTruck (
Truckid	INT	PRIMARY KEY,
TruckType	VARCHAR(255)	
);

CREATE TABLE DimStation(
  Stationid	INT	PRIMARY KEY,
  City	VARCHAR(255)	
  );

CREATE TABLE FactTrips(
  Tripid	INT	PRIMARY KEY,
  Dateid	INT	,
  Stationid	INT	,
  Truckid	INT	,
  Wastecollected	FLOAT(2)	
  );




