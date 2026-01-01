-- Purpose: Identifies the highest lifetime value customers across key global markets.
-- Skills: Multi-table joins, aggregation, filtering, grouping, sorting
-- Business Use: Used to target VIP customers and prioritize retention marketing.

SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    ctr.country,
    ct.city,
    SUM(p.amount) AS total_amount_paid
FROM customer c
INNER JOIN payment p ON c.customer_id = p.customer_id
INNER JOIN address a ON c.address_id = a.address_id
INNER JOIN city ct ON a.city_id = ct.city_id
INNER JOIN country ctr ON ct.country_id = ctr.country_id
WHERE ct.city IN ('Aurora','Atlixco','Xintai','Adoni','Dhule (Dhulia)','Kurashiki',
                  'Pingxiang','Sivas','Celaya','So Leopoldo')
  AND ctr.country IN ('India','China','United States','Japan','Mexico','Brazil',
                      'Russian Federation','Philippines','Turkey','Indonesia')
GROUP BY 
    c.customer_id, c.first_name, c.last_name, ctr.country, ct.city
ORDER BY total_amount_paid DESC
LIMIT 5;
