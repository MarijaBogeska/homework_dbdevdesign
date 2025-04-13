-- Homework requirements 2/2
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
-- Create a view that shows top-rated movies. Include: movie title, average rating, review count, director name
CREATE VIEW top_rated_movies AS
SELECT 
	m.title AS movie,
	ROUND(AVG(r.rating),2) AS average_rating,
	COUNT(r.review_id) AS review_count,
	CONCAT(d.first_name,' ',d.last_name) AS director_name
FROM movies m
JOIN directors d
ON m.director_id = d.director_id
JOIN reviews r
ON m.movie_id = r.movie_id
GROUP BY m.movie_id,m.title,d.director_id;
SELECT * FROM top_rated_movies;
-- Create a view for movie financial performance. Include: movie title, budget,total revenue, profit, ROI
CREATE VIEW movie_financial_performance AS
SELECT 
	m.title AS movie,
	m.budget AS movie_budget,
	SUM(mr.domestic_revenue + mr.international_revenue) AS total_revenue,
	SUM(mr.domestic_revenue + mr.international_revenue) - m.budget AS profit,
	ROUND((SUM(mr.domestic_revenue + mr.international_revenue) - m.budget)/m.budget) AS roi
FROM movies m
JOIN movie_revenues mr
ON m.movie_id = mr.movie_id
GROUP BY m.movie_id,m.title,m.budget;
SELECT * FROM movie_financial_performance;
-- Create a view for actor filmography. Include: actor name, movie count, genre list, total revenue
CREATE VIEW actor_filmography AS
SELECT 
	CONCAT(a.first_name,' ',a.last_name) AS actor_name,
	COUNT(m.movie_id) AS movie_count,
	STRING_AGG(DISTINCT g.name,', ') AS genre_list,
	SUM(mr.domestic_revenue + mr.international_revenue) AS total_revenue
FROM actors a
JOIN cast_members c
ON a.actor_id = c.actor_id
JOIN movies m
ON c.movie_id = m.movie_id
JOIN movie_genres mg
ON m.movie_id = mg.movie_id
JOIN genres g
ON mg.genre_id = g.genre_id
JOIN movie_revenues mr
ON m.movie_id = mr.movie_id
GROUP BY a.actor_id,a.first_name,a.last_name;
SELECT * FROM actor_filmography;
-- Create a view for genre statistics. Include: genre name, movie count, average rating, total revenue
CREATE VIEW genre_statistics AS 
SELECT
	g.name,
	COUNT(m.movie_id) AS movie_count,
	ROUND(AVG(r.rating),2) AS average_rating,
	SUM(mr.domestic_revenue + mr.international_revenue) AS total_revenue
FROM genres g
JOIN movie_genres mg
ON g.genre_id = mg.genre_id
JOIN movies m
ON mg.movie_id = m.movie_id
JOIN reviews r
ON m.movie_id = r.movie_id
JOIN movie_revenues mr
ON m.movie_id = mr.movie_id
GROUP BY g.genre_id, g.name;
SELECT * FROM genre_statistics;
-- Create a view for production company performance. Include: company name, movie count, total investment, total revenue
CREATE VIEW production_company_performance AS
SELECT 
	c.name AS company_name,
	COUNT(m.movie_id) AS movie_count,
	SUM(mc.investment_amount) AS total_investment,
	SUM(mr.domestic_revenue + mr.international_revenue) AS total_revenue
FROM production_companies c
JOIN movie_production_companies mc
ON c.company_id = mc.company_id
JOIN movies m
ON mc.movie_id = m.movie_id
JOIN movie_revenues mr
ON m.movie_id =mr.movie_id
GROUP BY c.company_id,c.name;
SELECT * FROM production_company_performance;