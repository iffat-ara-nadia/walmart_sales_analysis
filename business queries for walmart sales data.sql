USE walmart;

# # There is a minor problem with MySQL: in the table 'walmart_sales_analysis', there are two column names ('Branch' and 'City') that are written in capital letters. We can change the column names to all lowercase letters and then export the table back.
# We just need to convert all the column names in lower case.

-- DROP TABLE IF EXISTS walmart_sales_analysis;

               -- EXPLORATORY DATA ANALYSIS (EDA) with SQL ----
               -- ------------------------------------------------

SELECT *
FROM walmart_sales_analysis;

SELECT 
	COUNT(*) AS total_transactions
FROM walmart_sales_analysis;

SELECT
	MAX(quantity) AS max_quantity,
    MIN(quantity) AS min_quantity
FROM walmart_sales_analysis;

				 -- BUSINESS ANALYSIS -----
				-- -----------------------
                
-- Q.1 Find different payment methods and number of tansactions, number of qty sold
-- Calculate the total quantity of items sold per payment method. List payment_method and total_quality.
SELECT
	DISTINCT(payment_method),
    COUNT(*) AS number_of_transactions,
	SUM(quantity) AS qty_sold            -- WRONG OUTPUT 4256	4256 for: COUNT(*) AS number_of_transactions, COUNT(quantity) AS qty_sold  
FROM walmart_sales_analysis
GROUP BY payment_method
ORDER BY number_of_transactions DESC;

-- Q.2 Identify the highest-rated category in each branch, displaying the branch, category and Avg Rating

CREATE VIEW branch_rank AS
SELECT
	branch,
	category,
    AVG(rating) AS avg_rating,
    RANK() OVER(PARTITION BY branch ORDER BY AVG(rating) DESC) AS rn
FROM walmart_sales_analysis
GROUP BY branch, category;
-- ORDER BY branch, avg_rating DESC;  # When we use RANK(), WE don't need to USE order by clause seperately, because this clause is used inside RANK()
    
SELECT * 
FROM branch_rank
WHERE rn = 1;

-- Q.3 Identify the busiest date for each branch based on the number of transactions.

CREATE OR REPLACE VIEW busiest_day AS
SELECT
    branch,
	DAYNAME(date) AS day_name,
    COUNT(*) AS num_of_transactions,
    RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) AS rn
FROM walmart_sales_analysis
GROUP BY branch, day_name;
-- ORDER BY branch, num_of_transactions DESC;

SELECT *
FROM busiest_day
WHERE rn = 1;


-- Q.4 or 5 Determine the average, minimum, and maximum rating of category for each city. 
--          List the city, category, average_rating, min_rating, and max_rating.

SELECT
	city,
    category,
    AVG(rating) AS average_rating,
    MIN(rating) AS min_rating,
    MAX(rating) AS max_rating
FROM walmart_sales_analysis
GROUP BY city, category;

-- Q.6 Calculate the total profit for each category by considering total_profit as (unit_price * quantity * profit_margin). List category and 
-- total_revenue, total_profit, ordered from highest to lowest profit.

SELECT
	category,
    SUM(net_price) AS total_revenue,
    SUM(net_price * profit_margin) AS total_profit
FROM walmart_sales_analysis
GROUP BY category
ORDER BY total_profit DESC;

-- Q.7
-- Determine the most common payment method for each Branch. Display Branch and the preferred_payment_method.

CREATE OR REPLACE VIEW payment_method_frequency AS -- wrong: ';' after AS 
SELECT
    branch,
	payment_method,
    COUNT(*) AS payment_frequency,
    RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) AS rn
FROM walmart_sales_analysis
GROUP BY branch, payment_method;

SELECT 
	branch,
	payment_method AS most_common_payment_method,
	payment_frequency
FROM payment_method_frequency
WHERE rn = 1;

	
-- Q.8
-- Categorize sales into 3 groups MORNING, AFTERNOON, EVENING
-- Find out each of the shift and number of invoices across branches.

SELECT
	











