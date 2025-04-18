# postgres=#

## show max connections 
SHOW max_connections

## create user / role 
CREATE USER backup_operator WITH PASSWORD 'backup_operator_password';
CREATEROLE backup;

## grant privilege
GRANT CONNECT ON DATABASE tolldata TO backup;
GRANT CONNECT ON ALL TABLES IN SCHEMA toll TO backup;

## grant role 
GRANT backup TO backup_operator;

# mysql> 
CREATE INDEX billedamount_index ON billdata(billedamount);

## show table 
SHOW TABLES;

## data size 
SHOW TABLE STATUS FROM billing;

## select billamount > 19999
SELECT * FROM billdata 
WHERE billedamount > 19999


## show storage engine 
SHOW ENGINES;

## show engine types 
SELECT table_name, engine 
FROM information_schema.table 
WHERE table_name = 'billdata';

## count rows 
SELECT COUNT(*) FROM billing

## create view 
CREATE VIEW basicbilldetails AS
SELECT customerid, month, billedamount 
FROM billing ;

SELECT * FROM basicbilldetails;

# time log
SELECT strftime('%Y-%m-%d %H:%M:%f', 'now')




