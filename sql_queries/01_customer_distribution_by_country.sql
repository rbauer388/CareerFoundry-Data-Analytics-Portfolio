-- Purpose: Displays the number of customers by country.
-- Skills: Aggregation, multi-table joins, grouping, ordering
-- Business Use: Identifies where Rockbuster has the highest customer concentration.

SELECT 
    ctr.country,
    COUNT(c.customer_id) AS customer_count
FROM customer c
INNER JOIN address a ON c.address_id = a.address_id
INNER JOIN city ct ON a.city_id = ct.city_id
INNER JOIN country ctr ON ct.country_id = ctr.country_id
GROUP BY ctr.country
ORDER BY customer_count DESC
LIMIT 10;
