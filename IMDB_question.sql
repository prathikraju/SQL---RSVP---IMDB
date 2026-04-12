USE imdb;

-- test

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT 
	TABLE_NAME, 
    TABLE_ROWS 
FROM 
	INFORMATION_SCHEMA.tables
WHERE
	TABLE_SCHEMA = "IMDB";
    
SELECT 
	*
FROM
	INFORMATION_SCHEMA.columns
WHERE 
	TABLE_NAME = "MOVIE";
    
DESC MOVIE;

SHOW TABLES;









-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT 
	SUM(CASE WHEN ID IS NULL THEN 1 ELSE 0 END) AS "ID MISSING",
    SUM(CASE WHEN TITLE IS NULL THEN 1 ELSE 0 END) AS "TITLE MISSING",
    SUM(CASE WHEN YEAR IS NULL THEN 1 ELSE 0 END) AS "YEAR MISSING",
    SUM(CASE WHEN DATE_PUBLISHED IS NULL THEN 1 ELSE 0 END) AS "DATE_PUBLISHED MISSING",
    SUM(CASE WHEN DURATION IS NULL THEN 1 ELSE 0 END) AS "DURATION MISSING",
    SUM(CASE WHEN COUNTRY IS NULL THEN 1 ELSE 0 END) AS "COUNTRY MISSING",
	SUM(CASE WHEN WORLWIDE_GROSS_INCOME IS NULL THEN 1 ELSE 0 END) AS "WORLDWIDE_GROSS_INCOME MISSING",
	SUM(CASE WHEN LANGUAGES IS NULL THEN 1 ELSE 0 END) AS "LANGUAGES MISSING",
	SUM(CASE WHEN PRODUCTION_COMPANY IS NULL THEN 1 ELSE 0 END) AS "PRODUCTION_COMPANY MISSING"
FROM
	MOVIE;








-- Now as you can see four columns of the movie table has null values. Let's look at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
	YEAR,
	COUNT(ID)
FROM 
	MOVIE
GROUP BY 
	YEAR
ORDER BY
	YEAR ASC;

SELECT 
	MONTH(DATE_PUBLISHED) AS "MONTH",
	COUNT(ID)
FROM 
	MOVIE
GROUP BY 
	MONTH
ORDER BY
	COUNT(ID) DESC;
    







/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT 
	COUNTRY,
    COUNT(ID)
FROM 
	MOVIE
WHERE 
	YEAR = "2019"
AND
	(COUNTRY LIKE "%USA%" 
    OR
    COUNTRY LIKE "%INDIA%")
GROUP BY 
	COUNTRY;

SELECT 
	CASE 
		WHEN COUNTRY LIKE "%USA%" THEN "USA"
        WHEN COUNTRY LIKE "%INDIA%" THEN "INDIA"
		ELSE "OTHER"
	END AS "COUNTRY_GROUP",
    COUNT(ID)
FROM 
	MOVIE
WHERE 
	YEAR = "2019"
AND
	(COUNTRY LIKE "%USA%" OR COUNTRY LIKE "%INDIA%")
GROUP BY 
	COUNTRY_GROUP;










/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT 
	DISTINCT(GENRE)
FROM
	GENRE;
	











/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT 
	G.GENRE,
    COUNT(M.ID) AS "COUNT"
FROM 
	MOVIE M
JOIN 
	GENRE G
ON 
	M.ID = G.MOVIE_ID
GROUP BY 
	G.GENRE
ORDER BY 
	COUNT DESC;










/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:


SELECT COUNT(*) FROM (SELECT 
    G.MOVIE_ID,
    COUNT(G.MOVIE_ID)
FROM 
	MOVIE M
JOIN 
	GENRE G
ON 
	M.ID = G.MOVIE_ID
GROUP BY 
    G.MOVIE_ID
HAVING 
	COUNT(G.MOVIE_ID) = 1) AS A;
    
    
    
SELECT COUNT(DISTINCT(MOVIE_ID)) FROM GENRE;







/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
	G.GENRE,
	AVG(M.DURATION) AS "AVERAGE"
FROM 
	MOVIE M
JOIN 
	GENRE G
ON 
	M.ID = G.MOVIE_ID
GROUP BY 
    G.GENRE
ORDER BY 
	AVERAGE DESC;
	









/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT 
	G.GENRE,
	RANK() OVER (
        ORDER BY count(MOVIE_ID) DESC)
FROM 
	MOVIE M
JOIN 
	GENRE G
ON 
	M.ID = G.MOVIE_ID
GROUP BY 
    G.GENRE;








/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT 
	MIN(avg_rating) AS MIN_avg_rating,
    MAX(avg_rating) AS MAX_avg_rating,
    MIN(total_votes) AS MIN_total_votes ,
    MAX(total_votes) AS MAX_total_votes,
    MIN(median_rating) AS MIN_median_rating,
    MAX(median_rating) AS MAX_median_rating
FROM 
	RATINGS;






    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- Keep in mind that multiple movies can be at the same rank. You only have to find out the top 10 movies (if there are more than one movies at the 10th place, consider them all.)

SELECT * FROM (SELECT 
	M.TITLE, 
    R.AVG_RATING, 
    DENSE_RANK() OVER(
		ORDER BY R.AVG_RATING DESC) AS MOVIE_RANK
FROM 
	MOVIE M
JOIN 
	RATINGS R
ON 
	M.ID = R.MOVIE_ID) AS A
WHERE 
    MOVIE_RANK < 11;
    

    
WITH A AS
(
SELECT 
	M.TITLE, 
    R.AVG_RATING, 
    DENSE_RANK() OVER(
		ORDER BY R.AVG_RATING DESC) AS MOVIE_RANK
FROM 
	MOVIE M
JOIN 
	RATINGS R
ON 
	M.ID = R.MOVIE_ID)

SELECT 
	* 
FROM 
	A
WHERE A.MOVIE_RANK < 11;
	






/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT 
	median_rating,
    COUNT(MOVIE_ID) AS MOVIE_COUNT
FROM 
	RATINGS
GROUP BY 
	median_rating
ORDER BY 
	median_rating ASC;
	










/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:


SELECT
	M.production_company,
    COUNT(*) AS movie_count,
    RANK() OVER(
		ORDER BY  COUNT(*) DESC) AS prod_company_rank
FROM 
	MOVIE M 
JOIN
	RATINGS R 
ON 
	M.ID = R.MOVIE_ID
WHERE 
	AVG_RATING > 8
AND 
	production_company IS NOT NULL
GROUP BY 
	production_company;

        






-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
	GENRE,
    COUNT(ID) MOVIE_COUNT
FROM 
	MOVIE M
JOIN 
	GENRE G
ON 
	M.ID = G.MOVIE_ID
JOIN
	RATINGS R
ON 	
	M.ID = R.MOVIE_ID
WHERE 
	(DATE_PUBLISHED BETWEEN "2017/03/01" AND "2017/03/31")
AND 
	TOTAL_VOTES > 1000
AND 
	COUNTRY LIKE "%USA%"
GROUP BY 
	GENRE
ORDER BY 
	MOVIE_COUNT DESC;
	







-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT 
	M.TITLE,
    R.AVG_RATING,
    R.MEDIAN_RATING,
    G.GENRE
FROM 
	MOVIE M
JOIN 
	GENRE G
ON 
	M.ID = G.MOVIE_ID
JOIN
	RATINGS R
ON 	
	M.ID = R.MOVIE_ID
WHERE 
	R.AVG_RATING > 8
AND 
	M.TITLE LIKE "THE%"
ORDER BY	
	R.AVG_RATING;







-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Number Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT 
	COUNT(*) AS "NUMBER OF MOVIES"
FROM 
	MOVIE M
JOIN
	RATINGS R
ON 	
	M.ID = R.MOVIE_ID
WHERE 
	(DATE_PUBLISHED BETWEEN "2018/04/01" AND "2019/04/01")
AND
	R.MEDIAN_RATING = 8
ORDER BY 
	M.TITLE;







-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT
	 CASE 
		#WHEN LANGUAGES LIKE "%GERMAN%" AND LANGUAGES LIKE "%ITALIAN%" THEN "BOTH" 
        WHEN LANGUAGES LIKE "%ITALIAN%" THEN "ITALIAN" 
		WHEN LANGUAGES LIKE "%GERMAN%" THEN "GERMAN"
        ELSE "OTHER"
     END AS "GRP",
    SUM(TOTAL_VOTES) AS "TOTAL_VOTES"
FROM 
	MOVIE M
JOIN
	RATINGS R
ON 	
	M.ID = R.MOVIE_ID
WHERE 
	LANGUAGES LIKE "%GERMAN%"
OR
    LANGUAGES LIKE "%ITALIAN%"
#	(LANGUAGES LIKE "%ITALIAN%" AND LANGUAGES LIKE "%GERMAN%")
GROUP BY 
	GRP;
    
    
SELECT DISTINCT(LANGUAGES)
FROM MOVIE;
	





-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT
	SUM(CASE WHEN NAME IS NULL THEN 1 ELSE 0 END),
    SUM(CASE WHEN HEIGHT IS NULL THEN 1 ELSE 0 END),
    SUM(CASE WHEN DATE_OF_BIRTH IS NULL THEN 1 ELSE 0 END),
    SUM(CASE WHEN KNOWN_FOR_MOVIES IS NULL THEN 1 ELSE 0 END)
FROM 
	NAMES;

SELECT
	SUM(NAME IS NULL),
    SUM(HEIGHT IS NULL),
    SUM(DATE_OF_BIRTH IS NULL),
    SUM(KNOWN_FOR_MOVIES IS NULL)
FROM 
	NAMES;
    
    
SELECT
	COUNT(*) - COUNT(NAME),
    COUNT(*) - COUNT(HEIGHT),
    COUNT(*) - COUNT(DATE_OF_BIRTH),
    COUNT(*) - COUNT(KNOWN_FOR_MOVIES)
FROM 
	NAMES;





/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:






WITH TOP_GENRE AS (SELECT
	GENRE,
    COUNT(DISTINCT(G.MOVIE_ID)) AS "COUNT"
FROM 
	GENRE G
JOIN
	 RATINGS R ON G.MOVIE_ID = R.MOVIE_ID
WHERE 
	AVG_RATING > 8
GROUP BY 
	GENRE
ORDER BY 
	COUNT(G.MOVIE_ID) DESC
LIMIT 3)


SELECT
	N.NAME AS DIRECTOR_NAME,
	COUNT(DISTINCT(M.ID)) AS "MOVIE_COUNT"
FROM 
	MOVIE M 
JOIN 	
	DIRECTOR_MAPPING D ON M.ID = D.MOVIE_ID
JOIN 
	NAMES N ON D.NAME_ID = N.ID
JOIN
	RATINGS R ON M.ID = R.MOVIE_ID 
JOIN
	GENRE G ON M.ID = G.MOVIE_ID
JOIN 
	TOP_GENRE TG ON G.GENRE = TG.GENRE
WHERE 
	AVG_RATING > 8
GROUP BY 
	N.NAME
ORDER BY 
	COUNT(M.ID) DESC,
    N.NAME
LIMIT 25;






SELECT
	N.NAME AS DIRECTOR_NAME,
	COUNT(DISTINCT(M.ID)) AS MOVIE_COUNT
FROM 
	MOVIE M 
JOIN 	
	DIRECTOR_MAPPING D ON M.ID = D.MOVIE_ID
JOIN 
	NAMES N ON D.NAME_ID = N.ID
JOIN
	GENRE G ON M.ID = G.MOVIE_ID
JOIN
	RATINGS R ON M.ID = R.MOVIE_ID
WHERE
	AVG_RATING > 8
GROUP BY 
	N.NAME
ORDER BY
	COUNT(M.ID) DESC
LIMIT 3;
	
    

SELECT
	N.NAME AS DIRECTOR_NAME,
    TITLE,
    AVG_RATING
FROM 
	MOVIE M 
JOIN 	
	DIRECTOR_MAPPING D ON M.ID = D.MOVIE_ID
JOIN 
	NAMES N ON D.NAME_ID = N.ID
JOIN
	GENRE G ON M.ID = G.MOVIE_ID
JOIN
	RATINGS R ON M.ID = R.MOVIE_ID
WHERE
	AVG_RATING > 8
AND 
	N.NAME IN ('Anthony Russo', 'Joe Russo', 'James Mangold');
    















/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/




SELECT TITLE FROM MOVIE
WHERE TITLE LIKE "T%"
ORDER BY TITLE;





SELECT
	N.NAME AS DIRECTOR_NAME,
	TITLE
FROM 
	MOVIE M 
JOIN 	
	DIRECTOR_MAPPING D ON M.ID = D.MOVIE_ID
JOIN 
	NAMES N ON D.NAME_ID = N.ID
JOIN
	GENRE G ON M.ID = G.MOVIE_ID
JOIN
	RATINGS R ON M.ID = R.MOVIE_ID
WHERE
	UPPER(TITLE) LIKE "THE WOLVERINE";






-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


SELECT * FROM ROLE_MAPPING;


SELECT
	N.NAME AS ACTOR_NAME,
	COUNT(DISTINCT(M.ID)) AS "MOVIE_COUNT"
FROM 
	MOVIE M 
JOIN 	
	ROLE_MAPPING D ON M.ID = D.MOVIE_ID
JOIN 
	NAMES N ON D.NAME_ID = N.ID
JOIN
	RATINGS R ON M.ID = R.MOVIE_ID 
WHERE 
	MEDIAN_RATING >= 8
AND 
	CATEGORY = "ACTOR"
GROUP BY 
	N.NAME
ORDER BY 
	COUNT(M.ID) DESC
LIMIT 25;











/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:










/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:









-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:









/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Consider thriller movies having at least 25,000 votes. Classify them according to their average ratings in
   the following categories:  

			Rating > 8: Superhit
			Rating between 7 and 8: Hit
			Rating between 5 and 7: One-time-watch
			Rating < 5: Flop
	
    Note: Sort the output by average ratings (desc).
--------------------------------------------------------------------------------------------*/
/* Output format:
+---------------+-------------------+
| movie_name	|	movie_category	|
+---------------+-------------------+
|	Get Out		|			Hit		|
|		.		|			.		|
|		.		|			.		|
+---------------+-------------------+*/

-- Type your code below:









/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:









-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies










-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:








-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on the number of Super Hit movies (Superhit movie: average rating of movie > 8) in 'drama' genre?

-- Note: Consider only superhit movies to calculate the actress average ratings.
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes
-- should act as the tie breaker. If number of votes are same, sort alphabetically by actress name.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	  actress_avg_rating |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.6000		     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/

-- Type your code below:








/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:







