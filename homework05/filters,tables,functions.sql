SELECT * FROM movies;
SELECT * FROM directors;
SELECT * FROM movie_awards;
SELECT * FROM movie_revenues;
SELECT * FROM actors;
SELECT * FROM actor_awards;
SELECT * FROM awards;
SELECT * FROM genres;
SELECT * FROM cast_members;
SELECT * FROM movie_genres;
SELECT * FROM movie_locations;
SELECT * FROM users;
SELECT * FROM user_watchlist;
SELECT * FROM reviews;
SELECT * FROM movie_production_companies;
SELECT * FROM production_companies;

-- Find average rating per movie
SELECT 
	m.title AS movie,
	ROUND(AVG(r.rating), 2) AS average_rating
FROM movies m 
JOIN reviews r
ON m.movie_id = r.movie_id
GROUP BY m.title;

-- Create and query a temp table with movies where total revenue (domestic plus international) is greated than 100000000
CREATE TEMPORARY TABLE temp_movies_total_revenue
AS 
SELECT 
	m.title,
	SUM(mr.domestic_revenue + mr.international_revenue) AS total_revenue
FROM movies m
JOIN movie_revenues mr
ON m.movie_id = mr.movie_id
GROUP BY m.movie_id, m.title
HAVING SUM(mr.domestic_revenue + mr.international_revenue) > 100e6;

SELECT * FROM temp_movies_total_revenue;

-- Create a function to get average rating of a movie by title
CREATE OR REPLACE FUNCTION get_average_rating(movie_title VARCHAR)
RETURNS DECIMAL AS $$ 
DECLARE 
	avg_rating DECIMAL;
BEGIN
	SELECT
		ROUND(AVG(r.rating), 2)
	INTO avg_rating	
	FROM movies m 
	JOIN reviews r
	ON m.movie_id = r.movie_id
	WHERE m.title = movie_title;
	RETURN avg_rating;
END;
$$ LANGUAGE plpgsql;


SELECT get_average_rating('Inception');

-- Find the top 5 actors with most movie appearances
SELECT
	CONCAT(a.first_name,' ',a.last_name) AS actor,
	COUNT(c.actor_id) AS appearance
FROM actors a
JOIN cast_members c
ON a.actor_id = c.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
ORDER BY appearance DESC
LIMIT 5;

-- Show all user emails in lowercase
SELECT 
	LOWER(email) AS user_email
FROM users;

-- Show year of release for each movie
SELECT 
	title,
	EXTRACT(YEAR FROM release_date) AS release_year
FROM movies;

-- Round domestic revenue to nearest dollar
SELECT
	ROUND(domestic_revenue) AS round_domestic_revenue
FROM movie_revenues;

-- Count how many reviews each movie has
SELECT
	m.title,
	COUNT(*) AS review_count
FROM reviews r
JOIN movies m
ON r.movie_id = m.movie_id
GROUP BY m.movie_id,m.title;
-- Show full name of all actors (first + last name)
SELECT 
	CONCAT(first_name, ' ', last_name) AS actor_name
FROM actors;

-- Get total number of movies directed by a specific director CREATE OR REPLACE FUNCTION count_movies_by_director(director_name TEXT) (Custom Function That Returns a Single Value)
CREATE OR REPLACE FUNCTION count_movies_by_director(director_name TEXT)
RETURNS INTEGER 
AS $$
DECLARE 
	number_of_movies INTEGER;
BEGIN
	SELECT 
		COUNT(m.movie_id)
	INTO number_of_movies
	FROM movies m
	JOIN directors d
	ON m.director_id = d.director_id
	WHERE CONCAT(d.first_name,' ',d.last_name) = director_name;
	RETURN number_of_movies;
END;
$$ LANGUAGE plpgsql;


SELECT count_movies_by_director('Christopher Nolan');

-- Get all movies with rating above a certain number (Custom Function That Returns a Table)
CREATE OR REPLACE FUNCTION get_movies_with_rating_above_8()
RETURNS TABLE (
	title VARCHAR,
	rating INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN 
	RETURN QUERY
	SELECT
		m.title,
		r.rating
	FROM movies m
	JOIN reviews r
	ON m.movie_id = r.movie_id
	GROUP BY m.movie_id, m.title, r.rating
	HAVING r.rating > 8;
END;
$$;


SELECT * FROM get_movies_with_rating_above_8();