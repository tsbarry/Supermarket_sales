# second, use psycopg2 and conn.cursor to connect and access the schema and read it.
import psycopg2
import psycopg2.extras
import csv
import os
from config import password 

params = {
    "host"      : "localhost",
    "dbname"    : "postgres",
    "user"      : "postgres",
    "password"  : password,
    "port" : "5432"     
}

conn = psycopg2.connect(**params) 

with conn.cursor() as cursor:
    # READ FILES IN PYTHON
    with open('Schema.sql', 'r') as schema:
        queries = schema.read()
        print(queries)
        cursor.execute(queries)
    conn.commit() 