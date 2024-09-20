-- Step 1: Create a View
CREATE VIEW step1 AS
SELECT 
	c.customer_id,
    c.first_name,
    c.email,
    count(r.rental_id) as rental_count
FROM sakila.customer c
JOIN sakila.rental r
	ON c.customer_id = r.customer_id
GROUP BY c.customer_id;

-- Step 2: Create a Temporary Table
CREATE TEMPORARY TABLE step2 AS
SELECT
	s1.customer_id,
	SUM(p.amount) as total_paid
FROM sakila.payment p
JOIN sakila.step1 s1
	ON p.customer_id = s1.customer_id
GROUP BY s1.customer_id;


-- Step 3: Create a CTE and the Customer Summary Reportcustomers
WITH step3 AS(
	SELECT
		s1.first_name,
		s1.email,
		s1.rental_count,
        s2.total_paid
    FROM sakila.step1 s1
    JOIN sakila.step2 s2 ON s1.customer_id = s2.customer_id
)

SELECT *, 
	(s3.total_paid/s3.rental_count) as average_payment_per_rental
FROM step3 s3;