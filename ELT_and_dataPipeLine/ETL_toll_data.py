
# import libraries 

from datetime import timedelta
# The DAG object; we'll need this to instantiate a DAG
from airflow.models import DAG
# Operators; you need this to write tasks!
from airflow.operators.bash_operator import BashOperator
# This makes scheduling easy
from airflow.utils.dates import days_ago


# define DAG args 
default_args = {
    'owner' : 'Susan Rose',
    'start_date' : days_ago(0),
    'email':'dummymail.hsu@gmail.com',
    'email_on_failure' : True,
    'email_on_retry' : True,
    'retries' : 1,
    'retry_delay' : timedelta(minutes=5),
}


# define DAG 
dag = DAG(
    'ETL_toll_data',
    schedule_interval = timedelta(days=1),
    default_args = default_args,
    description = 'Apache Airflow Final Assignment',
)

# define task 
'''
bash_operator = BashOperator ( 
    task_id = '',
    bash_command = '',
    dag=dag,
)
'''




# define unzip_data
# tar -xzf <path/file.tgz>

unzip_data = BashOperator(
    task_id = 'unzip_data',
    bash_command = 'tar -xzf /home/project/airflow/dags/finalassignment/tolldata.tgz',
    dag=dag,
)


# extract data 

# to csv 
#  cut -d"," -f1-3 > csv_file.csv

# from csv 
# cut -d"," -f1-3 < csv_file.csv

#from tsv 
# tr "\t" "," < tsv_file.tsv

# from fixed_width.txt 
# cat fixed_width.txt | tr -s "[:space:]"



# extract_data_from_csv
extract_data_from_csv = BashOperator( 
    task_id = 'extract_data_from_csv',
    bash_command = 'cut -d"," -f1-4 < vehicle-data.csv > csv_data.csv',
    # Rowid, Timestamp, Anonymized Vehicle number, Vehicle type from the vehicle-data.csv
    dag=dag,
)

# extract_data_from_tsv
extract_data_from_tsv = BashOperator(
    task_id = 'extract_data_from_tsv',
    bash_command = 'tr "\t" "," < tollplaza-data.tsv | cut -d"," -f5-7 > tsv_data.csv',
    # Number of axles, Tollplaza id, and Tollplaza code from the tollplaza-data.tsv
    dag=dag,
)

# extract_data_from_fixed_width
extract_data_from_fixed_width = BashOperator(
    task_id = 'extract_data_from_fixed_width',
    bash_command = 'cat payment-data.txt | tr -s "[:space:]" | cut -d"," -f11,12 > fixed_width_data.csv',
    # Type of Payment code, and Vehicle Code from the fixed width file payment-data.txt
    dag=dag,
)

# consolidate_data 
consolidate_data = BashOperator ( 
    task_id = 'consolidate_data',
    bash_command = 'paste csv_data.csv tsv_data.csv fixed_width_data.csv > extracted_data.csv',
    dag=dag,
)

# transform_data
transform_data = BashOperator ( 
    task_id = 'transform_data',
    bash_command = 'tr "[a-z]" "[A-Z]" < extracted_data.csv > transformed_data.csv',
    # transform the vehicle_type field in extracted_data.csv into capital letters 
    # and save it into a file named transformed_data.csv in the staging directory.
    dag=dag,
)

# task pipeline
unzip_data >> extract_data_from_csv >> extract_data_from_tsv >> extract_data_from_fixed_width >> consolidate_data >> transform_data

'''
export AIRFLOW_HOME=/home/project/airflow
echo $AIRFLOW_HOME


export AIRFLOW_HOME=/home/project/airflow
 cp ETL_toll_data.py $AIRFLOW_HOME/dags


'''

# airflow dags list-import-errors


# airflow tasks ETL_toll_data


 
