-- Calculate the percentage contribution of each pizza type to total revenue.

SELECT 
    category,
    ROUND((revenue / (SELECT 
                    SUM(order_details.quantity * pizzas.price)
                FROM
                    order_details
                        JOIN
                    pizzas ON order_details.pizza_id = pizzas.pizza_id) * 100),
            2) AS percentage
FROM
    (SELECT 
        pizza_types.category,
            ROUND(SUM(order_details.quantity * pizzas.price), 2) AS revenue
    FROM
        pizza_types
    JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
    JOIN order_details ON order_details.pizza_id = pizzas.pizza_id
    GROUP BY pizza_types.category
    ORDER BY revenue DESC) AS revenuegen
GROUP BY category;

-- Analyze the cumulative revenue generated over time.

select order_date, sum(revenue) over (order by order_date) as cumulative_revenue from
(select orders.order_date, round(sum(order_details.quantity*pizzas.price),2) as revenue from
orders join order_details on orders.order_id=order_details.order_id
join pizzas on pizzas.pizza_id=order_details.pizza_id
group by orders.order_date) as sales 
group by order_date;

-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.

select category,name, revenue from
(select category, name,revenue,rank() over (partition by category order by revenue desc) as rk from
(select pizza_types.category,pizza_types.name, round(sum(order_details.quantity*pizzas.price),2) as revenue
from order_details join pizzas on order_details.pizza_id=pizzas.pizza_id
join pizza_types on pizza_types.pizza_type_id=pizzas.pizza_type_id
group by pizza_types.category,pizza_types.name) as a) as b
where rk <=3 ;