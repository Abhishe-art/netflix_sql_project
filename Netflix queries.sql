CREATE TABLE netflix(
show_id VARCHAR (6),
type VARCHAR (20),	
title VARCHAR(150),	
director VARCHAR(250),	
casts VARCHAR (10000),	
country VARCHAR(150),	
date_added VARCHAR(50),	
release_year INT,	
rating  VARCHAR(10),	
duration VARCHAR(15),	
listed_in VARCHAR(150),	
description VARCHAR(250)

);


SELECT count(*) FROM netflix;

SELECT DISTINCT TYPE
FROM netflix;



SELECT * FROM netflix;
-- 15 Busineess Problems & Solutions


1. Count the number of movies vs Tv shows

SELECT 
	type ,
	count(Type) Total_content
FROM netflix
GROUP BY types;


2. Find the most common rating for movies and TV shows

SELECT *
FROM(
SELECT 
	type,
	Rating,
	count(*),
	RANK() OVER(PARTITION BY type ORDER BY count(*) DESC) as Ranking
FROM netflix
GROUP BY 1,2
) t1
WHERE 
	Ranking =1;


3. List all movies released in a specific year (e.g., 2020)

SELECT *
FROM netflix
	WHERE type ='Movie'
	AND 
	release_year = 2020;


4. Find the top 5 countries with the most content on Netflix

SELECT
	UNNEST(STRING_TO_ARRAY(country,',')) AS new_county,
	COUNT(*)
FROM netflix
GROUP BY country 
ORDER BY 2 DESC
LIMIT 5;


5. Identify the longest movie ?

SELECT *
FROM netflix
WHERE 
	type ='movie'
	AND
	duration = (select MAX(duration) FROM netflix);


6. Find content added in the last 5 years

SELECT *
FROM netflix
WHERE 
	To_date(date_added,'month DD YYYY') >=current_date - interval '5 years'


7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

SELECT *
FROM netflix
WHERE director ILIKE '%Rajiv Chilaka%'


8. List all TV shows with more than 5 seasons

SELECT *
	-- SPLIT_PART(duration,' ',1)AS sessions
FROM netflix
WHERE
	type = 'TV Show'
	AND
	SPLIT_PART(duration,' ',1):: numeric > 5 ;




9. Count the number of content items in each genre

SELECT 
	UNNEST(STRING_TO_ARRAY(listed_in,',')) AS genre,
	count(show_id) Total_content
FROM netflix
GROUP BY 1;








10.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!

SELECT 
	EXTRACT (YEAR FROM TO_DATE(date_added,'Month DD,YYYY')) AS date,
	count(*) AS yearly_content,
	Round(
	count(*)::numeric/(SELECT count(*) FROM netflix WHERE country = 'India')::numeric *100
	,2)AS AVG_Content
FROM netflix
WHERE 
	country = 'India'
	GROUP BY 1
;

SELECT * FROM netflix;


11. List all movies that are documentaries

SELECT *
FROM netflix
WHERE 
	listed_in ILIKE '%documentaries%';


12. Find all content without a director

SELECT *
FROM netflix
WHERE 
director is null;



13. Find how many movies actor 'Salman Khan' appeared in last 10 years!

SELECT *
FROM netflix
WHERE 
	casts ILIKE '%Salman Khan%'
	AND 
	release_year > Extract(YEAR FROM CURRENT_DATE) -10 

14.Find the top 10 actors who have appered in the highest numbers of movies produced in India.

SELECT 
	UNNEST(STRING_TO_ARRAY(casts,',')) AS Actors,
	count(*) AS total_content
FROM netflix
WHERE country ILIKE '%India%'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10
;


15. Categorize the content based on the presence of the keywords 'kill' and 'voilance' in the
discription field.label content containing these keywords as 'Bad' and all other
content as 'Good'. count how many items fall into each category.


WITH CTE_table AS 
(
SELECT * ,
case
WHEN
	description ILIKE '%Kill%' 
	or 
	description ILIKE '%violence%' THEN 'Bad'
	Else 'Good'
END AS category
FROM netflix
) 
SELECT 
	category,
	Count(*) AS total_content
FROM CTE_table
GROUP BY category;


