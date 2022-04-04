USE imdb;

show tables;
/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/

-- Segment 1:
select * from role_mapping;
-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT Count(*) AS director_mapping_Row_Count
FROM   director_mapping;

SELECT Count(*) AS genre_Row_Count
FROM   genre;

SELECT Count(*) AS movie_Row_Count
FROM   movie;

SELECT Count(*) AS names_Row_Count
FROM   names;

SELECT Count(*) AS rating_Row_Count
FROM   ratings;

SELECT Count(*) AS role_mapping_Row_Count
FROM   role_mapping;  

/* Number of Rows in each table
director_mapping --> 3867
genre --> 14662
movie --> 7996
Names --> 25735
ratings --> 7997
role_mapping --> 15615
*/

-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT 
	   SUM(CASE WHEN id IS NULL    		 			THEN 1 ELSE 0 END) AS id_nulls,
       SUM(CASE WHEN title IS NULL		 			THEN 1 ELSE 0 END) AS title_nulls,
       SUM(CASE WHEN year IS NULL  		 			THEN 1 ELSE 0 END) AS year_nulls,
       SUM(CASE WHEN date_published IS NULL 		THEN 1 ELSE 0 END) AS date_published_nulls,
	   SUM(CASE WHEN duration IS NULL 	 			THEN 1 ELSE 0 END) AS duration_nulls,
       SUM(CASE WHEN country IS NULL 	 			THEN 1 ELSE 0 END) AS country_nulls,
       SUM(CASE WHEN worlwide_gross_income IS NULL 	THEN 1 ELSE 0 END) AS worlwide_gross_income_nulls,
       SUM(CASE WHEN languages IS NULL 	 			THEN 1 ELSE 0 END) AS languages_nulls,
       SUM(CASE WHEN production_company IS NULL 	THEN 1 ELSE 0 END) AS production_company_nulls
FROM Movie;




/* Movie Null values columns and count
country - 20
worlwide_gross_income - 3724
languages - 194
production_company - 528
*/

-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)
-- Type your code below:

-- Find the total number of movies released each year?

SELECT year,
       Count(id) AS Total_Number_of_Movies
FROM   movie
GROUP  BY year;  

-- How does the trend look month wise?

SELECT Month(date_published) AS Published_Month,
       Count(id)             AS Number_of_movies
FROM   movie
GROUP  BY Month(date_published)
ORDER  BY published_month;  

/*
Find the total number of movies released each year?
+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	3052			|
|	2018		|	2944			|
|	2019		|	2001			|
+---------------+-------------------+

How does the trend look month wise?
+-----------+---------------+
|month_num	|number_of_movies|
+-----------+----------------+
|	1	  	|	804			 |
|	2		|	640			 |
|	3		|	824			 |
|	4		|	680			 |
|	5		|	625			 |	
|	6		|	580		  	 |
|	7		|	493		 	 |
|	8		| 	678			 |
|	9		|	809			 |
|	10		|	801			 |
|	11		|	625			 |
|	12		|	438			 |
+-----------+----------------+ 
*/
      
/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/


-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT  Count(id) AS Number_of_movies_in_USA_INDIA
FROM    movie
WHERE   Lower(country) LIKE 'india%'
        OR country LIKE 'usa%'
		AND year = 2019;  

-- 1675 movies

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT genre
FROM   genre;  

/* The unique list of the genres
Drama
Fantasy
Thriller
Comedy
Horror
Family
Romance
Adventure
Action
Sci-Fi
Crime
Mystery
Others
*/

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT genre,
       Count(movie_id) AS Number_of_Movie
FROM   genre
GROUP  BY genre
order by Number_of_Movie desc;  

/*
Result : Drama - 4285 has highest number of movie produced over all
*/

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH genre_count AS 
(SELECT m.title,
        Count(g.genre) AS Movie_genre_Count
FROM    movie AS m
        INNER JOIN genre  AS g  ON m.id = g.movie_id
GROUP   BY title)

SELECT  Count(*) AS Number_of_Movie_with_One_Genre
FROM    genre_count
WHERE   movie_genre_count = 1;  

/* 
Result :  There are 3245 movies which has only one genre associated with them*/

/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/




-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)
-- Type your code below:

SELECT  g.genre,
        Round(Avg(m.duration), 2) AS avg_duration
FROM    movie AS m
        INNER JOIN genre AS g  ON m.id = g.movie_id
GROUP  BY genre
ORDER  BY avg_duration DESC;  

/* Result
Genre		Avg_duration
Action		112.88
Romance		109.53
Crime		107.05
Drama		106.77
Fantasy		105.14
Comedy		102.62
Adventure	101.87
Mystery		101.80
Thriller	101.58
Family		100.97
Others		100.16
Sci-Fi		97.94
Horror		92.72
*/

/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/


-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)
-- Type your code below:

WITH genre_rank AS 
(SELECT genre,
        Count(movie_id)   AS movie_count,
        RANK() OVER (ORDER BY Count(movie_id) DESC) AS genre_rank
 FROM   genre
 GROUP  BY genre)

SELECT genre,
       movie_count,
       genre_rank
FROM   genre_rank
WHERE  genre = 'Thriller'; 

/* Result:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|Thriller		|	1484			|			3		  |
+---------------+-------------------+---------------------+*/


/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/


-- Segment 2:

-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
-- Type your code below:

 SELECT Min(avg_rating)    AS min_avg_rating,
        Max(avg_rating)    AS max_avg_rating,
        Min(total_votes)   AS min_total_votes,
        Max(total_votes)   AS max_total_votes,
        Min(median_rating) AS min_median_rating,
        Max(median_rating) AS min_median_rating
FROM   ratings;  

/* Result:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		1.0		|			10.0	|	       100		  |	   725138	    	 |		1	       |	10			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/


/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/


-- Q11. Which are the top 10 movies based on average rating?
/*
Type your code below:
It's ok if RANK() or DENSE_RANK() is used too
*/

SELECT     m.title,
           r.avg_rating,
           DENSE_RANK() OVER (ORDER BY avg_rating DESC) AS movie_rank
FROM       movie AS m
           INNER JOIN  ratings  AS r  ON m.id = r.movie_id limit 10; 


/* Result:
Title							Avg_rating	Movie_rank
Kirket								10.0		1
Love in Kilnerry					10.0		1
Gini Helida Kathe					9.8			2
Runam								9.7			3
Fan									9.6			4
Android Kunjappan Version 5.25		9.6			4
Yeh Suhaagraat Impossible			9.5			5
Safe								9.5			5
The Brighton Miracle				9.5			5
Shibu								9.4			6
*/
/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/


-- Q12. Summarise the ratings table based on the movie counts by median ratings.
-- Type your code below:
-- Order by is good to have

SELECT median_rating,
       Count(movie_id) AS movie_count
FROM   ratings
GROUP  BY median_rating
ORDER  BY median_rating;  

/* Result:
median_rating	movie_count		
	1				94
	2				119
	3				283
	4				479
	5				985
	6				1975
	7				2257
	8				1030
	9				429
	10				346
*/



/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
-- Type your code below:

SELECT  m.production_company,
        Count(m.id) AS movie_count,
        DENSE_RANK() OVER( ORDER BY Count(m.id) DESC) AS prod_company_rank
FROM    movie AS m
        INNER JOIN ratings  AS r   ON m.id = r.movie_id
WHERE   r.avg_rating > 8
GROUP  BY m.production_company;


/* Result:
production_company		movie_count	 prod_company_rank
Dream Warrior Pictures		3		 		2
National Theatre Live		3				2
*/


-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
-- Type your code below:

WITH movie_summary AS 
(SELECT  g.genre,
         Month(m.date_published) AS Release_Month,
         m.year,
         m.country,
         r.total_votes
 FROM    genre AS g
         INNER JOIN movie    AS m  ON g.movie_id = m.id
         INNER JOIN ratings  AS r  ON m.id = r.movie_id)

SELECT genre,
       Count(genre) AS movie_count
FROM   movie_summary
WHERE  release_month = 3
       AND Lower(country) LIKE '%usa%'
       AND year = 2017
       AND total_votes > 1000
GROUP  BY genre; 


/* result:
genre	movie_count
Action		8
Comedy		9
Crime		6
Drama		24
Sci-Fi		7
Fantasy		3
Mystery		4
Romance		4
Thriller	8
Adventure	3
Horror		6
Family		1
*/

-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
-- Type your code below:

SELECT title,
       avg_rating,
       genre
FROM   movie AS m
       INNER JOIN  ratings   AS r  ON  r.movie_id = m.id
       INNER JOIN  genre     AS g  ON  g.movie_id = m.id
WHERE  Lower(title) LIKE 'the%'
       AND avg_rating > 8
GROUP  BY genre
ORDER  BY avg_rating DESC;


/* Result:
title						avg_rating	genre	      
The Blue Elephant 2				8.8		Drama
The Blue Elephant 2				8.8		Horror
The Blue Elephant 2				8.8		Mystery
The Irishman					8.7		Crime
Theeran Adhigaaram Ondru		8.3		Action
Theeran Adhigaaram Ondru		8.3		Thriller
The King and I					8.2		Romance
*/

-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT      COUNT(title) AS movie_count
FROM 		movie AS m
            INNER JOIN ratings AS r ON  m.id=r.movie_id
WHERE 		median_rating=8
			AND date_published BETWEEN "2018-04-01" AND "2019-04-01";

-- Result - 361 Movies


-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

WITH votes_germany AS 
(SELECT Sum(total_votes) AS Germany_Total_Votes
 FROM   movie AS m
        INNER JOIN 	ratings  AS r 	ON  m.id = r.movie_id
 WHERE  Lower(country) 		LIKE '%germany%'),
 
votes_italy AS 
(SELECT Sum(total_votes) AS Italy_Total_Votes
 FROM   movie AS m
        INNER JOIN 		ratings 	AS r 	ON m.id = r.movie_id
 WHERE  Lower(country)  LIKE '%italy%')
 
SELECT *
FROM   votes_germany,
       votes_italy;  

-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/

-- Segment 3:

-- Q18. Which columns in the names table have null values??
-- Type your code below:

SELECT SUM(CASE WHEN name             IS NULL 	THEN 1 ELSE 0 END) AS name_nulls,
	   SUM(CASE WHEN height 		  IS NULL 	THEN 1 ELSE 0 END) AS height_nulls,
       SUM(CASE WHEN date_of_birth	  IS NULL 	THEN 1 ELSE 0 END) AS date_of_birth_nulls,
       SUM(CASE WHEN known_for_movies IS NULL 	THEN 1 ELSE 0 END) AS known_for_movies_nulls
FROM names;

/* Result
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			17335	|	       13431	  |	   15226	    	 |
+---------------+-------------------+---------------------+----------------------+*/


/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/


-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)

-- Type your code below:

WITH genre_selection AS(
WITH top_genre AS(
SELECT 		genre, 
			COUNT(title) AS movie_count,
		    RANK() OVER(ORDER BY COUNT(title) DESC) AS genre_rank
FROM 		movie AS m
			INNER JOIN ratings   AS r 	ON r.movie_id=m.id
			INNER JOIN genre     AS g 	ON g.movie_id=m.id
WHERE avg_rating>8
GROUP BY genre)

SELECT genre
FROM top_genre
WHERE genre_rank<4),
-- top 3 ranked genres have been identified. We will use these in the following query 
top_directors AS(
SELECT   n.name AS director_name, 
		 COUNT(g.movie_id) AS movie_count,
         RANK() OVER( ORDER BY COUNT(g.movie_id) DESC) AS director_rank
FROM 	 names AS n
		 INNER JOIN  director_mapping AS dm 	ON n.id=dm.name_id
		 INNER JOIN  genre 			  AS g 	  	ON dm.movie_id=g.movie_id
		 INNER JOIN  ratings 		  AS r		ON r.movie_id=g.movie_id ,
	     genre_selection
WHERE g.genre IN (genre_selection.genre) AND avg_rating>8
GROUP BY director_name
ORDER BY movie_count DESC)
SELECT *
FROM   top_directors
WHERE  director_rank<=3;

/* Output format:
director_name	movie_count		rank
James Mangold		4			1
Anthony Russo		3			2
Joe Russo			3			2
Soubin Shahir		3			2
 */


/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/


-- Q20. Who are the top two actors whose movies have a median rating >= 8?
-- Type your code below:
 WITH actor_ranking AS 
(SELECT n.NAME AS actor_name,
        Count(r.movie_id) AS movie_count,
        RANK() OVER ( ORDER BY Count(r.movie_id) DESC) AS Actor_rank
 FROM   names AS n
        INNER JOIN  role_mapping  AS rm   ON n.id = rm.name_id
        INNER JOIN  ratings 	  AS r    ON r.movie_id = rm.movie_id
WHERE  r.median_rating >= 8
GROUP  BY n.NAME)

SELECT actor_name,
       movie_count
FROM   actor_ranking
WHERE  actor_rank < 3;  


/* Result:
actor_name	movie_count
Mammootty		8
Mohanlal		5
*/


/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
-- Type your code below:

WITH ranking AS(
SELECT   production_company, 
		 SUM(total_votes) As vote_count,
         RANK() OVER(ORDER BY SUM(total_votes) DESC) AS prod_comp_rank
FROM 	 movie AS m
         INNER JOIN  ratings  AS r  ON r.movie_id=m.id
GROUP BY production_company)

SELECT production_company, vote_count, prod_comp_rank
FROM ranking
WHERE prod_comp_rank<4;

/* Output format:
production_company		vote_count	prod_comp_rank
Marvel Studios			2656967			1
Twentieth Century Fox	2411163			2
Warner Bros.			2396057			3
*/


/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
-- Type your code below:
SELECT 
		  name AS actor_name, 
          SUM(total_votes) AS total_votes, 
          COUNT(m.id) AS movie_count,
          ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),1) AS actor_avg_rating,
          RANK() OVER (ORDER BY ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),1) DESC) AS actor_rank
FROM 
		movie AS m
		INNER JOIN   ratings       AS r   ON m.id=r.movie_id
		INNER JOIN   role_mapping  AS rm  ON m.id=rm.movie_id
        INNER JOIN   names 		   AS n   ON rm.name_id=n.id 
WHERE   lower(category) = 'actor' 
		AND lower(country) like '%india%'
GROUP BY name
HAVING COUNT(m.id)>=5;

/* Output format:
actor_name		total_votes 	movie_count 	actor_avg_rating	actor_rank
Vijay Sethupathi	23114	 		5				8.4					1
*/

-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
-- Type your code below:

WITH ranking AS(
SELECT 	
		name AS actress_name, 
        SUM(total_votes) AS total_votes, 
        COUNT(m.id) AS movie_count,
        ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) AS actress_avg_rating,
        RANK() OVER(ORDER BY ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) DESC) AS actress_rank
FROM 	 movie AS m
		 INNER JOIN    ratings       AS r    ON m.id=r.movie_id
         INNER JOIN    role_mapping  AS rm   ON m.id=rm.movie_id
         INNER JOIN    names         AS n    ON rm.name_id=n.id
WHERE 	lower(category) = 'actress' 
		AND lower(country) like '%india%' 
        AND lower(languages) like '%hindi%'
GROUP BY name
HAVING COUNT(m.id)>=3)
SELECT *
FROM ranking
WHERE actress_rank<=5;

/* result:
actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank
Taapsee Pannu	18061						3						7.74					1
*/


/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

WITH thriller_movies AS(
SELECT	  title, 
		  avg_rating
FROM 	  genre   AS g
          INNER JOIN  movie   AS m   ON g.movie_id=m.id
          INNER JOIN  ratings AS r   ON m.id=r.movie_id
WHERE lower(genre)= 'thriller')
SELECT 	*,
	   (CASE
		WHEN avg_rating > 8   THEN   'Superhit movie'
		WHEN avg_rating >=7   AND    avg_rating <= 8   THEN  'Hit movie'
        WHEN avg_rating >=5.0 AND    avg_rating < 7    THEN  'One time watch movie'
		WHEN avg_rating <5.0  THEN   'Flop movie'      END) AS category
FROM thriller_movies
ORDER BY avg_rating DESC;

/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
-- Type your code below:

SELECT	genre, 
		ROUND(AVG(duration),2) AS avg_duration,
		SUM(AVG(duration)) OVER(ORDER BY genre ROWS UNBOUNDED PRECEDING) AS running_total_duration,
		AVG(AVG(duration)) OVER(ORDER BY genre ROWS 13 PRECEDING) AS moving_avg_duration
FROM 	movie AS m 
		INNER JOIN 
        genre AS g 
        ON m.id= g.movie_id
GROUP BY genre
ORDER BY genre;


/* result:
genre	avg_duration	running_total_duration	moving_avg_duration
Action		112.88			112.8829			112.8829
Adventure	101.87			214.7543			107.37715
Comedy		102.62			317.377				105.7923333
Crime		107.05			424.4287			106.107175
Drama		106.77			531.2033			106.24066
Family		100.97			632.1702			105.3617
Fantasy		105.14			737.3106			105.3300857
Horror		92.72			830.0349			103.7543625
Mystery		101.8			931.8349			103.5372111
Others		100.16			1031.9949			103.19949
Romance		109.53			1141.5291			103.7753727
Sci-Fi		97.94			1239.4704			103.2892
Thriller	101.58			1341.0465			103.1574231
*/


-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)
-- Type your code below:

-- Top 3 Genres based on most number of movies

 WITH genre_selection AS
( SELECT   genre,
           Count(movie_id) AS count_of_moives
  FROM     genre
  GROUP BY genre
  ORDER BY count_of_moives DESC limit 3 ),
-- top three genres have been identified. Now we will use these to find the top 5 movies as required.
top_five AS
( SELECT   genre,
           year,          
		   title AS movie_name,
           Cast(SUBSTRING_INDEX(worlwide_gross_income," ",-1) AS DECIMAL) AS worlwide_gross_income,
           RANK() OVER (partition BY year ORDER BY Cast(SUBSTRING_INDEX(worlwide_gross_income," ",-1) AS DECIMAL) DESC) AS movie_rank
FROM       movie   AS m
           INNER JOIN  genre   AS g  ON m.id= g.movie_id
 WHERE     genre IN ( SELECT genre
                      FROM   genre_selection) )
SELECT     *
FROM       top_five
WHERE      movie_rank<=5
ORDER BY   year;


/* Output format:
genre		year	movie_name						worlwide_gross_income	movie_rank
Thriller	2017	The Fate of the Furious			1236005118					1
Comedy		2017	Despicable Me 3					1034799409					2
Comedy		2017	Jumanji: Welcome to the Jungle	962102237					3
Drama		2017	Zhan lang II					870325439					4
Thriller	2017	Zhan lang II					870325439					4
Thriller	2018	The Villain						1300000000					1
Drama		2018	Bohemian Rhapsody				903655259					2
Thriller	2018	Venom							856085151					3
Thriller	2018	Mission: Impossible - Fallout	791115104					4
Comedy		2018	Deadpool 2						785046920					5
Drama		2019	Avengers: Endgame				2797800564					1
Drama		2019	The Lion King					1655156910					2
Comedy		2019	Toy Story 4						1073168585					3
Drama		2019	Joker							995064593					4
Thriller	2019	Joker							995064593					4
*/





-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
-- Type your code below:

WITH ranking AS(
SELECT 	production_company,
		COUNT(m.id) AS movie_count,
		RANK() OVER(ORDER BY COUNT(id) DESC) AS prod_comp_rank
        
FROM 	movie AS m 
		INNER JOIN  ratings  AS r   ON m.id=r.movie_id
        
WHERE 	median_rating>=8 
		AND production_company IS NOT NULL 
        AND POSITION(',' IN languages)>0
        
GROUP BY production_company)
SELECT *
FROM ranking
WHERE prod_comp_rank<3;

/* Result:
+-----------------------+-------------------+---------------------+
|production_company     |movie_count		|		prod_comp_rank|
+-----------------------+-------------------+---------------------+
| Star Cinema		    |		7			|		1	  		  |
|Twentieth Century Fox	|		4			|		2			  |
+-----------------------+-------------------+---------------------+*/




-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
-- Type your code below:

WITH ranking AS(
SELECT  name AS actress_name, 
		SUM(total_votes) AS total_votes, 
		COUNT(m.id) AS movie_count,
		ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) AS actress_avg_rating,
		rank() OVER(ORDER BY COUNT(m.id) DESC) AS actress_rank
FROM 
	genre				    AS g 
	INNER JOIN movie	 	AS m	 ON g.movie_id= m.id 
	INNER JOIN ratings 		AS r 	 ON m.id= r.movie_id 
	INNER JOIN role_mapping AS rm	 ON m.id=rm.movie_id 
	INNER JOIN names 		AS n	 ON rm.name_id=n.id
WHERE genre= 'drama' AND category= 'actress' AND avg_rating>8
GROUP BY name)
SELECT * 
FROM ranking
WHERE actress_rank<=3;

/* Result:
actress_name				total_votes		movie_count	actress_avg_rating	actress_rank
Parvathy Thiruvothu				4974			2			8.25				1
Susan Brown						656				2			8.94				1
Amanda Lawrence					656				2			8.94				1
Denise Gough					656				2			8.94				1
*/


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
--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH top_directors AS
(
SELECT  name_id AS director_id, 
		name    AS director_name, 
        dir.movie_id, 
        duration,
		avg_rating  AS avg_rating, 
        total_votes AS total_votes, 
        avg_rating * total_votes AS rating_count,
		date_published,
		LEAD(date_published, 1) OVER (PARTITION BY name ORDER BY date_published, name) AS next_publish_date
FROM 
	director_mapping      AS dir
	INNER JOIN names 	  AS nm  ON dir.name_id = nm.id
	INNER JOIN movie	  AS mov ON dir.movie_id = mov.id 
	INNER JOIN ratings 	  AS rt  ON mov.id = rt.movie_id
)

SELECT  director_id, 
		director_name,
        COUNT(movie_id)  AS number_of_movies,
        ROUND(SUM(DATEDIFF(Next_publish_date, date_published))/COUNT(movie_id)) AS avg_inter_movie_days,
        CAST(SUM(rating_count)/SUM(total_votes) AS DECIMAL(4,2)) AS avg_rating,
        SUM(total_votes) AS total_votes, 
        MIN(avg_rating)  AS min_rating, 
        MAX(avg_Rating)  AS max_rating,
        SUM(duration)    AS total_duration
FROM     top_directors
GROUP BY director_id
ORDER BY number_of_movies DESC
LIMIT 9;

/*
Result:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
nm1777967			A.L. Vijay					5					141					5.65			1754		3.7				6.9			613
nm2096009			Andrew Jones				5					153					3.04			1989		2.7				3.2			432
nm0425364			Jesse V. Johnson			4					224					6.10			14778		4.2				6.5			383
nm2691863			Justin Price				4					236					4.93			5343		3.0				5.8			346
nm0001752			Steven Soderbergh			4					191					6.77			171684		6.2				7.0			401
nm6356309			Özgür Bakar					4					84					3.96			1092		3.1				4.9			374
nm0515005			Sam Liu						4					195					6.32			28557		5.8				6.7			312
nm0814469			Sion Sono					4					248					6.31			2972		5.4				6.4			502
nm0831321			Chris Stokes				4					149					4.32			3664		4.0				4.6			352
*/



