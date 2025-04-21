SELECT * FROM movie_revenues;
SELECT * FROM movies;
SELECT * FROM movie_genres;
SELECT * FROM genres;
-- Exercise 1: Write a transaction to insert a new movie and its revenue
-- o Insert into movies table
-- o Insert into movie_revenues table
-- o If any step fails, roll back both operations
CREATE OR REPLACE PROCEDURE insert_movie_and_its_revenue(
	movie VARCHAR,
	domestic_revenue NUMERIC,
	international_revenue NUMERIC
)
LANGUAGE plpgsql
AS $$
DECLARE 
	new_movie_id INTEGER;
BEGIN
	IF NOT EXISTS (
		SELECT 1 FROM movies WHERE title = movie
	) THEN 
		INSERT INTO movies (title)
		VALUES (movie)
		RETURNING movie_id INTO new_movie_id;
	ELSE
		SELECT movie_id INTO new_movie_id FROM movies WHERE title = movie;
	END IF;
	INSERT INTO movie_revenues (movie_id, domestic_revenue, international_revenue)
	VALUES (new_movie_id, domestic_revenue, international_revenue);
EXCEPTION
	WHEN OTHERS THEN 
		RAISE NOTICE 'Something went wrong';
END;
$$;

CALL insert_movie_and_its_revenue('New Sci-Fi Hit', 120000000, 200000000);
-- • Write a transaction to update movie budget and revenue
-- o Update movie budget
-- o Update revenue
-- o Ensure both updates succeed or none
CREATE OR REPLACE PROCEDURE update_movie_budget_and_revenue (
	movie VARCHAR,
	new_budget NUMERIC,
	new_domestic_revenue NUMERIC,
	new_international_revenue NUMERIC
)
LANGUAGE plpgsql
AS $$
DECLARE updated_movie_id INTEGER;
BEGIN 
	SELECT movie_id INTO updated_movie_id
	FROM movies
	WHERE title = movie;
	
	IF updated_movie_id IS NULL THEN
		RAISE NOTICE 'Movie "%" does not exist.', movie;
		RETURN;
	END IF;
	
	UPDATE movies
	SET budget = new_budget
	WHERE movie_id = updated_movie_id;

	IF EXISTS (
		SELECT 1 FROM movie_revenues WHERE movie_id = updated_movie_id
	) THEN
		UPDATE movie_revenues
			SET domestic_revenue = new_domestic_revenue,
				international_revenue = new_international_revenue
			WHERE movie_id = updated_movie_id;
		ELSE
			INSERT INTO movie_revenues (domestic_revenue, international_revenue)
		 	VALUES (new_domestic_revenue, new_international_revenue);
		END IF;
EXCEPTION
	WHEN OTHERS THEN 
		RAISE NOTICE 'Something went wrong';
END;
$$;
CALL update_movie_budget_and_revenue(
	'Inception', 190000000, 310000000, 520000000
);
-- • Create a trigger to update 'created_at' timestamp whenever a new movie is inserted
CREATE OR REPLACE FUNCTION update_timestamp()
RETURNS TRIGGER AS $$
BEGIN
	NEW.created_at := CURRENT_TIMESTAMP;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_created_at_trigger
BEFORE INSERT ON movies
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

INSERT INTO movies (title)
VALUES ('NEW movie');
-- • Create a trigger to prevent inserting movies with release dates in the future
CREATE OR REPLACE FUNCTION prevent_movies_with_future_dates()
RETURNS TRIGGER AS $$
BEGIN 
	IF NEW.release_date > CURRENT_TIMESTAMP THEN
		RAISE EXCEPTION 'Release date cannot be in the future.';
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER prevent_future_release_date
BEFORE INSERT ON movies
FOR EACH ROW
EXECUTE FUNCTION prevent_movies_with_future_dates();
		
INSERT INTO movies (title, release_date)
VALUES ('Future Movie', '2099-01-01');  -- fail
INSERT INTO movies (title, release_date)
VALUES ('Classic Movie', '2010-05-01'); -- succeed
-- • Create a function that returns movie details as a row type
CREATE OR REPLACE FUNCTION movie_details(movie_title VARCHAR)
RETURNS SETOF movies AS $$
BEGIN
	RETURN QUERY
	SELECT * FROM movies
	WHERE title = movie_title
	LIMIT 1;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM movie_details('Inception');
-- • Create a procedure to add a new movie with its genre
CREATE OR REPLACE PROCEDURE add_movie_and_its_genre (
	movie_title VARCHAR,
	movie_genre VARCHAR
)
LANGUAGE plpgsql
AS $$
DECLARE 
	new_movie_id INTEGER;
	new_genre_id INTEGER;
BEGIN
	SELECT g.genre_id INTO new_genre_id FROM genres g WHERE g.name = movie_genre;

	IF new_genre_id IS NULL THEN
		INSERT INTO genres (name)
		VALUES (movie_genre)
		RETURNING genre_id INTO new_genre_id;
	END IF;
	
	SELECT movie_id INTO new_movie_id FROM movies WHERE title = movie_title;
	IF new_movie_id IS NULL THEN
		INSERT INTO movies (title)
		VALUES (movie_title)
		RETURNING movie_id INTO new_movie_id;
	END IF;
 
		IF NOT EXISTS (
		SELECT 1 FROM movie_genres WHERE movie_id = new_movie_id AND genre_id = new_genre_id
	) THEN
		INSERT INTO movie_genres (movie_id, genre_id)
		VALUES (new_movie_id, new_genre_id);
	END IF;
EXCEPTION
	WHEN OTHERS THEN 
		RAISE NOTICE 'Something went wrong';
END;
$$;

CALL add_movie_and_its_genre('The Matrix', 'Sci-Fi');
