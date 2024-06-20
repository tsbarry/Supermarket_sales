## lastly, using the cursor to open the csv data and send it to the database with all the rows and columns. 
import psycopg2
import psycopg2.extras
import csv
import os
from config import password
# aws rds 

params = {
    "host"      : "localhost",
    "dbname"    : "postgres",
    "user"      : "postgres",
    "password"  :  password, 
    "port" : "5432"     
}

conn = psycopg2.connect(**params)

with conn.cursor() as cursor:
    
    with open('data/supermarketsales.csv', 'r') as f:    
        cmd = 'COPY sales.market ("invoice_id","branch","city","customer_type","gender","product_line","unit_price","quantity","tax","total","date","time","payment","cogs","gross_margin_percentage","gross_income","rating") FROM STDIN WITH (FORMAT CSV, HEADER TRUE)'
    
        cursor.copy_expert(cmd, f)
    conn.commit()
