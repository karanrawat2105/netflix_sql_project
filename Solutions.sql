-- Netflix Project
DROP TABLE IF EXISTS netflix;
CREATE TABLE Netflix
(
	show_id VARCHAR(6),
	type VARCHAR(10),
	title VARCHAR(150),
	director VARCHAR(208),
	casts VARCHAR(1000),
	country VARCHAR(150),
	date_added VARCHAR(50),
	release_year INT,
	rating VARCHAR(20),
	duration VARCHAR(30),
	listed_in VARCHAR(200),
	description TEXT
);

SELECT * FROM netflix;

SELECT
	COUNT (*) as total_content
FROM netflix;


SELECT
	DISTINCT type
FROM netflix;

SELECT * FROM netflix;

-- 15 Business Problems

-- 1. Count the number of Movies vs TV Shows

SELECT
	type,
	COUNT(*) as total_content
FROM netflix
GROUP BY type

-- 2. Find the most common rating for Movies  and TV Shows

SELECT
	type,
	rating
FROM

(
	SELECT
		type,
		rating,
		COUNT(*),
		RANK () OVER(PARTITION BY type ORDER BY COUNT(*) DESC) as ranking
	FROM netflix
	GROUP BY 1, 2
) as t1
WHERE 
	ranking = 1

-- 3. List all movies released in a specified year (e.g., 2020)

SELECT * FROM netflix
WHERE 
	type = 'Movie'
	AND
	release_year = 2020

-- 4. Find the top 5 countries with the most content on Netflix?

SELECT 
	UNNEST(STRING_TO_ARRAY(country, ',')) as new_country,
	COUNT(show_id) as total_content
FROM netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

SELECT
	UNNEST(STRING_TO_ARRAY(country, ',')) as new_country
FROM netflix

-- 5. Indentify the longest movie or TV show duration?

SELECT * FROM netflix
WHERE
	type = 'Movie'
	AND
	duration = (SELECT MAX(duration) FROM netflix)
	
-- 6. Find cotent added in the last 5 years.

SELECT 
	*
FROM netflix
WHERE 
	TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years'


SELECT CURRENT_DATE - INTERVAL '5 years'

-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

SELECT * FROM netflix
WHERE director ILIKE '%Rajiv Chilaka%'

-- 8. List all the TV shows with more than 5 seasons

SELECT
	*
FROM netflix
WHERE
	type = 'TV Show'
	AND
	SPLIT_PART(duration, ' ', 1)::numeric > 5

-- 9. Count the number of content items in each genre

SELECT 
	UNNEST(STRING_TO_ARRAY(listed_in, ',')) as genre,
	COUNT(show_id) as total_content
FROM netflix
GROUP BY 1

-- 10. Find all contents without a director

SELECT * FROM netflix
WHERE
	director IS NULL

-- 11. Find in how many movies did 'Salman Khan' appeared in last 10 years.

SELECT * FROM netflix
WHERE
	casts ILIKE '%Salman Khan%'
	AND
	release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10 

-- 12. Find the top 10 actors who have appeared in the highest number of movies produced in India.

SELECT 
-- show_id,
-- casts,
UNNEST(STRING_TO_ARRAY(casts, ',')) as actors,
COUNT(*) as total_content
FROM netflix
WHERE country ILIKE '%india%'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10
