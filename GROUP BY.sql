/* *********************** 	GROUP BY Statements   ***********************

	MIN, MAX, AVG, SUM  -  Aggregate Functions

Take a lot of information and aggregate it (or combine it) into a single value.

Ex:

SELECT AVG(amount)
FROM payment;
*/

/*
SELECT ROUND( AVG(amount), 5) -- rounds first argument, to the decimal place provided in second argument
FROM payment;
--
SELECT amount
FROM payment
ORDER BY amount;
--

SELECT COUNT (amount)
FROM payment
WHERE amount = 0.00;

SELECT MAX (amount)
FROM payment
;

SELECT SUM (amount)
FROM payment;


SELECT ROUND (SUM(amount),1)
FROM payment;
*/

/* *********************************	 GROUP BY	************************************

The GROUP BY clause divides the rows returned from the SELECT statement into groups.

For each group, you can apply an aggregate function.
Example:  - Calculating sum of items, or counting number of items in groups.

GROUP BY syntax:

SELECT column_1,aggregate_function(column_2)
FROM table_name
GROUP BY column_1;

actual usage... more examples

-- using GROUP BY without using an aggregate function.

SELECT customer_id
FROM payment
GROUP BY customer_id; -- This acts similar to the DISTINCT function, only returning distinct values

--  using group by gives us 599 rows, where as if we didn't use group by function it gives 15k rows

-- Using GROUP BY with an aggregate function


SELECT customer_id, SUM(amount)
FROM payment
GROUP BY customer_id;  -- This sorts the results set by customer ID and adds up the amount
	-- that belongs to the same customer.  Whenever the ID changes, it adds the row to the results.
	-- Breakdown: this selects customer ID column, then take the sum of the amount column from the 
	-- payment table grouped by the customer ID.  So basically for every customer ID, group by the customer
	-- ID and then sum that specific customer's amount column.
	-- Took each customer's payments (multiple amounts) and added all of them up for a total sum of their payments.


SELECT customer_id, SUM(amount)
FROM payment
GROUP BY customer_id
ORDER BY SUM (amount) DESC;  -- this does same as above, but now we see which customers spent most money.


SELECT staff_id, COUNT(payment_id)
FROM payment
GROUP BY staff_id;  -- Total of rows for each staff_id


SELECT staff_id, COUNT(*) -- same result
FROM payment
GROUP BY staff_id;

-- Gives the number of films for each rating
SELECT rating, COUNT (rating)
FROM film
GROUP BY rating;


SELECT rental_duration, COUNT (rental_duration)
FROM film
GROUP BY rental_duration;

-- if we want to see the rental rate for each film rating
SELECT rental_rate,rating
FROM film
LIMIT 5;

-- the avgerage rental rate for each film rating
SELECT rating, AVG (rental_rate)
FROM film
GROUP BY rating;

*/


/* *************** GROUP BY Challenege ***************

General task is to utilize all the skills learned so far using GROUP BY statement

-- Challenge: "We have 2 staff members with staff_id value 1 and 2.  We want to give a bonus
--   		to the staff member that handled the most payments.
-- 		How many Payments did each handle, and what was each total amounts processed?"

SELECT staff_id, COUNT(amount), SUM(amount)
FROM payment
GROUP BY staff_id;

--Challenge:  
	"Corporate headquarters is auditing the store you work at and want to know the average 
		replacement cost of movies by rating.  For example, R rated movies have 
		an average replacement cost of $20.23"

SELECT rating, ROUND(AVG(replacement_cost),2)
FROM film
GROUP BY rating;



-- Challenge: " We want to send coupons to the 5 customers who have spent the most amount of money.
-- 		Find the customer_id's of the top 5 spenders."

SELECT customer_id, SUM(amount)
FROM payment
GROUP BY customer_id
ORDER BY SUM(amount) DESC
LIMIT 5;

*/




/* ******************** 	HAVING		  (section 6, lecture 43)  ***********************************

The HAVING clause is often used in conjunction with the GROUP BY clause to filter group rows
	that do not satisfy a specified condition.

It is similar to the WHERE clause, except used with a GROUP BY statement.

HAVING Syntax:

SELECT column_1, aggregate_function(column_2)
FROM table_name
GROUP BY column_1
HAVING condition;

The HAVING clause sets the condition for group rows created by the GROUP BY clause,
	after the GROUP BY clause applies.  
	While the WHERE clause sets the condition for individual rows before GROUP BY clause applies.
This is the main difference between the HAVING nad WHERE clauses.

Now some examples of HAVING clause usage:


-- Just to get an idea of what HAVING clause does, need to see with and without it.

-- without HAVING, we get 599 rows of data.
SELECT customer_id, SUM(amount) 
FROM payment
GROUP BY customer_id;
--HAVING condition;


--With HAVING clause included

SELECT customer_id, SUM(amount) 
FROM payment
GROUP BY customer_id
HAVING SUM (amount) > 200;  -- shows only the customers with total amount greater than $200

--  total customers per store
SELECT store_id, COUNT(customer_id)
FROM customer
GROUP BY store_id;  -- returns store 1: 326 customers, store 2: 273 customers


--  total customers per store HAVING a total > 300
SELECT store_id, COUNT(customer_id)
FROM customer
GROUP BY store_id
HAVING COUNT (customer_id) > 300; -- only returns store 1: 326 customers, since condition (326 > 300) is satisfied.


--  Using WHERE and IN clauses to show the rating and rental rate of each film, for specified ratings
SELECT rating, rental_rate
FROM film
WHERE rating IN ('R', 'G', 'PG');

--  using above example to find average, but using GROUP BY clause to give only DISTINCT values
-- only difference is the above returns each film and allows for repeated "rating" values
--    but by using the GROUP BY clause, we return only the single rating and its AVG(rental_rate)
SELECT rating, ROUND(AVG(rental_rate),2)
FROM film
WHERE rating IN ('R', 'G', 'PG')
GROUP BY rating;


-- now do the same but use the HAVING clause
SELECT rating, ROUND(AVG(rental_rate),2)  -- selects rating column and aggregate function to give AVG(rental_rate) of each rating
FROM film
WHERE rating IN ('R', 'G', 'PG')  -- use the where column first, bc we filter out rating column (no aggrgt fnct)
GROUP BY rating  -- straight forward, groups by the "rating" and allows for only distinct rating value
HAVING AVG(rental_rate) < 3;  -- filtering off the AGGREGATE FUNCTION (rental_rate), 
		-- so this now will only return the rating and average rental_rate if AVG(rental_rate) < 3.

HAVING challenge:

	"We want to know what customers are eligible for our platinum credit card.  The requirements are
	that the customer has at least a total of 40 transaction payments.
	What customers (by customer_id) are eligible for the credit card?"


SELECT customer_id, COUNT(amount)
FROM payment
--WHERE
GROUP BY customer_id 
--ORDER BY COUNT(amount) DESC
HAVING COUNT(amount) >= 40;


Challenge:
	" When grouped by rating, what movie ratings have an average rental duration of more than 5 days?"


SELECT rating, AVG(rental_duration)
FROM film
GROUP BY rating 
HAVING AVG(rental_duration) > 5;

