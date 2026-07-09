--1-- Which 10 films were rented the most?

SELECT f.film_id,
        f.title, 
        COUNT(r.rental_id) AS no_of_rentals
FROM film f 
JOIN inventory i 
    ON f.film_id = i.film_id
JOIN rental r
    ON i.inventory_id = r.inventory_id
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 10;

--2--Which 10 films generated the most revenue?

SELECT f.film_id,
        f.title,
        COUNT(r.rental_id) AS total_rentals,
        SUM(p.amount) AS revenue,
        ROUND(AVG(p.amount),2) AS average_payment
FROM film f 
JOIN inventory i 
    ON f.film_id = i.film_id
JOIN rental r
    ON i.inventory_id = r.inventory_id
JOIN payment p 
    ON r.rental_id = p.rental_id
GROUP BY f.film_id,
        f.title
ORDER BY revenue DESC
LIMIT 10;

--3-- Which film categories are rented the most?

SELECT c.name,
        COUNT(r.rental_id) AS no_of_rentals
FROM category c
JOIN film_category fm
    ON fm.category_id = c.category_id
JOIN film f 
    ON fm.film_id = f.film_id
JOIN inventory i 
    ON f.film_id = i.film_id
JOIN rental r
    ON i.inventory_id = r.inventory_id
GROUP BY c.name
ORDER BY no_of_rentals DESC
LIMIT 10;

--4-- Which film category generates the most revenue?

SELECT c.name,
        SUM(p.amount) AS revenue
FROM category c
JOIN film_category fm
    ON fm.category_id = c.category_id
JOIN film f 
    ON fm.film_id = f.film_id
JOIN inventory i 
    ON f.film_id = i.film_id
JOIN rental r
    ON i.inventory_id = r.inventory_id
JOIN payment p
    ON r.rental_id = p.rental_id
GROUP BY c.name
ORDER BY revenue DESC;

--5-- Which category has the highest average revenue per rental?


WITH revenue AS (

    SELECT c.name,
            SUM(p.amount) AS total_revenue,
            COUNT(r.rental_id) AS total_rentals
    FROM category c
    JOIN film_category fm
        ON fm.category_id = c.category_id
    JOIN film f 
        ON fm.film_id = f.film_id
    JOIN inventory i 
        ON f.film_id = i.film_id
    JOIN rental r
        ON i.inventory_id = r.inventory_id
    JOIN payment p
        ON r.rental_id = p.rental_id
    GROUP BY c.name
)
SELECT name,
    ROUND((total_revenue/total_rentals),2) AS avg_rev_per_rental
FROM revenue
ORDER BY avg_rev_per_rental DESC;
    