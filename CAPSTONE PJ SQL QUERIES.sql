--REFERENCE SYNAX--

SELECT *
FROM sales_reps;

SELECT *
FROM orders;

SELECT *
FROM accounts;

SELECT *
FROM web_events;

SELECT *
FROM region;

-- QUESTION 1
-- The top-performing sales representatives based on total orders and sales across different regions

SELECT s.name AS sales_rep_name,
       r.name AS region_name,
       SUM(total_amt_usd) AS total_sales,
       COUNT(o.id) AS total_orders
FROM orders AS o
JOIN accounts AS a 
ON a.id = o.account_id
JOIN sales_reps AS s 
ON a.sales_rep_id = s.id
JOIN region AS r 
ON r.id = s.region_id
GROUP BY s.id,s.name, r.name
ORDER BY total_sales DESC
LIMIT 10;


--Question 2
--top 5 sales representative managing a larger number of clients but generating lower sales
SELECT s.name as sales_rep_name,
       s.id as sales_reP_id,
       COUNT(DISTINCT a.id) as total_clients,  
       SUM(total_amt_usd) as total_sales
FROM orders as o
JOIN accounts as a 
ON a.id = o.account_id
JOIN sales_reps as s 
ON a.sales_rep_id = s.id
GROUP BY s.name, s.id
ORDER BY total_clients DESC, total_sales ASC
LIMIT 5                 

--Question 3
--region with the lowest sales despite a higher no of clients
SELECT r.name,
       COUNT(DISTINCT a.id) as total_clients,
       SUM(total_amt_usd) as total_sales
FROM orders as o
JOIN accounts as a 
ON a.id = o.account_id
JOIN sales_reps as s 
ON a.sales_rep_id = s.id
JOIN region as r 
ON r.id = s.region_id
GROUP BY r.name
ORDER BY total_sales ASC, total_clients DESC

-- Q4
-- best selling paper
SELECT 
    'Standard' AS paper_type, SUM(standard_amt_usd) AS total_sales
FROM orders
UNION ALL
SELECT 
    'Gloss' AS paper_type, SUM(gloss_amt_usd) AS total_sales
FROM orders
UNION ALL
SELECT 
    'Poster' AS paper_type, SUM(poster_amt_usd) AS total_sales
FROM orders
ORDER BY total_sales DESC
LIMIT 3;

--Q5
--total sales from each channel

SELECT DISTINCT web_events.channel, 
       SUM(orders.total_amt_usd) as total_sales_by_channel
FROM web_events
JOIN accounts
ON accounts.id=web_events.account_id
JOIN orders
ON orders.account_id=accounts.id
GROUP BY web_events.channel 
ORDER BY total_sales_by_channel DESC;

--Q6
--regions that generate highest and lowest total sales and clients
SELECT region.name, SUM(total_amt_usd) as total_sales,COUNT(DISTINCT accounts.id) as no_clients
FROM orders
JOIN accounts
ON orders.account_id=accounts.id
JOIN sales_reps
ON accounts.sales_rep_id=sales_reps.id
JOIN region
ON region.id=sales_reps.region_id
GROUP BY region.name
ORDER BY total_sales DESC

--Q7 
--are there seasonal trends in orders, and when do sales peak or drop?

SELECT
    DATE_PART('month', occurred_at) AS Month,
    COUNT(id) AS Number_of_Orders,
    SUM(total_amt_usd) AS Total_sales
FROM Orders
GROUP BY Month
ORDER BY Month DESC;

--Q8
-- What is  the average order frequency for customers in each region
SELECT region.name as region,
       COUNT(orders.id)/ COUNT(DISTINCT accounts.id) as avg_orders_per_client
FROM orders
JOIN accounts
  ON orders.account_id = accounts.id
JOIN sales_reps
  ON accounts.sales_rep_id = sales_reps.id
JOIN region
  ON region.id=sales_reps.region_id
GROUP BY region
ORDER BY avg_orders_per_client DESC; 

--Q9
-- Client that generates the highest sales, in terms of qty and revenue. 
--who are their assigned sales_reps

SELECT accounts.id AS client_id, accounts.name AS client_name,
       SUM(orders.total) AS total_qty,
       SUM(orders.total_amt_usd) AS total_sales,
       accounts.sales_rep_id,
       sales_reps.name AS sales_rep_name
FROM orders
JOIN accounts
  ON orders.account_id = accounts.id
JOIN sales_reps
  ON accounts.sales_rep_id = sales_reps.id
GROUP BY accounts.id, accounts.sales_rep_id, sales_reps.name, client_name
ORDER BY total_sales DESC, total_qty DESC
LIMIT 1;

--Q10 The distribution of sales by paper type across different regions
SELECT 
    region.name AS region,
    SUM(poster_amt_usd) AS poster_sales, 
    SUM(gloss_amt_usd) AS gloss_sales, 
    SUM(standard_amt_usd) AS standard_sales
FROM orders
JOIN accounts ON orders.account_id = accounts.id
JOIN sales_reps ON accounts.sales_rep_id = sales_reps.id
JOIN region ON region.id = sales_reps.region_id
GROUP BY region.name

