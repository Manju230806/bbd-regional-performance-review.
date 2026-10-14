-- Which regions have completed-order revenue greater than 80000?
SELECT c.region, SUM(o.amount) AS revenue
FROM orders AS o
JOIN customers AS c ON o.customer_id = c.customer_id
WHERE o.status = 'completed'
GROUP BY c.region
HAVING SUM(o.amount) > 80000
ORDER BY revenue DESC;
