--we are going to start by writing select statements fro our tables 
--ORDER_DETAILS
SELECT *
FROM pizza_sales..order_details 

--ORDERS
SELECT *
FROM pizza_sales..orders 

--PIZZA_TYPES 
SELECT *
FROM pizza_sales..pizza_types 

--PIZZAS
SELECT *
FROM pizza_sales..pizzas 

--we are following with data manipulation amoung our tables including joins mmax min average count 

--determining the highest priced pizza amoung all pizza types 



SELECT TOP 1 ROUND(B.price, 2) AS highest_price, A.name, B.size, A.ingredients
FROM pizza_sales..pizza_types A
 JOIN pizza_sales..pizzas B ON A.pizza_type_id = B.pizza_type_id
GROUP BY A.name, B.size, A.ingredients, B.price 
ORDER BY highest_price desc



SELECT TOP 1 B.price AS highest_price, A.name, B.size, A.ingredients
FROM pizza_sales..pizza_types A 
JOIN pizza_sales..pizzas B ON A.pizza_type_id = B.pizza_type_id
ORDER BY B.price DESC

--determining the LEAST priced pizza amoung all pizza types 
SELECT TOP 1 B.price AS lowest_price, A.name, B.size, A.ingredients
FROM pizza_sales..pizza_types A
JOIN pizza_sales..pizzas B ON A.pizza_type_id = B.pizza_type_id
ORDER BY B.price ASC

--determining the average price for a pizza
SELECT AVG(price ) Average_Price
FROM  pizza_sales..pizzas 

--MOST SOLD PIZZA SIZE 
SELECT B.size, COUNT(*) AS total_sold
FROM pizza_sales..pizzas B
GROUP BY B.size
ORDER BY total_sold DESC

--considering time  and date a pizza was ordered 

SELECT O.date, O.time, P.name 
FROM pizza_sales..order_details D
JOIN pizza_sales..orders O ON D.order_id = O.order_id
JOIN (SELECT B.price, A.name, B.size, A.ingredients, B.pizza_id 
FROM pizza_sales..pizza_types A
 JOIN pizza_sales..pizzas B ON A.pizza_type_id = B.pizza_type_id) P ON P.pizza_id = D.pizza_id 

 --finding out our peak Hours with the most transactions  

 WITH Pizza_sale_period AS (SELECT O.date, O.time, P.name 
FROM pizza_sales..order_details D
JOIN pizza_sales..orders O ON D.order_id = O.order_id
JOIN (SELECT B.price, A.name, B.size, A.ingredients, B.pizza_id 
FROM pizza_sales..pizza_types A
 JOIN pizza_sales..pizzas B ON A.pizza_type_id = B.pizza_type_id) P ON P.pizza_id = D.pizza_id )

SELECT DATEPART(HOUR, time ) AS hour, COUNT(*) AS total_transactions
FROM Pizza_sale_period
GROUP BY DATEPART(HOUR, time )
ORDER BY total_transactions  DESC


--calculating the total sales for the ENTIRE  store 

SELECT SUM(P.price * O.quantity) Total_sales
FROM pizza_sales..order_details O
JOIN pizza_sales..pizzas P ON O.pizza_id = P.pizza_id 

--CALCULATING SALES FOR EACH PIZZA 

WITH Product_sales AS (
SELECT ROUND (SUM(P.price * O.quantity),1) Total_sales, O.pizza_id 
FROM pizza_sales..order_details O
JOIN pizza_sales..pizzas P ON O.pizza_id = P.pizza_id
GROUP BY O.pizza_id
)

SELECT DISTINCT F.name, G.Total_sales 
FROM Product_sales G
JOIN (SELECT O.date, O.time, P.name, P.pizza_id  
FROM pizza_sales..order_details D
JOIN pizza_sales..orders O ON D.order_id = O.order_id
JOIN (SELECT B.price, A.name, B.size, A.ingredients, B.pizza_id 
FROM pizza_sales..pizza_types A
 JOIN pizza_sales..pizzas B ON A.pizza_type_id = B.pizza_type_id) P ON P.pizza_id = D.pizza_id ) F
 ON G.pizza_id = F.pizza_id 
ORDER BY G.Total_sales  DESC


--WE HAVE  TO DETERMINE THE BEST SELLER PIZZA USING THE TOTAL SALES

WITH Product_sales AS (
    SELECT ROUND(SUM(P.price * O.quantity), 1) AS Total_sales, O.pizza_id
    FROM pizza_sales..order_details O
    JOIN pizza_sales..pizzas P ON O.pizza_id = P.pizza_id
    GROUP BY O.pizza_id
)

    SELECT TOP 1 F.name, G.Total_sales
    FROM Product_sales G
    JOIN (
        SELECT O.date, O.time, P.name, P.pizza_id
        FROM pizza_sales..order_details D
        JOIN pizza_sales..orders O ON D.order_id = O.order_id
        JOIN (
            SELECT B.price, A.name, B.size, A.ingredients, B.pizza_id
            FROM pizza_sales..pizza_types A
            JOIN pizza_sales..pizzas B ON A.pizza_type_id = B.pizza_type_id
        ) P ON P.pizza_id = D.pizza_id
    ) F ON G.pizza_id = F.pizza_id
    ORDER BY G.Total_sales DESC




--we finding the least selling pizza 

WITH Product_sales AS (
    SELECT ROUND(SUM(P.price * O.quantity), 1) AS Total_sales, O.pizza_id
    FROM pizza_sales..order_details O
    JOIN pizza_sales..pizzas P ON O.pizza_id = P.pizza_id
    GROUP BY O.pizza_id
)

    SELECT TOP 1 F.name, G.Total_sales
    FROM Product_sales G
    JOIN (
        SELECT O.date, O.time, P.name, P.pizza_id
        FROM pizza_sales..order_details D
        JOIN pizza_sales..orders O ON D.order_id = O.order_id
        JOIN (
            SELECT B.price, A.name, B.size, A.ingredients, B.pizza_id
            FROM pizza_sales..pizza_types A
            JOIN pizza_sales..pizzas B ON A.pizza_type_id = B.pizza_type_id
        ) P ON P.pizza_id = D.pizza_id
    ) F ON G.pizza_id = F.pizza_id
    ORDER BY G.Total_sales ASC

	--LETS FIND UT TH DIFFERENT PIZZA CATEGORIES WITH THE MOST SALES 
	--so with the query below we determine that the most selling pizza flavour is chicken followed by the veggie flaavour 

	WITH Product_sales AS (
    SELECT ROUND(SUM(P.price * O.quantity), 1) AS Total_sales, O.pizza_id
    FROM pizza_sales..order_details O
    JOIN pizza_sales..pizzas P ON O.pizza_id = P.pizza_id
    GROUP BY O.pizza_id
)

    SELECT DISTINCT  F.name, G.Total_sales, F.category 
    FROM Product_sales G
    JOIN (
        SELECT O.date, O.time, P.name, P.pizza_id, P.category 
        FROM pizza_sales..order_details D
        JOIN pizza_sales..orders O ON D.order_id = O.order_id
        JOIN (
            SELECT B.price, A.name, B.size, A.ingredients, A.category, B.pizza_id
            FROM pizza_sales..pizza_types A
            JOIN pizza_sales..pizzas B ON A.pizza_type_id = B.pizza_type_id
        ) P ON P.pizza_id = D.pizza_id
    ) F ON G.pizza_id = F.pizza_id
    ORDER BY G.Total_sales DESC

	--LETS FIND OUT THE ONTH THAT WE HD MOST SALES IN THE YEAR OF 2015

	WITH Product_sales AS (
    SELECT ROUND(SUM(P.price * O.quantity), 1) AS Total_sales, O.pizza_id, MONTH(q.date) AS Sales_month
    FROM pizza_sales..order_details O
    JOIN pizza_sales..pizzas P ON O.pizza_id = P.pizza_id
	JOIN pizza_sales..orders q ON O.order_details_id = q.order_id 
    GROUP BY O.pizza_id, MONTH(q.date)
)
SELECT TOP 1 Sales_month, SUM(Total_sales) AS Monthly_sales
FROM Product_sales
GROUP BY Sales_month
ORDER BY Monthly_sales DESC
--LIMIT 1;

--BELOW WE UNDERSTAND WHICH DAY OF THE MONTH HAD THE HIGHEST PERFOMANCE 
WITH Product_sales AS (
    SELECT ROUND(SUM(P.price * O.quantity), 1) AS Total_sales, O.pizza_id, 
           DATEPART(DAY, q.date) AS Sales_day, MONTH(q.date) AS Sales_month
    FROM pizza_sales..order_details O
    JOIN pizza_sales..pizzas P ON O.pizza_id = P.pizza_id
    JOIN pizza_sales..orders q ON O.order_id = q.order_id
    GROUP BY O.pizza_id, DATEPART(DAY, q.date), MONTH(q.date)
)
SELECT  Sales_month, Sales_day, SUM(Total_sales) AS Daily_sales
FROM Product_sales
GROUP BY Sales_month, Sales_day
ORDER BY Daily_sales DESC;

--WE HAVE DETERMINED THE OUR BEST HOUR OF THE YEAR  WIH THe  QUERY  below with the highest transactions 
WITH TransactionCounts AS (
    SELECT  DATEPART(HOUR, q.time) AS TransactionHour, COUNT(*) AS TransactionCount
    FROM pizza_sales..order_details O
    JOIN pizza_sales..orders q ON O.order_id = q.order_id
    GROUP BY DATEPART(HOUR, q.time)
)
SELECT TransactionHour, TransactionCount
FROM TransactionCounts
ORDER BY TransactionCount DESC;



--number of transactions VS Total sales of the hour making our best hourly sales 


WITH TransactionCounts AS (
    SELECT  
	ROUND(SUM(P.price * O.quantity), 1) AS Total_sales,
	DATEPART(HOUR, q.time) AS TransactionHour, COUNT(*) AS TransactionCount
    FROM pizza_sales..pizzas P
	JOIN pizza_sales..order_details O ON O.pizza_id = P.pizza_id
    JOIN pizza_sales..orders q ON O.order_id = q.order_id
    GROUP BY DATEPART(HOUR, q.time)
)
SELECT TransactionHour, TransactionCount, Total_sales 
FROM TransactionCounts
ORDER BY TransactionCount DESC;

--we are going to try and find out whether we can determine which hour and day throughout the year has more sales 

WITH TransactionCounts AS (
    SELECT 
        DATEPART(HOUR, q.time) AS TransactionHour,
        DATEPART(DAY, q.date) AS TransactionDay,
        DATEPART(MONTH, q.date) AS TransactionMonth,
        DATEPART(YEAR, q.date) AS TransactionYear,
        ROUND(SUM(P.price * O.quantity), 1) AS Total_sales,
        COUNT(*) AS TransactionCount
    FROM pizza_sales..pizzas P
    JOIN pizza_sales..order_details O ON O.pizza_id = P.pizza_id
    JOIN pizza_sales..orders q ON O.order_id = q.order_id
    GROUP BY DATEPART(HOUR, q.time), DATEPART(DAY, q.date), DATEPART(MONTH, q.date), DATEPART(YEAR, q.date)
)
SELECT TransactionHour, TransactionDay, TransactionMonth, TransactionYear, TransactionCount, Total_sales
FROM TransactionCounts
ORDER BY TransactionCount DESC;


--we are going to determine the number of sales depending on the size and of the pizza and pizza category
WITH salepersize AS (
    SELECT  
	ROUND(SUM(P.price * O.quantity), 1) AS Total_sales, P.size, Q.category 
    FROM pizza_sales..pizzas P
	JOIN pizza_sales..order_details O ON O.pizza_id = P.pizza_id
    JOIN pizza_sales..pizza_types Q ON P.pizza_type_id = Q.pizza_type_id 
    GROUP BY p.size, Q.category
)

SELECT Total_sales, size, category
FROM salepersize 

ORDER BY Total_sales DESC


--What is the distribution of total sales across different sizes?
WITH sizeVsSales AS (
    SELECT  
	ROUND(SUM(P.price * O.quantity), 1) AS Total_sales, P.size, Q.category, Q.ingredients  
    FROM pizza_sales..pizzas P
	JOIN pizza_sales..order_details O ON O.pizza_id = P.pizza_id
    JOIN pizza_sales..pizza_types Q ON P.pizza_type_id = Q.pizza_type_id 
    GROUP BY p.size, Q.category, Q.ingredients 
)
SELECT size, SUM(Total_sales) AS Total_sales
FROM sizeVsSales 
GROUP BY size;


--NOW HERE WE TO FIND OUT THE TYPE OF INGRIDIENTS IN OUR PIZZA Vs THE SALES AND SIZE 
--Which ingredient combinations generate the highest sales?

WITH sizeVsingridients AS (
    SELECT  
	ROUND(SUM(P.price * O.quantity), 1) AS Total_sales, P.size, Q.category, Q.ingredients  
    FROM pizza_sales..pizzas P
	JOIN pizza_sales..order_details O ON O.pizza_id = P.pizza_id
    JOIN pizza_sales..pizza_types Q ON P.pizza_type_id = Q.pizza_type_id 
    GROUP BY p.size, Q.category, Q.ingredients 
)

SELECT ingredients, SUM(Total_sales) AS Total_sales
FROM sizeVsingridients
GROUP BY ingredients
ORDER BY Total_sales DESC;
