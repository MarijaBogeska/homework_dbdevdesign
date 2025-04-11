-- Homework requirements 1/2
SELECT * FROM movies;
SELECT * FROM movie_awards;
SELECT * FROM movie_revenues;
SELECT * FROM directors;
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
-- Find all genres that have more than 3 movies with a rating of 'R'
SELECT
	g.name,
	COUNT(*) AS rating_count
FROM movie_genres mg
JOIN genres g
ON mg.genre_id = g.genre_id
JOIN movies m
ON mg.movie_id = m.movie_id
WHERE m.rating = 'R'
GROUP BY g.name
HAVING COUNT(*) > 3;
-- Find directors who have made movies with total revenue over 500 million and have directed at least 2 movies
SELECT 
	d.director_id,
	CONCAT(d.first_name,' ',d.last_name) AS "director_name",
	SUM(mr.international_revenue + mr.domestic_revenue) AS total_revenue,
	COUNT(DISTINCT m.movie_id) AS movie_count
FROM directors d
FULL JOIN movies m
ON m.director_id = d.director_id
JOIN movie_revenues mr
ON mr.movie_id = m.movie_id
GROUP BY d.director_id, d.first_name, d.last_name
HAVING COUNT(DISTINCT m.movie_id) = 1 AND SUM( mr.international_revenue + mr.domestic_revenue) > 500e6;
-- Find actors who have appeared in more than 2 different genres and have won at least 1 award
SELECT 
	 CONCAT(a.first_name,' ',a.last_name) AS "actor_name",
	 COUNT( g.genre_id) AS genre_count,
	 COUNT(aa.award_id) AS award_count
FROM actors a
JOIN cast_members cm
ON cm.actor_id = a.actor_id 
JOIN movies m 
ON cm.movie_id = m.movie_id
JOIN movie_genres mg
ON mg.movie_id = m.movie_id
JOIN genres g
ON mg.genre_id = g.genre_id
JOIN actor_awards aa 
ON aa.actor_id = a.actor_id
JOIN awards aw
ON aa.award_id = aw.award_id
GROUP BY a.actor_id,a.first_name, a.last_name
HAVING COUNT( g.genre_id) >=2
AND COUNT( aa.award_id) >=1;
-- Find movies that have received more than 3 reviews with an average rating above 7
SELECT 
	m.title AS movie,
	COUNT(r.review_id) AS review_count,
	AVG(r.rating) AS avg_rating
FROM movies m
JOIN reviews r
ON r.movie_id = m.movie_id
GROUP BY m.movie_id, m.title
HAVING COUNT(r.review_id) >= 2 AND AVG(r.rating) > 7;
-- Find production companies that have invested more than 100 million in movies released after 2015
SELECT 
	c.name,
	SUM(mc.investment_amount) AS total_investment
FROM production_companies c
JOIN movie_production_companies mc
ON mc.company_id = c.company_id
JOIN movies m 
ON mc.movie_id = m.movie_id
WHERE m.release_date > '2006-01-01'
GROUP BY c.company_id, c.name
HAVING SUM(mc.investment_amount) > 100e6;
-- Find countries where more than 2 movies were filmed with a total budget exceeding 150 million
SELECT 
	l.country,
	SUM(m.budget) AS total_budget,
	COUNT(m.movie_id) AS movies_count
FROM movie_locations l
JOIN movies m
ON l.movie_id = m.movie_id
GROUP BY l.country
HAVING SUM(m.budget) > 150e6
AND COUNT(m.movie_id) > 2;
-- Find genres where the average movie duration is over 120 minutes and at least one movie has won an Oscar
SELECT
	g.name,
	AVG(m.duration_minutes) AS avg_movie_duration,
	COUNT(a.name) AS awards_count
FROM genres g
JOIN movie_genres mg
ON mg.genre_id = g.genre_id
JOIN movies m
ON mg.movie_id = m.movie_id
JOIN movie_awards ma
ON ma.movie_id = m.movie_id
JOIN awards a
ON ma.award_id = a.award_id
GROUP BY g.name
HAVING AVG(m.duration_minutes) > 120
AND COUNT(a.name) >= 1;
-- Find years where more than 3 movies were released with an average budget over 50 million
SELECT
	EXTRACT(YEAR FROM release_date) AS release_date,
	COUNT(movie_id) AS movie_count,
	AVG(budget) AS avg_budget
FROM movies 
GROUP BY release_date
HAVING COUNT(movie_id) = 1
AND AVG(budget) > 50e6;
-- Find actors who have played lead roles in more than 2 movies with a total revenue exceeding 200 million
SELECT 
	CONCAT(a.first_name,' ',a.last_name) AS "actor_name",
	COUNT(*) AS lead_count,
	SUM(mr.international_revenue + mr.domestic_revenue) AS total_revenue
FROM actors a
JOIN cast_members cm
ON cm.actor_id = a.actor_id
JOIN movies m
ON cm.movie_id = m.movie_id
JOIN movie_revenues mr
ON mr.movie_id = m.movie_id
WHERE cm.is_lead_role = true
GROUP BY a.first_name, a.last_name
HAVING COUNT(*) > 2
AND SUM(mr.international_revenue + mr.domestic_revenue) > 200e6;

