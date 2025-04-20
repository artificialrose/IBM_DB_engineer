  CREATE TABLE MyDimDate (
  date_id INT PRIMARY KEY NOT NULL,
  date DATE NOT NULL,
  day INT,
  weekday INT,
  weekdayname VARCHAR(20),
  month INT,
  monthname VARCHAR(20),
  year INT
);

CREATE TABLE MyDimWaste (
waste_id INT PRIMARY KEY NOT NULL,
waste_Type VARCHAR(20),
waste_Collected_in_ton FLOAT(2)

);


CREATE TABLE MyDimZone (
  zone_id INT PRIMARY KEY NOT NULL,
  zone_name VARCHAR(20),
  city VARCHAR(20)

);

CREATE TABLE MyFactTrips (
  trip_number INT PRIMARY KEY NOT NULL,
  waste_id INT,
  zone_id INT,
  date_id INT

);


