import pandas as pd
import datetime as dt
import numpy as np
import os



def task1():
    PATH_CSV = '/opt/airflow/data/raw'
    NAME_CSV = 'scontrini922.csv'
    COMPLETE_PATH = os.path.join(PATH_CSV, NAME_CSV)
    print(COMPLETE_PATH)
    df = pd.read_csv(os.path.join(PATH_CSV, NAME_CSV))
    print(f"the df has been read: {df}")