-- Active: 1716962236575@@127.0.0.1@5432@postgres
1. --CHECKING THE DATA--

 SELECT *
 FROM market; 

 2. --DOING SOME DATA CLEANING, BY CHECKING FOR NULL VALUES--

SELECT
  SUM(CASE WHEN invoice_id IS NULL THEN 1 ELSE 0 END) AS invoice_id_null,
  SUM(CASE WHEN branch IS NULL THEN 1 ELSE 0 END) AS branch_null,
  SUM(CASE WHEN city IS NULL THEN 1 ELSE 0 END) AS city_null,
  SUM(CASE WHEN customer_type IS NULL THEN 1 ELSE 0 END) AS customer_type_null,
  SUM(CASE WHEN gender IS NULL THEN 1 ELSE 0 END) AS gender_null,
  SUM(CASE WHEN product_line IS NULL THEN 1 ELSE 0 END) AS product_line_null,
  SUM(CASE WHEN unit_price IS NULL THEN 1 ELSE 0 END) AS unit_price_null,
  SUM(CASE WHEN quantity IS NULL THEN 1 ELSE 0 END) AS quantity_null,
  SUM(CASE WHEN tax IS NULL THEN 1 ELSE 0 END) AS tax_null,
  SUM(CASE WHEN total IS NULL THEN 1 ELSE 0 END) AS total_null,
  SUM(CASE WHEN date IS NULL THEN 1 ELSE 0 END) AS date_null,
  SUM(CASE WHEN time IS NULL THEN 1 ELSE 0 END) AS time_null,
  SUM(CASE WHEN payment IS NULL THEN 1 ELSE 0 END) AS payment_null,
  SUM(CASE WHEN cogs IS NULL THEN 1 ELSE 0 END) AS cogs_null,
  SUM(CASE WHEN gross_margin_percentage IS NULL THEN 1 ELSE 0 END) AS gmp_null,
  SUM(CASE WHEN gross_income IS NULL THEN 1 ELSE 0 END) AS gross_income_null,
  SUM(CASE WHEN rating IS NULL THEN 1 ELSE 0 END) AS rating_null
FROM market;
----THERE ARE NO NULL VALUES IN THE MARKET TABLE---- 

3.--CHECKING FOR UNIQUE INVOICE_ID-- 

SELECT COUNT(DISTINCT invoice_id) AS unique_invoice_id
FROM market;

4.--REMOVING DUPLICATE RECORDS FROM THE INVOICE_ID COLUMN--
-- Using subquery to identify the duplicate invoice_id values in the market table --

DELETE FROM market
WHERE invoice_id IN (
  SELECT invoice_id
  FROM (
    SELECT invoice_id
    FROM market
    GROUP BY invoice_id
    HAVING COUNT(*) > 1
  ) AS duplicates
);
--There are no duplicates therefore all invoice id's are unique---

--PERFORMING SOME ANALYSIS AND INSIGHTS ON THE MARKET TABLE
--BY Filtering, Grouping, Aggregate functions, Conditional, Window Functions--

SELECT * FROM market
WHERE (branch = 'A' OR branch = 'B') AND (customer_type = 'Member' OR customer_type = 'Normal') AND rating >= 4;

4.--WHAT IS THE MIN, MAX, and AVG PRICE OF EACH PRODUCT?

SELECT 
product_line, 
  MIN(unit_price) AS min_price,
  MAX(unit_price) AS max_price,
  AVG(unit_price) AS avg_price
  FROM market
  GROUP BY product_line;

5.--WHAT IS THE MIN, MAX, and AVG TOTAL AMOUNT SPENT? 

SELECT  
MIN(total) AS min_total,
MAX(total) AS max_total,
AVG(total) AS avg_total
FROM market;

6.--WHAT IS THE TOTAL SALES REVENUE?

SELECT SUM(total) AS total_sales_revenue
FROM market;
--The total sales revenue is 322966.74900000007--
a.--WHAT IS THE TOTAL SALES REVENUE IN THE CITY OF YANGON BETWEEN 2018 AND 2019?

SELECT SUM(total) AS total_sales_revenue
FROM market
WHERE date BETWEEN '2018-12-31' AND '2019-03-29' AND city = 'Yangon';
--The total sales revenue in Yangon in 2019 is 104879.7540000001.
b.--WHAT IS THE NUMBER OF SALES MADE IN EACH CITY?

SELECT city, COUNT(*) AS total_sales_count
FROM market
GROUP BY city
ORDER BY total_sales_count DESC;
--The number of sales made in each city is as follows:
--Yangon: 340
--Mandalay: 332
--Naypyitaw: 328

7.--WHAT IS THE TOTAL SALES REVENUE BY BRANCH?

SELECT branch, SUM(total) AS total_sales_revenue
FROM market
GROUP BY branch;
--The total sales revenue by the branch is:
--A:  106200.3705000001
--B:  106197.67199999996
--C:  110568.70649999994 
8.--WHAT IS THE TOTAL SALES REVENUE BY THE PRODUCT LINE AND THE AVG PRICE FOR EACH PRODUCT LINE?

SELECT product_line, SUM(total) AS total_sales_revenue, AVG(unit_price) AS avg_price
FROM market
GROUP BY product_line
ORDER BY total_sales_revenue ASC;
--The total sales revenue by product line is:
                    --total_sales-revenue     --avg_price
--Health and beauty: 49193.739000000016  -- 54.85447368421053
--Home and lifestyle: 53861.91300000001  -- 55.31693749999997
--Fashion accessories: 54305.895         -- 57.15365168539324
--Electronic accessories: 54337.531500000005 -- 53.551588235294155
--Sports and travel: 55122.826499999996   -- 56.993253012048164
--Food and beverages: 56144.844000000005 -- 56.00885057471268

a.--WHAT IS THE PERCENTAGE CONTRIBUTION OF EACH PRODUCT LINE TO THE TOTAL SALES? 

SELECT product_line, SUM(total) AS sales, (SUM(total) / (SELECT SUM(total) FROM market)) * 100 AS sales_percentage
FROM market
GROUP BY product_line
ORDER BY sales_percentage DESC;
--The percentage contribution of each product line to total sales is:
--Food and beverages      17.384094236896193
--Sports and travel       17.067647573837387
--Electronic accessories  16.824497155897618
--Fashion accessories     16.81470156545434
--Home and lifestyle      16.677231686163456
--Health and beauty       15.231827781750995

9.--WHAT IS THE TOTAL SALES REVENUE BY CUSTOMER TYPE?

SELECT customer_type, SUM(total) AS total_sales_revenue
FROM market
GROUP BY customer_type;
--The total sales revenue by customer type is:
--Normal: 158743.305
--Member: 164223.44400000002


10.--WHAT ARE THE TOP 5 BRANCHES WITH THE HIGHEST GROSS INCOME and THE LOCATIONS?

SELECT branch, gross_income, city
FROM market
ORDER BY gross_income DESC
LIMIT 5;
--The top 5 branches with the highest gross income are:
--C: 49.65 Naypyitaw
--A: 49.49 Yangon
--C: 49.26 Naypyitaw
--C: 48.75 Naypyitaw
--B: 48.69 Mandalay

11.--WHAT IS THE TOTAL and AVERAGE TAX AMOUNT FOR EACH CUSTOMER TYPE?

SELECT customer_type, SUM(tax) AS total_tax, AVG(tax) AS avg_tax
FROM market
GROUP BY customer_type;
--The total and average tax for each customer type is:
--Normal:  7559.205000000002 --- 15.148707414829662
--Member:  7820.164000000002 --- 15.609109780439125
a.--WHICH PAYMENT METHOD HAS THE HIGHEST TOTAL TAX AMOUNT? 

SELECT payment, SUM(tax) AS total_tax_amount
FROM market
GROUP BY payment
ORDER BY total_tax_amount DESC
LIMIT 3;
--The payment method with the highest total tax amount is:
--Cash:  5343.170000000006
--Ewallet: 5207.5585
--Credit Card: 4798.432000000001

b.--WHAT IF A CUSTOMER/CLIENT WANTS TO UPDATE THEIR PAYMENT METHOD FROM Ewallet TO A Credit Card?

UPDATE market
SET payment = 'Credit Card'
WHERE invoice_id = '373-73-7910';
Select * FROM market
WHERE invoice_id = '373-73-7910';
12.--WHICH GENDER SPENT THE MOST?

SELECT gender, SUM(total) AS total_spending
FROM market
GROUP BY gender
ORDER BY total_spending DESC;
--The gender that spent the most money is:
--Female: 167882.92500000002
--Male:  155083.82400000014

13.--WHAT IS THE TOTAL SALES FOR CUSTOMERS WHO HAVE MADE PURCHASES ABOVE THE AVERAGE TOTAL? 

SELECT customer_type, SUM(total) AS total_sales
FROM market
WHERE total > (SELECT AVG(total) FROM market)
GROUP BY customer_type;

-----USING AGGREGATTE FUNCTIONS WITH CONDITIONALS-----

a.--Calculating the average rating for each product line, categorizing them as "Very Good", "Good," "Average," or "Poor" based on their average rating value--

SELECT product_line, AVG(rating) AS average_rating,
       CASE
	   	     WHEN AVG(rating) > 7 THEN 'Very Good'
           WHEN AVG(rating) >= 4.5 THEN 'Good'
           WHEN AVG(rating) >= 3.0 THEN 'Average'
           ELSE 'Poor'
       END AS rating_category
FROM market
GROUP BY product_line;

b.--Determining the total tax amount for each payment method, and categorizing them as "High" or "Low" based on the total tax amount--
SELECT payment,
       SUM(tax) AS total_tax,
       CASE
           WHEN SUM(tax) > 1000 THEN 'High'
           ELSE 'Low'
       END AS tax_category
FROM market
GROUP BY payment; 

c.--Calculating the total gross income for each branch, categorizing them as "High," "Medium," or "Low" based on the total gross income--
SELECT branch,
       SUM(gross_income) AS total_income,
       CASE
           WHEN SUM(gross_income) > 5500 THEN 'High'
           WHEN SUM(gross_income) > 2500 THEN 'Medium'
           ELSE 'Low'
       END AS income_category
FROM market
GROUP BY branch;

-------------------USING WINDOW FUNCTIONS TO FILTER-------------
14.--WHAT IS THE BEST-SELLING PRODUCT LINE IN EACH MONTH? 

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

---Ranking sales records within each branch based on the total sales amount and display the top 5 records from each branch--
SELECT * FROM (
  SELECT *, ROW_NUMBER() OVER (PARTITION BY branch ORDER BY total DESC) AS row_num
  FROM market
) AS ranked
WHERE row_num <= 5;

-----MORE ANALYSIS OF THE DATA--- 
15.--HOW MANY SALES TRANSACTIONS WERE MADE ON EACH DATE?
SELECT date, COUNT(*) AS num_transactions
FROM market
GROUP BY date
ORDER BY num_transactions desc;

16.--WHAT IS THE TOTAL QUANTITY SOLD FOR EACH PRODUCT LINE IN EACH MONTH?

SELECT EXTRACT(MONTH FROM date) AS MONTH, product_line, SUM(quantity) AS total_quantity
FROM sales.market
GROUP BY EXTRACT(MONTH FROM date), product_line;  

a.--WHICH HOURS ARE PRODUCTS SOLD THE MOST? 

SELECT EXTRACT (HOUR FROM time) AS hour,
  SUM(quantity) AS total_quantity
FROM market
GROUP BY EXTRACT (HOUR FROM time)
ORDER BY total_quantity desc; 
--The best hour for sales is : 
--hour | total_quantity
-- 19 |  649
-- 13 |  585
-- 15 |  530
-- 10 |  525
-- 11 |  513
-- 12 |  501
-- 14 |  495
-- 18 |  475
-- 16 |  420
-- 17 |  415
-- 20 |  402

17.--WHAT IS THE AVERAGE RATING FOR EACH PRODUCT LINE IN EACH CITY --

SELECT city, product_line, AVG(rating) AS average_rating
FROM sales.market 
GROUP BY city, product_line
ORDER BY average_rating Desc;

18.--WHICH PAYMENT METHOD HAS THE HIGHEST TOTAL SALES AMOUNT

SELECT payment, SUM(total) AS total_sales
FROM sales.market
GROUP BY payment
ORDER BY total_sales DESC
LIMIT 1;


19.--WHAT IS THE AVERAGE GROSS INCOME FOR EACH BRANCH AND PAYMENT METHOD COMBINATION?

SELECT branch, payment, AVG(gross_income) AS average_income
FROM sales.market
GROUP BY branch, payment
ORDER BY average_income DESC;


 20.--WHICH PAYMENT METHOD HAS THE HIGHEST AVERAGE RATING? 

SELECT payment, AVG(rating) AS average_rating
FROM sales.market
GROUP BY payment
ORDER BY average_rating DESC
LIMIT 1;

21.--WHAT IS THE TOTAL REVENUE GENERATED BY EACH CUSTOMER TYPE IN EACH CITY, WHERE TRANSACTIONS RATING IS 5 AND ABOVE? 

SELECT city, customer_type, SUM(total) AS total_revenue
FROM sales.market
WHERE rating >= 5
GROUP BY city, customer_type;








