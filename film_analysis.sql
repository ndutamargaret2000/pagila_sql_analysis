--1-- Which 10 films were rented the most

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

--2--Which 10 films generated the most revenue

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