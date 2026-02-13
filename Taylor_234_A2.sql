-- Taylor Brackett - Assignment #2 - Given Schema from class

CREATE SCHEMA IF NOT EXISTS healthsense;
SET search_path TO healthsense;

DROP TABLE IF EXISTS lab_results;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
  user_id   INTEGER PRIMARY KEY,
  name      TEXT NOT NULL,
  age       INTEGER NOT NULL CHECK (age > 0),
  city      TEXT NOT NULL,
  gender    TEXT NOT NULL CHECK (gender IN ('F','M','X'))
);

CREATE TABLE lab_results (
  lab_id    BIGINT PRIMARY KEY,
  user_id   INTEGER NOT NULL REFERENCES users(user_id),
  test_name TEXT NOT NULL,
  value     NUMERIC(10,2) NOT NULL,
  unit      TEXT NOT NULL,
  test_date DATE NOT NULL
);

-- Task 2 - Indices
-- Index 1 for Query 1
DROP INDEX IF EXISTS healthsense.lab_results_test_name_index;
CREATE INDEX lab_results_test_name_index
ON healthsense.lab_results(test_name);

-- Index 2 for Query 2
DROP INDEX IF EXISTS healthsense.lab_results_test_date_index;
CREATE INDEX lab_results_test_date_index
ON healthsense.lab_results(test_date);

-- Index 3 for Query 3
DROP INDEX IF EXISTS healthsense.lab_results_user_id_index;
CREATE INDEX lab_results_user_id_index
ON healthsense.lab_results(user_id);

-- Composite Index for Queries 1 and 2
DROP INDEX IF EXISTS healthsense.lab_results_name_and_date_index;
CREATE INDEX lab_results_name_and_date_index
ON healthsense.lab_results(test_name, test_date);

-- Task 3 - Writing SQL
-- Set the search path
SET search_path TO healthsense;

-- Average glucose value in 2025
SELECT AVG(value) AS avg_glucose_2025
FROM lab_results
WHERE test_name = 'Glucose'
	AND test_date >= DATE '2025-01-01'
	AND test_date < DATE '2026-01-01';

-- Top 5 cities by average glucose in 2025
SELECT u.city, AVG(l.value) AS avg_glucose_2025
FROM users u
JOIN lab_results l ON l.user_id = u.user_id
WHERE l.test_name = 'Glucose'
	AND l.test_date >= DATE '2025-01-01'
	AND l.test_date < DATE '2026-01-01'
GROUP BY u.city
ORDER BY avg_glucose_2025 DESC
LIMIT 5;

-- Users who had both Glucose and Cholesterol tests in 2025
SELECT u.user_id, u.name
FROM users u
WHERE EXISTS (
	SELECT 1
	FROM lab_results l
	WHERE l.user_id = u.user_id
		AND l.test_name = 'Glucose'
		AND l.test_date >= DATE '2025-01-01'
		AND l.test_date < DATE '2026-01-01'
)
AND EXISTS (
	SELECT 1
	FROM lab_results l
	WHERE l.user_id = u.user_id
		AND l.test_name = 'Cholesterol'
		AND l.test_date >= DATE '2025-01-01'
		AND l.test_date < DATE '2026-01-01'
-- You could use LIMIT here if you want to only show a certain amount of users
);


-- The number of distinct users with any lab test in 2025
SELECT u.city, COUNT(DISTINCT u.user_id) AS users_with_any_lab_test_2025
FROM users u
JOIN lab_results l on l.user_id = u.user_id
WHERE l.test_date >= DATE '2025-01-01'
	AND l.test_date >= DATE '2025-01-01'
	AND l.test_date < DATE '2026-01-01'
GROUP BY u.city
ORDER BY users_with_any_lab_test_2025 DESC;

-- Rewritten query for how many distinct users had any lab test in March of 2025
SELECT u.city,
	COUNT(DISTINCT u.user_id)
FROM users u
JOIN lab_results l
	ON l.user_id = u.user_id
WHERE l.test_date >= DATE '2025-03-01'
	AND l.test_date < DATE '2025-04-01'
GROUP BY u.city

-- Revised AI Query - Top 5 users who test values show the largest increase over time in 2025
WITH test_increase AS (
  SELECT
    l.user_id,
    l.test_name,
    MAX(l.value) - MIN(l.value) AS value_increase
  FROM lab_results l
  WHERE l.test_date >= DATE '2025-01-01'
    AND l.test_date <  DATE '2026-01-01'
  GROUP BY l.user_id, l.test_name
),
best_per_user AS (
  SELECT
    user_id,
    MAX(value_increase) AS max_increase_2025
  FROM test_increase
  GROUP BY user_id
)
SELECT
  u.user_id,
  u.name,
  b.max_increase_2025
FROM best_per_user b
JOIN users u
  ON u.user_id = b.user_id
ORDER BY b.max_increase_2025 DESC
LIMIT 5;

