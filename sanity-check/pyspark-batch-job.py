from __future__ import print_function

import sys
from time import sleep
from pyspark.sql import SparkSession

if __name__ == "__main__":
    spark = SparkSession.builder.getOrCreate()

    print("***** Current Logged In User: ******")
    print(spark.sparkContext.sparkUser())

    print("Sleeping for 5sec before Stopping Session")
    sleep(5)
    spark.stop()
