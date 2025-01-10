create database apple_store;
use apple_store;

CREATE TABLE stores(
store_id VARCHAR(5) PRIMARY KEY,
store_name VARCHAR(30),
city      VARCHAR(25),
country VARCHAR(25)
);

CREATE TABLE category
(category_id VARCHAR(10) PRIMARY KEY,
category_name VARCHAR(20)
);

CREATE TABLE products
(
product_id	VARCHAR(10) PRIMARY KEY,
product_name	VARCHAR(35),
category_id	VARCHAR(10),
launch_date	date,
price FLOAT,
CONSTRAINT fk_category FOREIGN KEY (category_id) REFERENCES category(category_id)
);

CREATE TABLE sales
(
sale_id	VARCHAR(15) PRIMARY KEY,
sale_date	DATE,
store_id	VARCHAR(10), -- this fk
product_id	VARCHAR(10), -- this fk
quantity INT,
CONSTRAINT fk_store FOREIGN KEY (store_id) REFERENCES stores(store_id),
CONSTRAINT fk_product FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE warranty
(
claim_id VARCHAR(10) PRIMARY KEY,	
claim_date	date,
sale_id	VARCHAR(15),
repair_status VARCHAR(15),
CONSTRAINT fk_orders FOREIGN KEY (sale_id) REFERENCES sales(sale_id)
);

Load data infile 'salesoriginal.csv' into table sales
fields terminated by','
ignore 1 lines;
SELECT 
    COUNT(*)
FROM
    warranty;
SET foreign_key_checks = 1;
truncate warranty;
Load data infile 'warranty.csv' into table warranty
fields terminated by','
ignore 1 lines;

select * from sales;
select * from category;
select * from stores;
select * from warranty;
select * from products;


CREATE INDEX sales_product_id ON sales(product_id);
CREATE INDEX sales_store_id ON sales(store_id);
CREATE INDEX sales_sale_date ON sales(sale_date);


-- 1. What is the total number of units sold by each store?
SELECT 
    st.store_name, s.store_id, COUNT(quantity) AS total_sales
FROM
    stores st
        JOIN
    sales s ON st.store_id = s.store_id
GROUP BY s.store_id , st.store_name
ORDER BY total_sales DESC;


-- 2. How many stores have never had a warranty claim filed against any of their products?
 
SELECT COUNT(*) AS total_stores
 FROM stores
WHERE store_id NOT IN (
						SELECT 
							DISTINCT store_id
						FROM sales as s
						RIGHT JOIN warranty as w
						ON s.sale_id = w.sale_id
						);

-- 3. Which store had the highest total units sold in the last year?
SELECT 
    s.store_id,
    st.store_name,
    SUM(s.quantity) AS total_units_sold
FROM
    sales s
        JOIN
    stores st ON s.store_id = st.store_id
WHERE
    sale_date >= DATE_SUB(NOW(), INTERVAL 1 YEAR)
GROUP BY 1 , 2
ORDER BY 3 DESC
LIMIT 1;

-- 4.Count the number of unique products sold in the last year. 

SELECT 
    COUNT(DISTINCT product_id) AS num_unique_products
FROM
    sales
WHERE
    sale_date >= DATE_SUB(NOW(), INTERVAL 1 YEAR);

 
-- 5. Identify each store and best selling day based on highest qty sold

SELECT 
    store_id,
    sale_date AS best_selling_day,
    MAX(quantity) AS highest_qty_sold
FROM
    sales
GROUP BY store_id , sale_date
ORDER BY highest_qty_sold DESC;


-- 6. Identify least selling product of each country for each year based on total unit sold
WITH product_rank AS (
    SELECT 
        st.country,
        p.product_name,
        SUM(s.quantity) as total_qty_sold,
        RANK() OVER (PARTITION BY st.country ORDER BY SUM(s.quantity)) as rnk
    FROM sales s
    JOIN stores st ON s.store_id = st.store_id
    JOIN products p ON s.product_id = p.product_id
    GROUP BY st.country, p.product_name
)
SELECT 
    country,
    product_name,
    total_qty_sold
FROM product_rank
WHERE rnk = 1;
 select * from sales;
select * from category;
select * from stores;
select * from warranty;
select * from products;
 

-- 7. How many warranty claims have been filed for products launched in the last two years?
 
SELECT 
	p.product_name,
	COUNT(w.claim_id) as no_claim,
	COUNT(s.sale_id)
FROM warranty as w
RIGHT JOIN
sales as s 
ON s.sale_id = w.sale_id
JOIN products as p
ON p.product_id = s.product_id
WHERE p.launch_date >= DATE_SUB(NOW(),INTERVAL 2 YEAR)
GROUP BY 1
HAVING COUNT(w.claim_id) > 0;

-- 8. List the months in the last 3 years where sales exceeded 5000 units from usa.
 
 SELECT 
	month(sale_date) as month,
	SUM(s.quantity) as total_unit_sold
FROM sales as s
JOIN 
stores as st
ON s.store_id = st.store_id
WHERE 
	st.country = 'USA'
	AND
	s.sale_date >=DATE_SUB(NOW(),INTERVAL 3 YEAR)
GROUP BY 1
HAVING SUM(s.quantity) > 5000;

-- 9. Write a query to calculate the monthly running total of sales for each store
-- over the past four years and compare trends during this period.
 
 WITH monthly_sales
AS
(SELECT 
	store_id,
	EXTRACT(YEAR FROM sale_date) as year,
	EXTRACT(MONTH FROM sale_date) as month,
	SUM(p.price * s.quantity) as total_revenue
FROM sales as s
JOIN 
products as p
ON s.product_id = p.product_id
GROUP BY 1, 2, 3
ORDER BY 1, 2,3
)
SELECT 
	store_id,
	month,
	year,
	total_revenue,
	SUM(total_revenue) OVER(PARTITION BY store_id ORDER BY year, month) as running_total
FROM monthly_sales;

-- Q.10 Calculate the correlation between product price and warranty claims for 
-- products sold in the last five years, segmented by price range.

SELECT 
	
	CASE
		WHEN p.price < 500 THEN 'Less Expenses Product'
		WHEN p.price BETWEEN 500 AND 1000 THEN 'Mid Range Product'
		ELSE 'Expensive Product'
	END as price_segment,
	COUNT(w.claim_id) as total_Claim
FROM warranty as w
LEFT JOIN
sales as s
ON w.sale_id = s.sale_id
JOIN 
products as p
ON p.product_id = s.product_id
WHERE claim_date >=  DATE_SUB(NOW(),INTERVAL 5 YEAR)
GROUP BY 1
