CREATE DATABASE "FinalProject"
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.utf8'
    LC_CTYPE = 'en_US.utf8'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

USE DATABASE FinalProject;

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
WeekdayName	VARCHAR(20)	)

CREATE TABLE	DimTruck	(
Tripid	INT	,
Dateid	INT	,
Stationid	INT	,
Truckid	INT	,
Wastecollected	FLOAT(2)	)

CREATE TABLE	DimStation	(
Truckid	INT	,
TruckType	VARCHAR(255)	)

CREATE TABLE	FactTrips	(
Stationid	INT	,
City	VARCHAR(255)	)
