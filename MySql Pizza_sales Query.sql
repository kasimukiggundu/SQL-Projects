-- below we are able to select our tables such that we can start the querying 
SELECT *
FROM pizza_sales.order_details;
SELECT *
FROM pizza_sales.orders;
SELECT *
FROM pizza_sales.pizza_types; 
SELECT *
FROM pizza_sales.pizzas;


-- Determining the highest priced pizza among all pizza types
SELECT ROUND(B.price, 2) AS highest_price, A.name, B.size, A.ingredients
FROM pizza_sales.pizza_types A
JOIN pizza_sales.pizzas B ON A.pizza_type_id = B.pizza_type_id
ORDER BY highest_price DESC
LIMIT 1;

-- Determining the least priced pizza among all pizza types
SELECT B.price AS lowest_price, A.name, B.size, A.ingredients
FROM pizza_sales.pizza_types A
JOIN pizza_sales.pizzas B ON A.pizza_type_id = B.pizza_type_id
ORDER BY B.price ASC
LIMIT 1;

-- Determining the average price for a pizza
SELECT AVG(price) AS Average_Price
FROM pizza_sales.pizzas;

-- Most sold pizza size
SELECT B.size, COUNT(*) AS total_sold
FROM pizza_sales.pizzas B
GROUP BY B.size
ORDER BY total_sold DESC;

-- Considering the time and date a pizza was ordered
SELECT O.date, O.time, P.name
FROM pizza_sales.order_details D
JOIN pizza_sales.orders O ON D.order_id = O.order_id
JOIN (
    SELECT B.price, A.name, B.size, A.ingredients, B.pizza_id
    FROM pizza_sales.pizza_types A
    JOIN pizza_sales.pizzas B ON A.pizza_type_id = B.pizza_type_id
) P ON P.pizza_id = D.pizza_id;

-- Finding out our peak hours with the most transactions
WITH Pizza_sale_period AS (
    SELECT O.date, O.time, P.name
    FROM pizza_sales.order_details D
    JOIN pizza_sales.orders O ON D.order_id = O.order_id
    JOIN (
        SELECT B.price, A.name, B.size, A.ingredients, B.pizza_id
        FROM pizza_sales.pizza_types A
        JOIN pizza_sales.pizzas B ON A.pizza_type_id = B.pizza_type_id
    ) P ON P.pizza_id = D.pizza_id
)
SELECT HOUR(time) AS hour, COUNT(*) AS total_transactions
FROM Pizza_sale_period
GROUP BY HOUR(time)
ORDER BY total_transactions DESC;

-- Calculating the total sales for the entire store
SELECT ROUND (SUM(P.price * O.quantity), 1) AS Total_sales
FROM pizza_sales.order_details O
JOIN pizza_sales.pizzas P ON O.pizza_id = P.pizza_id;

-- CALCULATING SALES FOR EACH PIZZA
WITH Product_sales AS (
    SELECT ROUND(SUM(P.price * O.quantity), 1) AS Total_sales, O.pizza_id
    FROM pizza_sales.order_details O
    JOIN pizza_sales.pizzas P ON O.pizza_id = P.pizza_id
    GROUP BY O.pizza_id
)
SELECT DISTINCT F.name, G.Total_sales
FROM Product_sales G
JOIN (
    SELECT O.date, O.time, P.name, P.pizza_id
    FROM pizza_sales.order_details D
    JOIN pizza_sales.orders O ON D.order_id = O.order_id
    JOIN (
        SELECT B.price, A.name, B.size, A.ingredients, B.pizza_id
        FROM pizza_sales.pizza_types A
        JOIN pizza_sales.pizzas B ON A.pizza_type_id = B.pizza_type_id
    ) P ON P.pizza_id = D.pizza_id
) F ON G.pizza_id = F.pizza_id
ORDER BY G.Total_sales DESC;


-- DETERMINING THE BEST SELLING PIZZA USING TOTAL SALES
WITH Product_sales AS (
    SELECT ROUND(SUM(P.price * O.quantity), 1) AS Total_sales, O.pizza_id
    FROM pizza_sales.order_details O
    JOIN pizza_sales.pizzas P ON O.pizza_id = P.pizza_id
    GROUP BY O.pizza_id
)
SELECT F.name, G.Total_sales
FROM Product_sales G
JOIN (
    SELECT O.date, O.time, P.name, P.pizza_id
    FROM pizza_sales.order_details D
    JOIN pizza_sales.orders O ON D.order_id = O.order_id
    JOIN (
        SELECT B.price, A.name, B.size, A.ingredients, B.pizza_id
        FROM pizza_sales.pizza_types A
        JOIN pizza_sales.pizzas B ON A.pizza_type_id = B.pizza_type_id
    ) P ON P.pizza_id = D.pizza_id
) F ON G.pizza_id = F.pizza_id
ORDER BY G.Total_sales DESC
LIMIT 1;


-- FINDING THE LEAST SELLING PIZZA
WITH Product_sales AS (
    SELECT ROUND(SUM(P.price * O.quantity), 1) AS Total_sales, O.pizza_id
    FROM pizza_sales.order_details O
    JOIN pizza_sales.pizzas P ON O.pizza_id = P.pizza_id
    GROUP BY O.pizza_id
)
SELECT F.name, G.Total_sales
FROM Product_sales G
JOIN (
    SELECT O.date, O.time, P.name, P.pizza_id
    FROM pizza_sales.order_details D
    JOIN pizza_sales.orders O ON D.order_id = O.order_id
    JOIN (
        SELECT B.price, A.name, B.size, A.ingredients, B.pizza_id
        FROM pizza_sales.pizza_types A
        JOIN pizza_sales.pizzas B ON A.pizza_type_id = B.pizza_type_id
    ) P ON P.pizza_id = D.pizza_id
) F ON G.pizza_id = F.pizza_id
ORDER BY G.Total_sales ASC
LIMIT 1;


-- DETERMINING THE MOST SELLING PIZZA CATEGORIES
WITH Product_sales AS (
    SELECT ROUND(SUM(P.price * O.quantity), 1) AS Total_sales, O.pizza_id
    FROM pizza_sales.order_details O
    JOIN pizza_sales.pizzas P ON O.pizza_id = P.pizza_id
    GROUP BY O.pizza_id
)
SELECT F.name, G.Total_sales, F.category
FROM Product_sales G
JOIN (
    SELECT O.date, O.time, P.name, P.pizza_id, P.category
    FROM pizza_sales.order_details D
    JOIN pizza_sales.orders O ON D.order_id = O.order_id
    JOIN (
        SELECT B.price, A.name, B.size, A.ingredients, A.category, B.pizza_id
        FROM pizza_sales.pizza_types A
        JOIN pizza_sales.pizzas B ON A.pizza_type_id = B.pizza_type_id
    ) P ON P.pizza_id = D.pizza_id
) F ON G.pizza_id = F.pizza_id
ORDER BY G.Total_sales DESC;


-- FINDING THE MONTH WITH THE MOST SALES IN THE YEAR OF 2015
WITH Product_sales AS (
    SELECT ROUND(SUM(P.price * O.quantity), 1) AS Total_sales, O.pizza_id, MONTH(q.date) AS Sales_month
    FROM pizza_sales.order_details O
    JOIN pizza_sales.pizzas P ON O.pizza_id = P.pizza_id
    JOIN pizza_sales.orders q ON O.order_details_id = q.order_id
    GROUP BY O.pizza_id, MONTH(q.date)
)
SELECT Sales_month, ROUND (SUM(Total_sales),1) AS Monthly_sales
FROM Product_sales
GROUP BY Sales_month
ORDER BY Monthly_sales asc
LIMIT 1;


-- FINDING THE DAY OF THE MONTH WITH THE HIGHEST SALES PERFORMANCE
WITH Product_sales AS (
    SELECT ROUND(SUM(P.price * O.quantity), 1) AS Total_sales, O.pizza_id,
           DAY(q.date) AS Sales_day, MONTH(q.date) AS Sales_month
    FROM pizza_sales.order_details O
    JOIN pizza_sales.pizzas P ON O.pizza_id = P.pizza_id
    JOIN pizza_sales.orders q ON O.order_id = q.order_id
    GROUP BY O.pizza_id, DAY(q.date), MONTH(q.date)
)
SELECT Sales_month, Sales_day, round (SUM(Total_sales),1) AS Daily_sales
FROM Product_sales
GROUP BY Sales_month, Sales_day
ORDER BY Daily_sales DESC;


-- FINDING THE BEST HOUR OF THE YEAR WITH THE HIGHEST TRANSACTIONS
WITH TransactionCounts AS (
    SELECT HOUR(q.time) AS TransactionHour, COUNT(*) AS TransactionCount
    FROM pizza_sales.order_details O
    JOIN pizza_sales.orders q ON O.order_id = q.order_id
    GROUP BY HOUR(q.time)
)
SELECT TransactionHour, TransactionCount
FROM TransactionCounts
ORDER BY TransactionCount DESC;


-- NUMBER OF TRANSACTIONS VS TOTAL SALES FOR EACH HOUR
WITH TransactionCounts AS (
    SELECT ROUND(SUM(P.price * O.quantity), 1) AS Total_sales,
           HOUR(q.time) AS TransactionHour, COUNT(*) AS TransactionCount
    FROM pizza_sales.pizzas P
    JOIN pizza_sales.order_details O ON O.pizza_id = P.pizza_id
    JOIN pizza_sales.orders q ON O.order_id = q.order_id
    GROUP BY HOUR(q.time)
)
SELECT TransactionHour, TransactionCount, Total_sales
FROM TransactionCounts
ORDER BY TransactionCount DESC;


-- FINDING THE HOUR AND DAY WITH THE MOST SALES THROUGHOUT THE YEAR
WITH TransactionCounts AS (
    SELECT HOUR(q.time) AS TransactionHour,
           DAY(q.date) AS TransactionDay,
           MONTH(q.date) AS TransactionMonth,
           YEAR(q.date) AS TransactionYear,
           ROUND(SUM(P.price * O.quantity), 1) AS Total_sales,
           COUNT(*) AS TransactionCount
    FROM pizza_sales.pizzas P
    JOIN pizza_sales.order_details O ON O.pizza_id = P.pizza_id
    JOIN pizza_sales.orders q ON O.order_id = q.order_id
    GROUP BY HOUR(q.time), DAY(q.date), MONTH(q.date), YEAR(q.date)
)
SELECT TransactionHour, TransactionDay, TransactionMonth, TransactionYear, TransactionCount, Total_sales
FROM TransactionCounts
ORDER BY TransactionCount DESC;


-- DETERMINING THE NUMBER OF SALES FOR EACH PIZZA SIZE AND CATEGORY
WITH salepersize AS (
    SELECT ROUND(SUM(P.price * O.quantity), 1) AS Total_sales, P.size, Q.category
    FROM pizza_sales.pizzas P
    JOIN pizza_sales.order_details O ON O.pizza_id = P.pizza_id
    JOIN pizza_sales.pizza_types Q ON P.pizza_type_id = Q.pizza_type_id
    GROUP BY P.size, Q.category
)
SELECT Total_sales, size, category
FROM salepersize
ORDER BY Total_sales DESC;


-- DISTRIBUTION OF TOTAL SALES ACROSS DIFFERENT PIZZA SIZES
WITH sizeVsSales AS (
    SELECT ROUND(SUM(P.price * O.quantity), 1) AS Total_sales, P.size, Q.category, Q.ingredients
    FROM pizza_sales.pizzas P
    JOIN pizza_sales.order_details O ON O.pizza_id = P.pizza_id
    JOIN pizza_sales.pizza_types Q ON P.pizza_type_id = Q.pizza_type_id
    GROUP BY P.size, Q.category, Q.ingredients
)
SELECT size, ROUND (SUM(Total_sales),1) AS Total_sales
FROM sizeVsSales
GROUP BY size;


-- FINDING THE INGREDIENT COMBINATIONS THAT GENERATE THE HIGHEST SALES
WITH sizeVsIngredients AS (
    SELECT ROUND (SUM(P.price * O.quantity), 1) AS Total_sales, P.size, Q.category, Q.ingredients
    FROM pizza_sales.pizzas P
    JOIN pizza_sales.order_details O ON O.pizza_id = P.pizza_id
    JOIN pizza_sales.pizza_types Q ON P.pizza_type_id = Q.pizza_type_id
    GROUP BY P.size, Q.category, Q.ingredients
)
SELECT ingredients, ROUND (SUM(Total_sales),1) AS Total_sales
FROM sizeVsIngredients
GROUP BY ingredients
ORDER BY Total_sales DESC;
