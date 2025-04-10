SELECT * FROM movies;
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
-- Show movies and their directors
SELECT 
	m.title,
	CONCAT(d.first_name,' ',d.last_name) AS "director_name"
FROM movies m
FULL JOIN directors d
ON m.director_id = d.director_id;
-- Show actors and their movies
SELECT
	CONCAT(a.first_name,' ',a.last_name) AS "actor_name",
	m.title
FROM cast_members cm
FULL JOIN actors a
ON cm.actor_id = a.actor_id
FULL JOIN movies m
ON cm.movie_id = m.movie_id;
-- Show movies and their genres
SELECT
	m.title,
	g.name
FROM movie_genres mg
JOIN movies m
ON mg.movie_id = m.movie_id
JOIN genres g
ON mg.genre_id = g.genre_id;
-- Show users and their reviews
SELECT 
	u.username,
	m.title AS movie,
	r.rating,
	r.review_text
FROM reviews r
JOIN movies m
ON r.movie_id = m.movie_id
JOIN users u
ON r.user_id = u.user_id;
-- Show movies and their locations
SELECT 
	m.title,
	CONCAT(l.city,', ',l.country,', ',l.specific_location) AS location
FROM movie_locations l
JOIN movies m
ON l.movie_id = m.movie_id;
-- Show movies and their production companies
SELECT
	m.title,
	c.name AS company_name
FROM movie_production_companies mc
JOIN movies m
ON mc.movie_id = m.movie_id
JOIN production_companies c
ON mc.company_id = c.company_id;
-- Show actors and their awards
SELECT 
	CONCAT(a.first_name,' ',a.last_name) AS "actor_name",
	aw.* 
FROM actor_awards aa
JOIN actors a
ON aa.actor_id = a.actor_id
JOIN awards aw
ON aa.award_id = aw.award_id;
-- Show movies and their awards
SELECT 
	m.title,
	aw.* 
FROM movie_awards ma
JOIN movies m
ON ma.movie_id = m.movie_id
JOIN awards aw
ON ma.award_id = aw.award_id;
-- Show users and their watchlist movies
SELECT
	u.username,
	m.title AS movie
FROM user_watchlist uw
JOIN users u
ON uw.user_id = u.user_id
JOIN movies m
ON uw.movie_id = m.movie_id;
-- Show movies and their revenues
SELECT 
	m.title AS movie,
	r.*  
FROM movie_revenues r
JOIN movies m
ON r.movie_id = m.movie_id;