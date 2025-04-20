

## table 
The solid waste management company has provided you the sample data they want to collect.
Trip_number,  Waste_Type, Waste_Collected_in_tons, Collection_Zone, City, Date
1, Dry, 45.23,  South, Sao Paulo, 23-Jan-20
2, Wet, 43.12,  Central, Rio de Janeiro, 24-Jan-20
3, Electronic, 40.19, South, Sao Paulo, 23-Jan-20
4, Plastic, 34.87, West, Rio de Janeiro, 24-Jan-20
5, Wet, 45.34, West, Rio de Janeiro, 23-Jan-20

## Fields in MyDimDate table:

date_id
date
day
weekday
weekdayname
month
monthname
year



## Fields in MyDimWaste table:

waste_id
waste_Type
waste_Collected_in_ton

## Fields in MyDimZone table:

zone_id
zone_name
city

## Fields in MyFactTrips table:

Trip_number
waste_id
zone_id
date_id

