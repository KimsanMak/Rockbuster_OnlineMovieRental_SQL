/* What was the average rental duration for all video and other basic statistics of the business? */
SELECT
	MIN(rental_duration) AS min_rental_duration,
	MAX(rental_duration) AS max_rental_duration,
	ROUND(AVG(rental_duration)) AS avg_rental_duration,
	MIN (rental_rate) AS min_rental_rate,
	MAX (rental_rate) AS max_rental_rate,
	ROUND(AVG (rental_rate)) AS avg_rental_rate,
	MIN (length) AS min_length,
	MAX (length) AS max_length,
	ROUND(AVG (length)) AS avg_length,
	MIN (replacement_cost) AS min_replacement_cost,
	MAX (replacement_cost) AS max_replacement_cost,
	ROUND(AVG (replacement_cost)) AS avg_replacement_cost
FROM film;

/* Which countries are Rockbuster customers based in? */
SELECT 
	COUNT (customer.customer_id) AS total_customers, country.country
FROM 
	customer
JOIN 
	address  ON customer.address_id = address.address_id
JOIN 
	city  ON address.city_id = city.city_id
JOIN 
	country  ON city.country_id = country.country_id
GROUP BY 
	country
ORDER BY 
	total_customers DESC;

/* Top 10 customers?  */
SELECT 
	country, 
	COUNT (A.customer_id) AS customer_numbers
FROM 
	customer A
INNER JOIN 
	address B ON A.address_id = B.address_id
INNER JOIN 
	city C ON B.city_id = C.city_id
INNER JOIN 
	country D ON C.country_id = D.country_id
INNER JOIN
	(SELECT D.country
	FROM customer A
	INNER JOIN address B ON A.address_id = B.address_id
	INNER JOIN city C ON B.city_id = C.city_id
	INNER JOIN country D ON C.country_ID = D.country_ID
	GROUP BY D.country
	ORDER BY COUNT(A.customer_id) DESC
	LIMIT 10) AS top_10_countries ON D.country = top_10_countries.country
GROUP BY D.country
ORDER BY customer_numbers DESC
LIMIT 10;

/* Where are customers with high lifetime value located? */
SELECT 
	B.customer_id,
	E.country,
	D.city,
	SUM (A.amount) AS total_amount_paid
FROM 
	payment A
INNER JOIN 
	customer B ON A.customer_id = B.customer_id
INNER JOIN 
	address C ON B.address_id = C.address_id
INNER JOIN 
	city D ON C.city_id = D.city_id
INNER JOIN 
	country E ON D.country_id = E.country_id
	WHERE D.city in 
		(SELECT D.city
		FROM customer B
		INNER JOIN address C ON B.address_id = C.address_id
		INNER JOIN city D ON C.city_id = D.city_id
		INNER JOIN country E ON D.country_id = E.country_id
			WHERE E.country IN 
	 			(SELECT E.country
				FROM customer B
				INNER JOIN address C ON B.address_id = C.address_id
				INNER JOIN city D ON C.city_id = D.city_id
				INNER JOIN country E ON D.country_id = E.country_id
				GROUP BY E.country
				ORDER BY COUNT(B.customer_id) DESC
				LIMIT 10)
		GROUP BY D.city
		ORDER BY COUNT(B.customer_id) DESC
		LIMIT 10)
GROUP BY B.customer_id,E.country,D.city
ORDER BY total_amount_paid DESC
LIMIT 10;

/* Get customer count and total payment received against each country? */
SELECT 
	country,
	COUNT (B.customer_id) AS customer_count,
	SUM (A.amount) AS total_payment
FROM 
	payment A
INNER JOIN 
	customer B ON A.customer_id = B.customer_id
INNER JOIN 
	address C ON B.address_id = C.address_id
INNER JOIN 
	city D ON C.city_id = D.city_id
INNER JOIN 
	country E ON D.country_id = E.country_id
GROUP BY 
	country
ORDER BY 	
	total_payment DESC

/* Revenue by films, and the most and least profitable films*/
SELECT
    film.film_id AS film_id,
    film.title AS title,
    COUNT(rental.rental_id) AS amount_rented,
    SUM(payment.amount) AS total_revenue
FROM    
	payment
JOIN
    rental ON payment.rental_id = rental.rental_id
JOIN
    inventory ON rental.inventory_id = inventory.inventory_id
JOIN
    film ON inventory.film_id = film.film_id
GROUP BY
    film.film_id,
    film.title
ORDER BY
    total_revenue DESC;
