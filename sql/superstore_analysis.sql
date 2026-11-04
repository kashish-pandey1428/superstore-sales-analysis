SHOW VARIABLES LIKE 'local_infile';

USE superstore_db;

LOAD DATA LOCAL INFILE
'C:/Users/kashish/OneDrive/Desktop/Sales-performance-analysis/data/Superstore_Cleaned.csv'
INTO TABLE superstore_sales
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT COUNT(*) AS total_records
FROM superstore_sales;

USE superstore_db;

TRUNCATE TABLE superstore_sales;

USE superstore_db;

LOAD DATA LOCAL INFILE
'C:/Users/kashish/OneDrive/Desktop/Sales-performance-analysis/data/Superstore_Cleaned.csv'
INTO TABLE superstore_sales
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT COUNT(*) AS total_records
FROM superstore_sales;

SELECT *
FROM superstore_sales
LIMIT 10;

-- What is the overall business performance?

SELECT
COUNT(DISTINCT `Order ID`) AS total_orders,
COUNT(DISTINCT `Customer ID`) AS total_customers,
ROUND(SUM(Sales), 2) AS total_sales,
ROUND(SUM(Profit), 2) AS total_profit,
ROUND(AVG(Sales), 2) AS avg_sales_per_record
FROM superstore_sales;

-- Which product category generates the highest sales and profit?
SELECT
Category,
ROUND(SUM(Sales), 2) AS total_sales,
ROUND(SUM(Profit), 2) AS total_profit
FROM superstore_sales
GROUP BY Category
ORDER BY total_sales DESC, total_profit DESC;

-- Regional Performance Analysis
SELECT
    Region,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit
FROM superstore_sales
GROUP BY Region
ORDER BY total_sales DESC, total_profit DESC;

-- Which customer segment (Consumer, Corporate, Home Office) generates the highest sales and profit?
select
segment, 
round(sum(Sales), 2) as total_sales, 
round(sum(Profit), 2) as total_profit
from superstore_sales
group by segment 
order by total_sales desc , total_profit desc;

-- Which subcategories generate the highest sales and profit, and which ones are making losses?
SELECT
`Sub-Category`,
ROUND(SUM(Sales), 2) AS total_sales,
ROUND(SUM(Profit), 2) AS total_profit
FROM superstore_sales
GROUP BY 1
ORDER BY 2 DESC;

-- Which shipping mode receives the most orders and generates the highest sales and profit?
SELECT
`Ship Mode`,
COUNT(DISTINCT `Order ID`) AS total_orders,
ROUND(SUM(Sales), 2) AS total_sales,
ROUND(SUM(Profit), 2) AS total_profit
FROM superstore_sales
GROUP BY `Ship Mode`
ORDER BY total_sales DESC;

-- Which customer segment has the highest average order value (AOV)?
SELECT
Segment,
COUNT(DISTINCT `Order ID`) AS total_orders,
ROUND(SUM(Sales), 2) AS total_sales,
ROUND(
SUM(Sales) / COUNT(DISTINCT `Order ID`), 2
) AS average_order_value
FROM superstore_sales
GROUP BY Segment
ORDER BY average_order_value DESC;

-- Which 10 customers have generated the highest total sales for the business?
SELECT
`Customer ID`,
COUNT(DISTINCT `Order ID`) AS total_orders,
ROUND(SUM(Sales), 2) AS total_sales,
ROUND(SUM(Profit), 2) AS total_profit
FROM superstore_sales
GROUP BY `Customer ID`
ORDER BY total_sales DESC
LIMIT 10;

-- Which 10 products generate the highest total sales?
SELECT
`Product Name`,
`Category`,
`Sub-Category`,
ROUND(SUM(Sales), 2) AS total_sales,
ROUND(SUM(Profit), 2) AS total_profit
FROM superstore_sales
GROUP BY
`Product Name`,
`Category`,
`Sub-Category`
ORDER BY total_sales DESC
LIMIT 10;

-- Which months generate the highest sales and profit, and how does business performance change throughout the year?
SELECT
    MONTHNAME(`Order Date`) AS order_month,
    MONTH(`Order Date`) AS month_number,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit
FROM superstore_sales
GROUP BY
    MONTH(`Order Date`),
    MONTHNAME(`Order Date`)
ORDER BY month_number;

-- How do sales and profit compare across different years?
SELECT
`Year`,
COUNT(DISTINCT `Order ID`) AS total_orders,
ROUND(SUM(Sales), 2) AS total_sales,
ROUND(SUM(Profit), 2) AS total_profit
FROM superstore_sales
GROUP BY `Year`
ORDER BY `Year`;

-- Which product category has the highest profit margin?
SELECT
Category,
ROUND(SUM(Sales), 2) AS total_sales,
ROUND(SUM(Profit), 2) AS total_profit,
ROUND((SUM(Profit) / SUM(Sales)) * 100, 2) AS profit_margin_percentage
FROM superstore_sales
GROUP BY Category
ORDER BY profit_margin_percentage DESC;

-- Which product subcategories are generating losses?
SELECT
`Sub-Category`,
ROUND(SUM(Sales), 2) AS total_sales,
ROUND(SUM(Profit), 2) AS total_profit
FROM superstore_sales
GROUP BY `Sub-Category`
HAVING SUM(Profit) < 0
ORDER BY total_profit ASC;

-- How do different discount levels affect sales and profitability?
SELECT
Discount,
COUNT(*) AS total_records,
ROUND(SUM(Sales), 2) AS total_sales,
ROUND(SUM(Profit), 2) AS total_profit,
ROUND(AVG(Profit), 2) AS average_profit
FROM superstore_sales
GROUP BY Discount
ORDER BY Discount;

-- Which 10 states generate the highest sales and how profitable are they?
SELECT
State,
COUNT(DISTINCT `Order ID`) AS total_orders,
ROUND(SUM(Sales), 2) AS total_sales,
ROUND(SUM(Profit), 2) AS total_profit
FROM superstore_sales
GROUP BY State
ORDER BY total_sales DESC
LIMIT 10;