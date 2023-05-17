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



SELECT TOP 1 MAX(B.price) highest_price, A.name, B.size, A.ingredients
FROM pizza_sales..pizza_types A
 JOIN pizza_sales..pizzas B ON A.pizza_type_id = B.pizza_type_id
GROUP BY A.name, B.size, A.ingredients
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

 --finding out our peak Hours with the most sales and total number of sales 

 WITH Pizza_sale_period AS (SELECT O.date, O.time, P.name 
FROM pizza_sales..order_details D
JOIN pizza_sales..orders O ON D.order_id = O.order_id
JOIN (SELECT B.price, A.name, B.size, A.ingredients, B.pizza_id 
FROM pizza_sales..pizza_types A
 JOIN pizza_sales..pizzas B ON A.pizza_type_id = B.pizza_type_id) P ON P.pizza_id = D.pizza_id )

SELECT DATEPART(HOUR, time ) AS hour, COUNT(*) AS total_sales
FROM Pizza_sale_period
GROUP BY DATEPART(HOUR, time )
ORDER BY total_sales DESC


--calculating the total sales for the ENTIRE  store 

SELECT SUM(P.price * O.quantity) Total_sales
FROM pizza_sales..order_details O
JOIN pizza_sales..pizzas P ON O.pizza_id = P.pizza_id 

--CALCLATING SALES FOR EACH PIZZA 

WITH Product_sales AS (SELECT SUM(P.price * O.quantity) Total_sales, O.pizza_id 
FROM pizza_sales..order_details O
JOIN pizza_sales..pizzas P ON O.pizza_id = P.pizza_id
GROUP BY O.pizza_id)

SELECT F.name, G.Total_sales 
FROM Product_sales G
JOIN (SELECT O.date, O.time, P.name, P.pizza_id  
FROM pizza_sales..order_details D
JOIN pizza_sales..orders O ON D.order_id = O.order_id
JOIN (SELECT B.price, A.name, B.size, A.ingredients, B.pizza_id 
FROM pizza_sales..pizza_types A
 JOIN pizza_sales..pizzas B ON A.pizza_type_id = B.pizza_type_id) P ON P.pizza_id = D.pizza_id ) F
 ON G.pizza_id = F.pizza_id 
ORDER BY G.Total_sales  