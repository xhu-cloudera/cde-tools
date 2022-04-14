from datetime import datetime, timedelta
from airflow import DAG
from airflow.utils import timezone
from airflow.operators.dummy_operator import DummyOperator
from httpx import delete
from cloudera.cdp.airflow.operators.cde_operator import CDEJobRunOperator

default_args = {
    'owner': 'cdpuser1',
    'depends_on_past': False,
}

dag = DAG(
    'dynamic_spark_dag',
    default_args=default_args,
    start_date=timezone.utcnow(),
    schedule_interval='@once',
    catchup=False,
    is_paused_upon_creation=False
)

# make sure spark_sql_shell_mimic job is created before hand
create_db = CDEJobRunOperator(
    task_id='create_db',
    dag=dag,
    job_name='spark_sql_shell_mimic',
    variables={
        'spark_queries': """{{ dag_run.conf['create_db_query'] }}"""
    }
)

drop_db = CDEJobRunOperator(
    task_id='drop_db',
    dag=dag,
    job_name='spark_sql_shell_mimic',
    variables={
        'spark_queries': """{{ dag_run.conf['drop_db_query'] }}"""
    }
)

# pylint: disable=pointless-statement,line-too-long
create_db >> drop_db