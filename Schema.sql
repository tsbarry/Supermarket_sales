----First create a schema.sql to create a schema and table-------
----drop schema if exits so that everytime we run the code it will not keep telling us that the schema exist---
DROP SCHEMA IF EXISTS sales CASCADE;
----create schema---
CREATE SCHEMA sales;
---drop table if exit and create the table with the data types, then grant privilages of tables to the DB.
drop table IF EXISTS sales.market;

create table sales.market
(
    Invoice_ID varchar(100),
    Branch varchar(50),
	City varchar (100),
    Customer_type varchar(100),
    Gender varchar(50),
    Product_line varchar(100),
    Unit_price FLOAT,
    Quantity FLOAT,
    Tax FLOAT,
    Total FLOAT,
    Date DATE,
    Time TIME,
    Payment varchar(50),
    COGS FLOAT,
    Gross_margin_percentage FLOAT,
    Gross_income FLOAT,
    Rating FLOAT

);

GRANT ALL PRIVILEGES ON all tables in SCHEMA sales TO postgres;