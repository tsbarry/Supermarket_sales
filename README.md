# Supermarket Sales Analysis

## Table of Contents 

- [Project Overview](#project-overview)
- [Data Sources ](#data-sources)
- [Tools](#tools)
- [Data Preparation Cleaning](#data-preparation-cleaning)
- [Exploratory Data Analysis](#exploratory-data-analysis)
- [Data Analysis](#data-analysis) 
- [Results Findings](#results-findings)
- [Recommendations](#recommendations)

### Project Overview 

This project aims to provide comprehensive insights into supermarket sales performance through an in-depth analysis of sales data using SQL. The dataset encompasses a wide range of information, including sales transactions, invoice details, branch performance, customer demographics, product specifics, pricing structures, taxes, payment methods, and customer ratings.

By carefully analyzing these various aspects of the data, we aim to uncover key trends, derive actionable insights, and formulate data-driven recommendations that enhance overall supermarket performance.

The project will prioritize data cleaning and preprocessing to ensure the dataset's integrity, followed by the application of data filtering and aggregation techniques to extract meaningful insights. Ultimately, this analysis will facilitate a deeper understanding of sales dynamics and customer behavior, empowering stakeholders to make informed decisions that drive growth and improve operational efficiency.

### Data Sources 

Sales Data: The primary dataset used for this analysis is the "supermarketsales.csv" file in the data folder. This data was retrieved from Kaggle.

### Tools 

- SQL [PostgreSQL--psycopg2] - Create a schema, send CSV data into a database, data cleaning and analysis. 
- Tableau -Creating reports

### Data Preparation Cleaning 
  In the initial data preparation phase, we performed the following tasks:
  1. Data loading and inspection.
  2. Creating a schema and table.
  3. use psycopg2 and a cursor to connect and access the schema and read it.
  4. using the cursor to open the CSV data and send it to the database
  5. Handling missing values using SQL queries.
  6. Data cleaning, formatting, filtering, and aggregations using SQL queries.

### Exploratory Data Analysis

EDA involved exploring the sales data to answer key questions such as: 

- What is the total sales revenue?
- What is the percentage contribution of each product line to the total sales?
- What is the best-selling product for each month/day?
- What are the pick sales periods? etc...

### Data Analysis 
Here are some examples of the analyses done

- Removing duplicates from the table
  
```sql
DELETE FROM market
WHERE invoice_id IN (
  SELECT invoice_id
  FROM (
    SELECT invoice_id
    FROM market
    GROUP BY invoice_id
    HAVING COUNT(*) > 1
  ) AS duplicates;
```

- What is the total sales revenue in the city of Yangon between 2018 & 2019?

```sql
SELECT SUM(total) AS total_sales_revenue
FROM market
WHERE date BETWEEN '2018-12-31' AND '2019-03-29' AND city = 'Yangon';
```
- What is the percentage contribution of each product line to the total sales?
```sql
SELECT product_line, SUM(total) AS sales, (SUM(total) / (SELECT SUM(total) FROM market)) * 100 AS sales_percentage
FROM market
GROUP BY product_line
ORDER BY sales_percentage DESC;
```
- What is the total tax amount for each payment method, and rate it as "High" or "Low" based on the total tax amount?
```sql
SELECT payment,
       SUM(tax) AS total_tax,
       CASE
           WHEN SUM(tax) > 1000 THEN 'High'
           ELSE 'Low'
       END AS tax_category
FROM market
GROUP BY payment;
```

- What is the best-selling product line in each month?
  
```sql
WITH monthly_sales AS (
SELECT DATE_TRUNC('MONTH', date) AS sales_month, product_line,
    SUM(total) AS total_sales
FROM market
GROUP BY DATE_TRUNC('MONTH', date), product_line
)
SELECT sales_month, product_line, total_sales
FROM (
SELECT sales_month, product_line, total_sales,
    ROW_NUMBER() OVER (PARTITION BY sales_month ORDER BY total_sales DESC) AS row_num
FROM monthly_sales
) AS subquery
WHERE row_num = 1
ORDER BY sales_month;
```

### Results Findings
The analysis results are summarized as follows: 

1. The top revenue of the supermarket comes from the food & beverages product line, followed by sports/travel and electronic sales.
2. Branch C is the best-performing branch in terms of sales and revenue.
3. Customers with Members card should be targeted for marketing efforts as they bring in the most revenue.
4. Fashion accessories, Health, and beauty, Food, and beverages had a higher average rating more than 7 out of 10.

### Recommendations 
Based on the analysis, the following is recommended: 
- invest in marketing and promotions during peak seasons to maximize revenue.
- Focus on expanding and promoting products in branch C.
- Implement a customer segmentation strategy to target both Members and Normal customers effectively. 
