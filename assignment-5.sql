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

DROP MATERIALIZED VIEW IF EXISTS perc_of_ord CASCADE;
DROP MATERIALIZED VIEW IF EXISTS no_of_ord CASCADE;
DROP MATERIALIZED VIEW IF EXISTS ord_avg_amnt CASCADE;
DROP MATERIALIZED VIEW IF EXISTS amount_per_order CASCADE;
DROP MATERIALIZED VIEW IF EXISTS best_buyers CASCADE;
DROP MATERIALIZED VIEW IF EXISTS avg_spending_by_customer_on_each_day CASCADE;
DROP MATERIALIZED VIEW IF EXISTS sum_customer_per_day CASCADE;
DROP MATERIALIZED VIEW IF EXISTS avg_amnt_view CASCADE;
DROP TABLE IF EXISTS sales_table CASCADE;
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
    time.timeid                                              AS TimeId,
    book.isbn                                                AS ISBN,
    sum(order_detail.quantity * book.price) :: NUMERIC(6, 2) AS Amnt
  FROM book NATURAL JOIN order_detail NATURAL JOIN cust_order NATURAL JOIN customer NATURAL JOIN time
  GROUP BY customer.customerid, time.timeid, book.isbn
  ORDER BY CustomerId, TimeId, ISBN;

CREATE UNIQUE INDEX sales_CustomerIdTimeIdISBN_uindex ON sales (CustomerId, TimeId, ISBN);

\echo Number of records in sales:
SELECT count(*) FROM sales;


\echo
\echo Creating traditional sales table. (I will use the materialized view in this assingment.)
\echo

CREATE TABLE sales_table
(
  customerid INTEGER       NOT NULL
    CONSTRAINT sales_customer_customerid_fk
    REFERENCES customer,
  timeid     INTEGER       NOT NULL
    CONSTRAINT sales_time_timeid_fk
    REFERENCES time,
  isbn       INTEGER       NOT NULL
    CONSTRAINT sales_book_isbn_fk
    REFERENCES book,
  amnt       NUMERIC(6, 2) NOT NULL,
  CONSTRAINT sales_customerid_timeid_isbn_pk PRIMARY KEY (customerid, timeid, isbn)
);

INSERT INTO sales_table (customerid, timeid, isbn, amnt)
  SELECT
    customer.customerid                     AS customerid,
    time.timeid                             AS timeid,
    book.isbn                               AS isbn,
    sum(order_detail.quantity * book.price) AS amnt
  FROM order_detail NATURAL JOIN book NATURAL JOIN cust_order NATURAL JOIN customer NATURAL JOIN time
  GROUP BY customer.customerid, time.timeid, book.isbn;

SELECT COUNT(*) FROM sales_table;

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
\echo Or we can calculate from the other direction. First with creating a materialized view which list the average spending by customer each day and using this avg and count to calculate our final daily avg spending.
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

CREATE MATERIALIZED VIEW best_buyers AS
  SELECT
    customer.CustomerId AS customer_id,
    customer.f_name     AS first_name,
    customer.l_name     AS last_name,
    sum(amnt)           AS spending
  FROM sales
    NATURAL JOIN customer
  GROUP BY customer.CustomerId
  ORDER BY spending DESC LIMIT 5;

SELECT * FROM best_buyers;

\echo
\echo b) Whether the customer who spent the greatest amount of money buying books did this by issuing many orders with smaller amounts or a few orders with greater amounts of money, or even great number of orders with greater amounts of money.
\echo

\echo
\echo Calculating ord_avg_amnt
\echo The average amount of money of all orders.
\echo

CREATE MATERIALIZED VIEW amount_per_order AS
  SELECT
    order_detail.orderid,
    sum(order_detail.quantity * book.price) AS order_amount
  FROM order_detail NATURAL JOIN book
  GROUP BY orderid;


CREATE MATERIALIZED VIEW ord_avg_amnt AS
  SELECT avg(amount_per_order.order_amount) AS ord_avg_amnt
  FROM amount_per_order;

SELECT * FROM ord_avg_amnt;

\echo
\echo Calculating no_of_ord
\echo The number of orders issued by the customer who spent the greatest amount of money buying books (the best buyer).
\echo

CREATE MATERIALIZED VIEW no_of_ord AS
  SELECT count(cust_order.orderid) AS no_of_ord FROM cust_order
  WHERE cust_order.customerid IN (SELECT customer_id FROM best_buyers LIMIT 1)
  GROUP BY cust_order.customerid;


SELECT * FROM no_of_ord;

\echo
\echo Calculating perc_of_ord
\echo The percentage of orders issued by the best buyer that had a greater total amount than the ord_avg_amnt.

CREATE MATERIALIZED VIEW amount_per_order_by_customer AS
  SELECT
    order_detail.orderid,
    sum(order_detail.quantity * book.price) AS order_amount
  FROM order_detail NATURAL JOIN book NATURAL JOIN cust_order NATURAL JOIN customer
  WHERE cust_order.customerid IN (SELECT customer_id FROM best_buyers LIMIT 1)
  GROUP BY orderid;

\echo
\echo List of orders by the customers with amount:
SELECT * FROM amount_per_order_by_customer;

\echo
\echo How many percentage above average:

CREATE MATERIALIZED VIEW perc_of_ord AS
  SELECT (count(*) * 100) :: NUMERIC / no_of_ord.no_of_ord AS perc_of_ord
  FROM amount_per_order_by_customer NATURAL JOIN ord_avg_amnt NATURAL JOIN no_of_ord
  WHERE amount_per_order_by_customer.order_amount > ord_avg_amnt.ord_avg_amnt
  GROUP BY no_of_ord.no_of_ord;

SELECT * FROM perc_of_ord;

\echo
\echo Conclusion:
\echo

SELECT perc_of_ord,
  CASE
    WHEN perc_of_ord >= 75
      THEN 'we estimate that the best buyer has issued a greater (than average) number of orders with greater (than average) amounts of money'
    WHEN perc_of_ord < 75 AND perc_of_ord >= 50
      THEN 'we estimate that the best buyer has issued a greater (than average) to medium number of orders with greater (than average) amounts of money'
    WHEN perc_of_ord < 50 AND perc_of_ord >= 25
      THEN 'we estimate that the best buyer has issued a small to medium number of orders with greater (than average) amounts of money'
    WHEN perc_of_ord < 25
      THEN 'we estimate that the best buyer has issued a small number of orders with greater (than average) amounts of money'
  END
FROM perc_of_ord;