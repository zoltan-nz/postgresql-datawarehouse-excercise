\echo *****************************
\echo Assignment 5 - Zoltan Debre
\echo *****************************
\echo

-- Preparation
\echo Import seed database...
\i ./BookOrdersDatabaseDump_17.sql

\echo Seed database imported.
\echo Database cleanup

UPDATE customer SET city = 'Sydney' WHERE customer.city = 'Sidney';
UPDATE customer SET district = 'Povardarje' WHERE CustomerId = 96;
UPDATE customer SET district = 'Budapest' WHERE CustomerId = 100;

DROP MATERIALIZED VIEW IF EXISTS avg_spending_by_customer_on_each_day CASCADE;
DROP MATERIALIZED VIEW IF EXISTS sum_customer_per_day CASCADE;
DROP MATERIALIZED VIEW IF EXISTS avg_amnt_view CASCADE;
DROP MATERIALIZED VIEW IF EXISTS sales CASCADE;
DROP TABLE IF EXISTS time CASCADE;

--
-- QUESTION 1
--

\echo
\echo ---------------------------------
\echo Question 1 - Creating TIME table.
\echo ---------------------------------
\echo

-- Create time table
\echo Creating time table

CREATE TABLE time
(
  TimeId    SERIAL PRIMARY KEY NOT NULL,
  OrderDate DATE               NOT NULL,
  DayOfWeek VARCHAR(10)        NOT NULL,
  Month     VARCHAR(10)        NOT NULL,
  Year      INT                NOT NULL
);
CREATE UNIQUE INDEX time_TimeId_uindex ON time (TimeId);

-- Populate time table

INSERT INTO time (OrderDate, DayOfWeek, Month, Year)
  SELECT DISTINCT
    cust_order.orderdate                    AS OrderDate,
    to_char(cust_order.orderdate, 'Day')    AS DayOfWeek,
    to_char(cust_order.orderdate, 'Month')  AS Month,
    extract(YEAR FROM cust_order.orderdate) AS Year
  FROM cust_order
  ORDER BY OrderDate ASC;

\echo Time table is updated, number of records:
SELECT count(*) FROM time;

\echo
\echo Creating and uploading sales table
\echo

CREATE MATERIALIZED VIEW sales AS
  SELECT
    customer.customerid                                      AS CustomerId,
    time.TimeId                                              AS TimeId,
    book.isbn                                                AS ISBN,
    sum(order_detail.quantity * book.price) :: NUMERIC(6, 2) AS Amnt
  FROM book NATURAL JOIN order_detail NATURAL JOIN cust_order NATURAL JOIN customer NATURAL JOIN time
  GROUP BY customer.customerid, TimeId, ISBN
  ORDER BY CustomerId, TimeId, ISBN;

CREATE UNIQUE INDEX sales_CustomerIdTimeIdISBN_uindex ON sales (CustomerId, TimeId, ISBN);

\echo Number of records in sales:
SELECT count(*) FROM sales;

--
-- QUESTION 2
--

\echo
\echo ---------------------------------
\echo Question 2 - Aggregate Queries
\echo ---------------------------------
\echo

\echo Calculating averages from averages - WRONG!

CREATE MATERIALIZED VIEW avg_amnt_view AS
  SELECT
    CustomerId,
    avg(Amnt) AS avg_amnt
  FROM sales
  GROUP BY customerid;

SELECT avg(avg_amnt) FROM avg_amnt_view;

\echo In this case we calculate the average of all individual transactions, so this number is the average amount of transactions:
\echo
SELECT avg(amnt) FROM sales;

\echo
\echo Update! Later, when I got more accurate information about what we should calculate, and need average based on all the three dimensions, I realized the above answer is right. So I just leave here the following calculation what I did for two dimensions.
\echo

-- Find the average amount of money spent by all customers on buying books for all days so far.

\echo We are looking for the average amount of money spent by all customers for all days, so first we have to create a intermediate tuple.
\echo
CREATE MATERIALIZED VIEW sum_customer_per_day AS
  SELECT
    customerid,
    timeid,
    sum(amnt) AS amnt_spent_daily_by_customers
  FROM sales
  GROUP BY customerid, timeid;

\echo We have 198 unique customer-day tuple, so we can calculate an average.
\echo
SELECT avg(amnt_spent_daily_by_customers) AS avg_spending_by_customers_per_day FROM sum_customer_per_day;

\echo
\echo Or we can calculate from the other direction. First creatin a materialized view which list the average spending by customer each day and using this avg and count to calculate our final daily avg spending.
\echo

CREATE MATERIALIZED VIEW avg_spending_by_customer_on_each_day AS
  SELECT
    timeid,
    count(customerid)                                       AS number_of_customer_a_day,
    avg(sum_customer_per_day.amnt_spent_daily_by_customers) AS avg_spending FROM sum_customer_per_day
  GROUP BY timeid;

SELECT
  sum(avg_spending_by_customer_on_each_day.avg_spending * avg_spending_by_customer_on_each_day.number_of_customer_a_day)
  / sum(avg_spending_by_customer_on_each_day.number_of_customer_a_day) AS Total_AVG
FROM avg_spending_by_customer_on_each_day;

--
-- QUESTION 3
--

\echo
\echo ---------------------------------
\echo Question 3 - OLAP Queries
\echo ---------------------------------
\echo

\echo
\echo a) Customer id’s, names and surnames of five customers who spent the largest amount of money buying books:
\echo

SELECT
  customer.CustomerId AS customer_id,
  customer.f_name     AS first_name,
  customer.l_name     AS last_name,
  sum(amnt)           AS spending
FROM sales
  NATURAL JOIN customer
GROUP BY customer.CustomerId
ORDER BY spending DESC LIMIT 5;