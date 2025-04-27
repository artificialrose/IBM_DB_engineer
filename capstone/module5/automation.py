# Import libraries required for connecting to mysql
# pip3 install mysql-connector-python
import mysql.connector

# Import libraries required for connecting to DB2 or PostgreSql
# python3 -m pip install psycopg2
import psycopg2


# Connect to MySQL
connection = mysql.connector.connect(user='root', password='Prex8dGoZWVdM2x0DQEJrIGs',host='172.21.115.105',database='sales')

# create cursor
cursor_sql = connection.cursor()

# Connect to DB2 or PostgreSql
# connectction details

dsn_hostname = '172.21.138.148'
dsn_user='postgres'        # e.g. "abc12345"
dsn_pwd ='fTOswEgcblDbvUC01eTpUWXU'      # e.g. "7dBZ3wWt9XN6$o0J"
dsn_port ="5432"                # e.g. "50000" 
dsn_database ="postgres"           # i.e. "BLUDB"


# create connection
conn = psycopg2.connect(
   database=dsn_database, 
   user=dsn_user,
   password=dsn_pwd,
   host=dsn_hostname, 
   port= dsn_port
)

#Crreate a cursor onject using cursor() method
cursor_post = conn.cursor()

# Find out the last rowid from DB2 data warehouse or PostgreSql data warehouse
# The function get_last_rowid must return the last rowid of the table sales_data on the IBM DB2 database or PostgreSql.

def get_last_rowid():
    last_id = None
    cursor_post.execute("SELECT MAX(rowid) FROM sales_data;")
    result = cursor_post.fetchone()
    if result and result[0] is not None:
            last_id = result[0]
    return last_id


last_row_id = get_last_rowid()
print("Last row id on production datawarehouse = ", last_row_id)

# List out all records in MySQL database with rowid greater than the one on the Data warehouse
# The function get_latest_records must return a list of all records that have a rowid greater than the last_row_id in the sales_data table in the sales database on the MySQL staging data warehouse.

def get_latest_records(rowid):
    latest_records = [] 
    query = "SELECT * FROM sales_data WHERE rowid > %s;"
    cursor_sql.execute(query, (rowid,))
    latest_records = cursor_sql.fetchall()
    return latest_records

new_records = get_latest_records(last_row_id)

print("New rows on staging datawarehouse = ", len(new_records))

# Insert the additional records from MySQL into DB2 or PostgreSql data warehouse.
# The function insert_records must insert all the records passed to it into the sales_data table in IBM DB2 database or PostgreSql.

def insert_records(records):
    insert_query = "INSERT INTO sales_data ( rowid, product_id, customer_id, quantity) VALUES (%s, %s, %s, %s);"
    cursor_post.executemany(insert_query, records)
    conn.commit()
    return True

insert_records(new_records)
print("New rows inserted into production datawarehouse = ", len(new_records))

# disconnect from mysql warehouse
connection.close()

# disconnect from DB2 or PostgreSql data warehouse 
conn.commit()
conn.close()

# End of program
