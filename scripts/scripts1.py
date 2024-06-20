import datetime as dt
import numpy as np
import os
from pyspark.sql import SparkSession


def task1():
    spark = SparkSession.builder \
        .appName("example_pyspark_task") \
        .getOrCreate()
    PATH_CSV = '/opt/airflow/data/raw'
    NAME_CSV = 'scontrini922.csv'
    COMPLETE_PATH = os.path.join(PATH_CSV, NAME_CSV)
    print(COMPLETE_PATH)
    # Leggi il file CSV
    df = spark.read.csv(COMPLETE_PATH, header=True, inferSchema=True)
    # Ferma la sessione Spark
    spark.stop()
    print(f"the df has been read: {df}")