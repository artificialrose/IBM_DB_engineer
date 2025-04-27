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
    'process_web_log',
    schedule_interval = timedelta(days=1),
    default_args = default_args,
    description = 'capstone project Apache Airflow',
)

# define task extract_data

bash_operator = BashOperator ( 
    task_id = 'extract_data',
    bash_command = 'cut -d" " -f1 /home/project/airflow/dags/capstone/accesslog.txt > cat /home/project/airflow/dags/capstone/extracted_data.txt',
    dag=dag,
)

# define task transform_data

bash_operator = BashOperator ( 
    task_id = 'transform_data',
    bash_command = 'cat /home/project/airflow/dags/capstone/extracted_data.txt | grep "198.46.149.143" > /home/project/airflow/dags/capstone/transformed_data.txt' ,
    dag=dag,
)


# define task load_data

bash_operator = BashOperator ( 
    task_id = 'load_data',
    bash_command = 'tar -cvf /home/project/airflow/dags/capstone/weblog.tar /home/project/airflow/dags/capstone/transformed_data.txt' ,
    dag=dag,
)

# task pipeline
extract_data >> transform_data >> load_data

'''
export AIRFLOW_HOME=/home/project/airflow
echo $AIRFLOW_HOME


export AIRFLOW_HOME=/home/project/airflow
sudo cp process_web_log.py $AIRFLOW_HOME/dags


'''
sudo mv airflow/dags/pocess_web_log.py
