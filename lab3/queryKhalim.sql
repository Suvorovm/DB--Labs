import random
import time
import psycopg2
import datetime
conn = psycopg2.connect(dbname='hotelaaa', user='admin',
                        password='samihad228', host='localhost')
cursor = conn.cursor()



conn.close()
