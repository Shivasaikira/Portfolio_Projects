# Apple Store Analysis Project

## Overview
The Apple Store Analysis project involves analyzing Apple Store sales, product performance, and warranty claims data to derive actionable business insights. This project showcases advanced SQL querying techniques through the analysis of over 1 million rows of Apple retail sales data. The dataset includes detailed information about products, store performance, sales transactions, and warranty claims from Apple retail locations worldwide. The project was completed using SQL to answer a series of business questions by solving complex queries. These queries aim to extract valuable insights, such as identifying top-performing products and stores, uncovering seasonal sales trends, and analyzing the relationship between product pricing and warranty claims. The goal is to demonstrate proficiency in crafting sophisticated SQL queries to derive actionable insights from large-scale datasets and gain a deeper understanding of retail business operations. 
## Entity Relationship Diagram (ERD)

![ERD](https://github.com/najirh/Apple-Retail-Sales-SQL-Project---Analyzing-Millions-of-Sales-Rows/blob/main/erd.png)


## Database Schema

The database consists of the following five main tables:

### 1. `stores` table:
| Column Name   | Data Type | Description |
|---------------|-----------|-------------|
| store_id      | INT       | Unique identifier for each store |
| store_name    | VARCHAR   | Name of the store |
| city          | VARCHAR   | City where the store is located |
| country       | VARCHAR   | Country of the store |

### 2. `category` table:
| Column Name   | Data Type | Description |
|---------------|-----------|-------------|
| category_id   | INT       | Unique identifier for each product category |
| category_name | VARCHAR   | Name of the product category |

### 3. `products` table:
| Column Name   | Data Type | Description |
|---------------|-----------|-------------|
| product_id    | INT       | Unique identifier for each product |
| product_name  | VARCHAR   | Name of the product |
| category_id   | INT       | References the category table |
| launch_date   | DATE      | Date when the product was launched |
| price         | DECIMAL   | Price of the product |

### 4. `sales` table:
| Column Name   | Data Type | Description |
|---------------|-----------|-------------|
| sale_id       | INT       | Unique identifier for each sale |
| sale_date     | DATE      | Date of the sale |
| store_id      | INT       | References the store table |
| product_id    | INT       | References the product table |
| quantity      | INT       | Number of units sold |

### 5. `warranty` table:
| Column Name   | Data Type | Description |
|---------------|-----------|-------------|
| claim_id      | INT       | Unique identifier for each warranty claim |
| claim_date    | DATE      | Date the claim was made |
| sale_id       | INT       | References the sales table |
| repair_status | VARCHAR   | Status of the warranty claim (e.g., Paid Repaired, Warranty Void) |

## Key Features

### 1. SQL Skills Demonstrated
- **Complex Joins and Aggregations**: Multiple tables are joined to extract valuable business insights.
- **Window Functions**: Advanced SQL techniques like running totals, time-based analysis, and rankings.
- **Data Segmentation**: Sales data is analyzed across different time periods, geographies, and product categories.
- **Correlation Analysis**: Investigating relationships such as between product price and warranty claims.

### 2. Real-World Business Questions Answered
- Total units sold by each store.
- Monthly and yearly sales trends.
- Stores with no warranty claims.
- Seasonal sales analysis (e.g., December trends).
- Products with the most/least warranty claims.
- Correlation between product price segments and warranty claims.

### 3. Dataset Details
- **Size**: Over 1 million rows of sales data.
- **Period Covered**: Data spans multiple years, enabling long-term trend analysis.
- **Geographical Coverage**: Sales data from Apple stores worldwide.

## Project Highlights
- **Visualization Ready**: The analysis results are formatted for easy integration with data visualization tools like Tableau or Power BI.
- **Efficiency**: Queries are optimized using indexes and partitioning techniques for faster processing.

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1.  **What is the total number of units sold by each store?**:
```sql
SELECT 
    st.store_name, s.store_id, COUNT(quantity) AS total_sales
FROM
    stores st
        JOIN
    sales s ON st.store_id = s.store_id
GROUP BY s.store_id , st.store_name
ORDER BY total_sales DESC;
```
**Answer:**
`![image](Apple-Store-Sales-SQL-Project/Output/Picture1.png)`

2.  **How many stores have never had a warranty claim filed against any of their products?**:
 ```sql
SELECT COUNT(*) AS total_stores
 FROM stores
WHERE store_id NOT IN ( SELECT DISTINCT store_id
	FROM sales as s
	RIGHT JOIN warranty as w
	ON s.sale_id = w.sale_id
	);
```
3. **Which store had the highest total units sold in the last year?**
 ```sql
SELECT 
    s.store_id,
    st.store_name,
    SUM(s.quantity) AS total_units_sold
FROM sales s
 JOIN stores st ON s.store_id = st.store_id
WHERE sale_date >= DATE_SUB(NOW(), INTERVAL 1 YEAR)
GROUP BY 1 , 2
ORDER BY 3 DESC
LIMIT 1;
```
4. **Count the number of unique products sold in the last year.**
 ```sql
SELECT 
    COUNT(DISTINCT product_id) AS num_unique_products
FROM sales
WHERE sale_date >= DATE_SUB(NOW(), INTERVAL 1 YEAR);
```
5. **Identify each store and best-selling day based on highest quantity sold.**
 ```sql
SELECT 
    store_id,
    sale_date AS best_selling_day,
    MAX(quantity) AS highest_qty_sold
FROM sales
GROUP BY store_id , sale_date
ORDER BY highest_qty_sold DESC;
```
6. **Identify the least-selling product of each country for each year based on total units sold.**
 ```sql
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
```
7. **How many warranty claims have been filed for products launched in the last two years?**
 ```sql
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
```
8. **List the months in the last 3 years where sales exceeded 5000 units from the USA.**
 ```sql
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
```
9. **Write SQL query to calculate the monthly running total of sales for each store over the past four years and compare the trends across this period.**
 ```sql
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
```
10. **What is the correlation between product price and warranty claims for products sold in the last five years?**
 ```sql
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
```


## Conclusion
This project demonstrates advanced SQL skills through practical business analysis of Apple Store data. By addressing real-world business questions, the insights derived can help Apple optimize its store operations, product performance, and warranty services on a global scale.

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

