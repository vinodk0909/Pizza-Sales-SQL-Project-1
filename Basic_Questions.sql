
use pizzasales;

-- Basic

-- Retrieve the total number of orders placed.

select count(order_id) as TotalOrdersPlaced from orders;

-- Calculate the total revenue generated from pizza sales.

SELECT 
    ROUND(SUM(order_details.quantity * pizzas.price),
            2) AS Total_Revenue
FROM
    order_details
        JOIN
    pizzas ON order_details.pizza_id = pizzas.pizza_id;

-- Identify the highest-priced pizza.

SELECT 
    pizza_types.name, pizzas.price
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY price DESC
LIMIT 1;

-- Identify the most common pizza size ordered.

SELECT 
    pizzas.size, COUNT(order_details.quantity) AS order_count
FROM
    pizzas
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY size
ORDER BY order_count DESC
LIMIT 1;

-- List the top 5 most ordered pizza types along with their quantities.

SELECT 
    pizza_types.name, SUM(order_details.quantity) AS quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizza_types.name
ORDER BY quantity DESC
LIMIT 5;

