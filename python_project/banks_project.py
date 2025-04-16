# Code for ETL operations on Country-GDP data
# Importing the required libraries
import requests
from bs4 import BeautifulSoup
import pandas as pd
import sqlite3
import numpy as np
from datetime import datetime 

# requests - The library used for accessing the information from the URL.
# bs4 - The library containing the BeautifulSoup function used for webscraping.
# pandas - The library used for processing the extracted data, storing it in required formats, and communicating with the databases.
# sqlite3 - The library required to create a database server connection.
# numpy - The library required for the mathematical rounding operations.
# datetime - The library containing the function datetime used for extracting the timestamp for logging purposes.
# python3.11 -m pip install <library_name>

'''
python3.11 -m pip install requests
python3.11 -m pip install bs4
python3.11 -m pip install pandas
python3.11 -m pip install sqlite3
python3.11 -m pip install numpy
python3.11 -m pip install datetime
'''

# required exchange rate
# wget https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBMSkillsNetwork-PY0221EN-Coursera/labs/v2/exchange_rate.csv





def log_progress(message):
    ''' This function logs the mentioned message of a given stage of the
    code execution to a log file. Function returns nothing'''
    timestamp_format = "%Y-%h-%d-%H:%M:%S" # Year-Monthname-Day-Hour-Minute-Second
    now = datetime.now() # get current timestamp
    timestamp = now.strftime(timestamp_format)
    with open(log_file,"a") as f:
        f.write(timestamp + " : " + message + "\n") # <time_stamp> : <message>

    
def extract(url, table_attribs):
    ''' This function aims to extract the required
    information from the website and save it to a data frame. The
    function returns the data frame for further processing. '''
    page = requests.get(url).text
    soup = BeautifulSoup(page, "html.parser")

    df = pd.DataFrame(columns=table_attribs)

    tables = soup.find_all("tbody")
    rows = tables[0].find_all("tr")

    for row in rows:
        col = row.find_all("td")
        if len(col) != 0:
            data_dict = {"Name": col[1].find_all("a")[1]["title"],
                         "MC_USD_Billion": float(col[2].contents[0][:-1])}
            df1 = pd.DataFrame(data_dict, index=[0])
            df = pd.concat([df, df1], ignore_index=True)
    return df

def transform(df, csv_path):
    ''' This function accesses the CSV file for exchange rate
    information, and adds three columns to the data frame, each
    containing the transformed version of Market Cap column to
    respective currencies'''
    # Read exchange rate CSV file
    exchange_rate = pd.read_csv(csv_path)

    # Convert to a dictionary with "Currency" as keys and "Rate" as values
    exchange_rate = exchange_rate.set_index("Currency").to_dict()["Rate"]

    # Add MC_GBP_Billion, MC_EUR_Billion, and MC_INR_Billion
    # columns to dataframe. Round off to two decimals
    df["MC_GBP_Billion"] = [np.round(x * exchange_rate["GBP"], 2) for x in df["MC_USD_Billion"]]
    df["MC_EUR_Billion"] = [np.round(x * exchange_rate["EUR"], 2) for x in df["MC_USD_Billion"]]
    df["MC_INR_Billion"] = [np.round(x * exchange_rate["INR"], 2) for x in df["MC_USD_Billion"]]

    return df


def load_to_csv(df, output_path):
    ''' This function saves the final data frame as a CSV file in
    the provided path. Function returns nothing.'''
    df.to_csv(output_path)

def load_to_db(df, sql_connection, table_name):
    ''' This function saves the final data frame to a database
    table with the provided name. Function returns nothing.'''
    df.to_sql(table_name, sql_connection, if_exists='replace', index=False)

def run_query(query_statement, sql_connection):
    ''' This function runs the query on the database table and
    prints the output on the terminal. Function returns nothing. '''
    print(query_statement)
    query_output = pd.read_sql(query_statement, sql_connection)
    print(query_output)




''' Here, you define the required entities and call the relevant
functions in the correct order to complete the project. Note that this
portion is not inside any function.'''
# main function
# python3.11 banks_project.py

# Declaring known values
data_URL = "https://web.archive.org/web/20230908091635/https://en.wikipedia.org/wiki/List_of_largest_banks"
exchangerate_CSVpath = "https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBMSkillsNetwork-PY0221EN-Coursera/labs/v2/exchange_rate.csv"

table_extract = ["Name", "MC_USD_Billion"]
# table_attributes (final)	Name, MC_USD_Billion, MC_GBP_Billion, MC_EUR_Billion, MC_INR_Billion
output_CSVpath = "./Largest_banks_data.csv"
database_name =	"Banks.db"
table_name = "Largest_banks"
log_file = "./code_log.txt"
log_progress("Preliminaries complete. Initiating ETL process")


# Call extract() function
df = extract(data_URL,table_extract)
print(df)
log_progress("Data extraction complete. Initiating Transformation process")


# Call transform() function	
df = transform(df, exchangerate_CSVpath)
print(df)
log_progress("Data transformation complete. Initiating Loading process")


# Call load_to_csv()	
load_to_csv(df, output_CSVpath)
log_progress("Data saved to CSV file")


# Initiate SQLite3 connection	
sql_connection = sqlite3.connect(database_name)
log_progress("SQL Connection initiated")


# Call load_to_db()	
load_to_db(df,sql_connection,table_name)
log_progress("Data loaded to Database as a table, Executing queries")

# Call run_query()	

# 1. Print the contents of the entire table
query_statement = "SELECT * FROM Largest_banks"
run_query(query_statement, sql_connection)

# 2. Print the average market capitalization of all the banks in Billion USD.
query_statement = "SELECT AVG(MC_GBP_Billion) FROM Largest_banks"
run_query(query_statement, sql_connection)

# 3. Print only the names of the top 5 banks
query_statement = "SELECT Name from Largest_banks LIMIT 5"
run_query(query_statement, sql_connection)

log_progress("Process Complete")


#     Close SQLite3 connection
sql_connection.close()
log_progress("Server Connection closed")
