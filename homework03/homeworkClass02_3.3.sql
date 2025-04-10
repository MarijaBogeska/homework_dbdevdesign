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
-- Show all R-rated movies and their directors
SELECT 
	m.title AS movie,
	CONCAT(d.first_name,' ',d.last_name) AS "director_name"
FROM movies m
JOIN directors d
ON m.director_id = d.director_id
WHERE m.rating = 'R';
-- Show all movies from 2019 and their genres
SELECT
	m.title,
	g.name
FROM movie_genres mg
JOIN movies m
ON mg.movie_id = m.movie_id
JOIN genres g
ON mg.genre_id = g.genre_id
WHERE m.release_date >= '2019.01.01';
-- Show all American actors and their movies
SELECT
	CONCAT(a.first_name,' ',a.last_name) AS "actor_name",
	m.title
FROM cast_members cm
FULL JOIN actors a
ON cm.actor_id = a.actor_id
FULL JOIN movies m
ON cm.movie_id = m.movie_id
WHERE a.nationality = 'American';
-- Show all movies with budget over 100M and their production companies
SELECT
	m.title,
	c.name AS company_name
FROM movie_production_companies mc
JOIN movies m
ON mc.movie_id = m.movie_id
JOIN production_companies c
ON mc.company_id = c.company_id
WHERE m.budget > '100e6';
-- Show all movies filmed in 'London' and their directors
SELECT 
	m.title,
	CONCAT(d.first_name,' ',d.last_name) AS "director_name"
FROM movies m
FULL JOIN directors d
ON m.director_id = d.director_id
JOIN movie_locations ml
ON ml.movie_id = m.movie_id
WHERE ml.city = 'Los Angeles'; -- there is not location London
-- Show all horror movies and their actors
SELECT
	m.title,
	CONCAT(a.first_name,' ',a.last_name) AS "actor_name"
FROM cast_members cm
FULL JOIN actors a
ON cm.actor_id = a.actor_id
FULL JOIN movies m
ON cm.movie_id = m.movie_id
JOIN movie_genres mg
ON mg.movie_id = m.movie_id
JOIN genres g
ON mg.genre_id = g.genre_id
WHERE g.name = 'Horror';
-- Show all movies with reviews rated 5 and their reviewers
SELECT 
	u.username,
	m.title AS movie,
	r.*
FROM reviews r
JOIN movies m
ON r.movie_id = m.movie_id
JOIN users u
ON r.user_id = u.user_id
WHERE r.rating = '10'; -- there is no rating 5 
-- Show all British directors and their movies
SELECT 
	CONCAT(d.first_name,' ',d.last_name) AS "director_name",
	m.title AS movie
FROM movies m
FULL JOIN directors d
ON m.director_id = d.director_id
WHERE d.nationality = 'British';
-- Show all movies longer than 180 minutes and their genres
SELECT
	m.title,
	g.name
FROM movie_genres mg
JOIN movies m
ON mg.movie_id = m.movie_id
JOIN genres g
ON mg.genre_id = g.genre_id
WHERE m.duration_minutes > 130; -- there is not a movie longer than 180min
-- Show all Oscar-winning movies and their director
SELECT 
	m.title,
	CONCAT(d.first_name,' ',d.last_name) AS "director_name"
FROM movies m
JOIN directors d
ON m.director_id = d.director_id
JOIN movie_awards ma
ON ma.movie_id = m.movie_id
JOIN awards a
ON ma.award_id = a.award_id
WHERE a.award_type = 'Oscar';