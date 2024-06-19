from airflow import DAG
from airflow.operators.dummy_operator import DummyOperator
from airflow.operators.python_operator import PythonOperator
from datetime import datetime
from scripts import scripts1

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2024, 6, 19),
    'retries': 1,
}

dag = DAG(
    'read_csv',
    default_args=default_args,
    description='read a csv from a folder',
    schedule_interval='@daily',
)

start = DummyOperator(task_id='start', dag=dag)

task1_operator = PythonOperator(
    task_id='task1',
    python_callable=scripts1.task1,
    dag=dag,
)

start >> task1_operator
