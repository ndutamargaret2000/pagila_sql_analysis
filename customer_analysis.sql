--1... Top 10 highest spending customers by the total amount spent

SELECT c.customer_id, c.first_name, c.last_name,
        SUM(p.amount) AS total_amount
FROM customer c
JOIN payment p
ON c.customer_id = p.customer_id
GROUP BY c.customer_id,
        c.first_name,
        c.last_name
ORDER BY total_amount DESC
LIMIT 10;


---3. Top 3 customers in each store

WITH ranked_customer AS (

        SELECT c.customer_id, 
                c.first_name, 
                c.last_name,
                SUM(p.amount) AS total_spent,
                s.store_id
        FROM customer c 
        JOIN payment p ON c.customer_id = p.customer_id
        JOIN store s ON c.store_id = s.store_id
        GROUP BY c.customer_id, 
                c.first_name, 
                c.last_name,
                s.store_id
),
top_customers AS (
    SELECT customer_id, 
        first_name, 
        last_name,
        total_spent,
        store_id,
        RANK() OVER (PARTITION BY store_id ORDER BY total_spent DESC ) AS rank
FROM ranked_customer
)
SELECT  store_id,
        customer_id, 
        first_name, 
        last_name,
        total_spent,
        rank
FROM top_customers
WHERE  rank <=3
ORDER BY store_id ;

--2.--Highest paying customer each month

WITH monthly_spending AS (
    SELECT
        DATE_TRUNC ('month', p.payment_date) AS month,
        c.customer_id,
        c.first_name,
        c.last_name,
        SUM(p.amount) AS amount_spent
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY 1,2,3,4
),
top_one AS (
        SELECT month,
            customer_id,
            first_name,
            last_name,
            amount_spent,
            RANK () OVER (PARTITION BY month ORDER BY amount_spent DESC) AS rank
        FROM monthly_spending
)
SELECT      month,
            customer_id,
            first_name,
            last_name,
            amount_spent,
            rank
FROM top_one
WHERE rank = 1
ORDER BY month; 


--3.--Top 3 customers each month and percentage of revenue they contributed that month

WITH monthly_spending AS (
    SELECT
         TO_CHAR( payment_date,'Mon-YYYY') AS month,
        c.customer_id,
        c.first_name,
        c.last_name,
        SUM(p.amount) AS amount_spent
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY 1,2,3,4
),
top_one AS (
        SELECT month,
            customer_id,
            first_name,
            last_name,
            amount_spent,
            RANK () OVER (PARTITION BY month ORDER BY amount_spent DESC) AS rank
        FROM monthly_spending
),
percentage_contributions  AS (
    SELECT       month,
            customer_id,
            first_name,
            last_name,
            amount_spent,
            rank,
            SUM(amount_spent) OVER (PARTITION BY month) AS revenue
    FROM top_one
)
SELECT      month,
            customer_id,
            first_name,
            last_name,
            amount_spent,
            rank,
            revenue,
            ROUND((amount_spent / revenue )* 100,2) AS perc_revenue
FROM percentage_contributions
WHERE rank <= 3
ORDER BY month; 
