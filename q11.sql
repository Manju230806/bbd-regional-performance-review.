-- What are completed-order revenue and customer counts by region and month?
-- INNER JOIN is appropriate because only orders with matching customers are reportable; COUNT(DISTINCT customer_id) is needed because a customer may place multiple orders in the same month.
SELECT c.region,
       o.order_month,
       COUNT(o.order_id) AS number_of_orders,
       COUNT(DISTINCT o.customer_id) AS number_of_customers,
       SUM(o.amount) AS total_revenue,
       AVG(o.amount) AS average_revenue
FROM orders AS o
JOIN customers AS c ON o.customer_id = c.customer_id
WHERE o.status = 'completed'
GROUP BY c.region, o.order_month
ORDER BY c.region, o.order_month;
