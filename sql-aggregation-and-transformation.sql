use sakila;
-- Imagine you work at a movie rental company as an analyst. 
-- By using SQL in the challenges below, you are required to gain insights into different elements of its business operations.

-- Challenge 1
-- You need to use SQL built-in functions to gain insights relating to the duration of movies:
-- 1.1 Determine the shortest and longest movie durations and name the values as max_duration and min_duration.
	
    SELECT MAX(length) AS max_duration, MIN(length) AS min_duration
	FROM film;


-- 1.2 Express the average movie duration in hours and minutes. Don't use decimals.
-- Hint: Look for floor and round functions. 
	
    SELECT title, length, CONCAT(FLOOR(length/60),':',FLOOR((length%60))) AS duration FROM film;


-- 2 You need to gain insights related to rental dates:
-- 2.1 Calculate the number of days that the company has been operating.
-- Hint: To do this, use the rental table, and the DATEDIFF() function to subtract the earliest date in the rental_date column from the latest date.
	
    SELECT date_format(convert(left(max(rental_date),9),date),'%d-%m-%y') as 'Last rent',
	date_format(convert(left(min(rental_date),9),date),'%d-%m-%y') as 'Openning' ,
	datediff(MAX(rental_date),min(rental_date)) as 'Days in the market'
	FROM rental;


-- 2.2 Retrieve rental information and add two additional columns to show the month and weekday of the rental. Return 20 rows of results.
	
    SELECT *, dayname(rental_date) as weekday,monthname(rental_date) as month 
	FROM rental
	ORDER BY rental_date desc
	LIMIT 20;


-- 2.3 Bonus: 
-- Retrieve rental information and add an additional column called DAY_TYPE with values 'weekend' or 'workday', depending on the day of the week.
-- Hint: use a conditional expression.
	
    SELECT *, dayname(rental_date) as weekday,
    CASE
		WHEN dayname(rental_date)='sunday' OR 'saturday' THEN 'weekend'
        else 'workday'
	END as DAY_TYPE
	FROM rental
	ORDER BY rental_date desc
	LIMIT 20;
    
    
-- 3. You need to ensure that customers can easily access information about the movie collection.
-- To achieve this, retrieve the film titles and their rental duration.
-- If any rental duration value is NULL, replace it with the string 'Not Available'.
-- Sort the results of the film title in ascending order.
-- Please note that even if there are currently no null values in the rental duration column, the query should still be written to handle such cases in the future.
-- Hint: Look for the IFNULL() function.
	
    SELECT title,rental_rate,
	CASE
		WHEN rental_rate IS NULL THEN 'Not Available' 
		ELSE 'Available' 
	END AS 'RENTAL DURATION', rental_duration AS 'DURATION'
	from film
	order by title asc;


-- 4. Bonus: The marketing team for the movie rental company now needs to create a personalized email campaign for customers.
-- To achieve this, you need to retrieve the concatenated first and last names of customers,
-- along with the first 3 characters of their email address, so that you can address them by their first name and use their email address to send personalized recommendations.
-- The results should be ordered by last name in ascending order to make it easier to use the data.
	
    SELECT *, concat(first_name,', ',last_name) AS NAME, LEFT(email,3) AS EMAIL
    FROM customer
    ORDER BY last_name asc; 

-- Challenge 2
-- 1. Next, you need to analyze the films in the collection to gain some more insights. Using the film table, determine:
-- 1.1 The total number of films that have been released.
	
    SELECT count(*) AS 'Quantity of films released'
	FROM film;


-- 1.2 The number of films for each rating.
	SELECT rating,count(*) as 'Films'
	FROM film 
	GROUP BY rating;


-- 1.3 The number of films for each rating, sorting the results in descending order of the number of films.
-- This will help you to better understand the popularity of different film ratings and adjust purchasing decisions accordingly.
	
    select rating,count(*) as 'Films'
	FROM film 
	group by rating
	order by 'Films' desc;


-- 2. Using the film table, determine:
-- 2.1 The mean film duration for each rating, and sort the results in descending order of the mean duration.
-- Round off the average lengths to two decimal places.
-- This will help identify popular movie lengths for each category.
	
    select rating, round(avg(length),2) as 'Avg.Duration' 
	FROM film
	group by rating
	order by 'Avg.Duration' desc;


-- 2.2 Identify which ratings have a mean duration of over two hours in order to help select films for customers who prefer longer movies.
	
    select rating, round(avg(length),2) as 'Avg.Duration',
	case
		when round(avg(length),2) >= '120' then 'Avg.duration > 2 hours'
		else 'Avg.duration 1-2 hours' 
	END AS 'Duration'
	FROM film
	group by rating
	order by 'Avg.Duration' desc;


-- 3. Bonus: determine which last names are not repeated in the table actor.
	
    SELECT last_name,count(distinct(last_name)) AS 'X'
	FROM actor
	group by last_name
	having count(distinct(last_name)) = 1;