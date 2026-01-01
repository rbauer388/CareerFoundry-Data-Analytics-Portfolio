-- 04_top_customer_market_power.sql
-- Purpose: Analyze revenue concentration and whale dependency across priority international markets.
-- Business Use: Identifies countries with high reliance on a few top-spending customers (revenue risk).

-- ============================
-- STEP 1: Average spend of top 5 customers
-- ============================

WITH Top5Customers AS (
    SELECT
        B.customer_id,
        B.first_name,
        B.last_name,
        D.city,
        E.country,
        SUM(A.amount) AS total_amount_paid
    FROM payment A
    INNER JOIN customer B ON A.customer_id = B.customer_id
    INNER JOIN address C ON B.address_id = C.address_id
    INNER JOIN city D ON C.city_id = D.city_id
    INNER JOIN country E ON D.country_id = E.country_id
    WHERE D.city IN ('Aurora','Atlixco','Xintai','Adoni','Dhule (Dhulia)','Kurashiki',
                     'Pingxiang','Sivas','Celaya','So Leopoldo')
      AND E.country IN ('India','China','United States','Japan','Mexico','Brazil',
                        'Russian Federation','Philippines','Turkey','Indonesia')
    GROUP BY B.customer_id, B.first_name, B.last_name, D.city, E.country
    ORDER BY total_amount_paid DESC
    LIMIT 5
)
SELECT AVG(total_amount_paid) AS average_top5_amount
FROM Top5Customers;

-- ============================
-- STEP 2: Country customer concentration
-- ============================

WITH top_5_within_countries AS (
    SELECT
        B.customer_id,
        E.country,
        SUM(A.amount) AS total_amount_paid
    FROM payment A
    INNER JOIN customer B ON A.customer_id = B.customer_id
    INNER JOIN address C ON B.address_id = C.address_id
    INNER JOIN city D ON C.city_id = D.city_id
    INNER JOIN country E ON D.country_id = E.country_id
    WHERE D.city IN ('Aurora','Atlixco','Xintai','Adoni','Dhule (Dhulia)','Kurashiki',
                     'Pingxiang','Sivas','Celaya','So Leopoldo')
      AND E.country IN ('India','China','United States','Japan','Mexico','Brazil',
                        'Russian Federation','Philippines','Turkey','Indonesia')
    GROUP BY B.customer_id, E.country
    ORDER BY total_amount_paid DESC
    LIMIT 5
)
SELECT
    cnt.country,
    COUNT(DISTINCT c.customer_id) AS total_customers,
    COUNT(DISTINCT t.customer_id) AS top_customer_count
FROM customer c
INNER JOIN address a ON c.address_id = a.address_id
INNER JOIN city ci ON a.city_id = ci.city_id
INNER JOIN country cnt ON ci.country_id = cnt.country_id
LEFT JOIN top_5_within_countries t ON t.country = cnt.country
WHERE cnt.country IN ('India','China','United States','Japan','Mexico','Brazil',
                      'Russian Federation','Philippines','Turkey','Indonesia')
GROUP BY cnt.country
ORDER BY top_customer_count DESC, total_customers DESC;
