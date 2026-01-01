-- Purpose: Breaks down customer distribution by city and country across key global markets.
-- Skills: Multi-table joins, aggregation, filtering, grouping, ordering
-- Business Use: Identifies city-level market penetration for regional growth planning.

SELECT 
    ct.city,
    ctr.country,
    COUNT(c.customer_id) AS customer_count
FROM customer c
INNER JOIN address a ON c.address_id = a.address_id
INNER JOIN city ct ON a.city_id = ct.city_id
INNER JOIN country ctr ON ct.country_id = ctr.country_id
WHERE ctr.country IN ('India','China','United States','Japan','Mexico','Brazil',
                      'Russian Federation','Philippines','Turkey','Indonesia')
GROUP BY ct.city, ctr.country
ORDER BY customer_count DESC
LIMIT 10;
