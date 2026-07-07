--1...Monthly revenue


SELECT DATE_TRUNC( 'month', payment_date) AS month,
        SUM(amount) AS revenue
FROM payment
GROUP BY month
ORDER BY month;

--2...Monthly revenue with running total

WITH monthly_revenue AS (
    SELECT DATE_TRUNC('month', payment_date) AS month,
        SUM(amount) AS revenue
FROM payment
GROUP BY month
ORDER BY month
)
SELECT TO_CHAR( month,'Mon-YYYY'),
       revenue,
       SUM(revenue) OVER (ORDER BY month) AS running_total
       FROM monthly_revenue;


--3... How much did revenue grow compared to last month

WITH revenue_growth AS ( 
       SELECT DATE_TRUNC('month', payment_date) AS month,
        SUM(amount) AS revenue
FROM payment
GROUP BY month
ORDER BY month 
)
SELECT month,
        revenue,
        LEAD(revenue) OVER( ORDER BY month)  as next__month_revue
 
FROM revenue_growth
