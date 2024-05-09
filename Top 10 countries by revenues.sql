SELECT SUM (payment.amount) AS total_revenue, country.country
FROM payment
JOIN customer  ON payment.customer_id = customer.customer_id
JOIN address  ON customer.address_id = address.address_id
JOIN city  ON address.city_id = city.city_id
JOIN country  ON city.country_id = country.country_id
GROUP BY country
ORDER BY total_revenue DESC
LIMIT 10;
