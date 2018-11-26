-- SELECT COUNT(DISTINCT amount) FROM payment;

-- SELECT * FROM customer LIMIT 5;

--SELECT first_name, last_name FROM customer 
--ORDER BY first_name DESC;

--SELECT first_name, last_name FROM customer 
--ORDER BY last_name DESC;

--SELECT first_name, last_name FROM customer 
--ORDER BY first_name ASC, last_name ASC;

--SELECT first_name FROM customer 
--ORDER BY last_name

--SELECT customer_id,amount FROM payment
--ORDER BY amount DESC LIMIT 10;

--SELECT title, film_id FROM film 
--ORDER BY film_id 
--LIMIT 5;

-- ************************************ BETWEEN STATEMENT *****************************************


--  BETWEEN STATEMENT - match a value against a range of values
-- example:  value BETWEEN low AND high;

--SELECT customer_id, amount FROM payment
--WHERE amount BETWEEN 8 and 9;

--SELECT customer_id, amount FROM payment
--WHERE amount NOT BETWEEN 8 and 9;

--SELECT amount, payment_date FROM payment
--WHERE payment_date BETWEEN '2007-02-07' and '2007-02-15';


-- ************************************ IN STATEMENT *****************************************
/* You use the IN operator with the WHERE clause to check if a value matches any value in a list of values.
The syntax of the IN operator is as follows:
value IN(value1,value2,...)

The expression returns true if the value matches any value in the list.  i.e., value1,value2,etc...
The list of values is not limited to a list of numbers or strings but also a result set of a SELECT
statement as shown in the following query:

value IN(SELECT value FROM tbl_name)

Just like with the BETWEEN statement, you can use NOT to adjust an IN statement ... (NOT IN)  */

/*
SELECT customer_id, rental_id,return_date
FROM rental
WHERE customer_id IN (1,2)
ORDER BY return_date DESC;


SELECT customer_id, rental_id,return_date
FROM rental
WHERE customer_id IN (7,13,10)
ORDER BY return_date DESC;

The above code gives same result as the following:

SELECT customer_id, rental_id,return_date
FROM rental
WHERE customer_id = 7
OR customer_id = 13
OR customer_id = 10
ORDER BY return_date DESC;

*/


/* ************************************ LIKE Statement *****************************************
LIKE operator is case-sensitive!!

An example of LIKE statment's use:  Suppose the store manager asks you to find a customer that they
do not remember the name exactly, but remembers first name is jen.

LIKE operator in PostgreSQL can do the following query:

SELECT first_name,last_name
FROM customer
WHERE first_name LIKE 'Jen%';

Notice that the WHERE clause contains a special expression:  
the first_name, the LIKE operator and a string that contains a percent (%) character, \
which is referred to as a "pattern".  Can also use "NOT LIKE"

The query retruns rows whose values in the first name column begin with Jen and may be followed
by any sequence of characters.  This technique is called pattern matching.
*/

/*
SELECT first_name, last_name
FROM customer
WHERE first_name LIKE 'Jen%';


SELECT first_name, last_name
FROM customer
WHERE first_name LIKE '%y'; -- for frist names that end in 'y'

*/

/*
SELECT first_name, last_name
FROM customer
WHERE first_name LIKE '%er%'; -- for frist names that have 'er' between the first and last letter.
*/

/*   The percent sign (%) matches any sequence of characters, from location 0 through infinity (the last) character
and the underscore (_) is going to match for any single character. */

/*
SELECT first_name, last_name
FROM customer
WHERE first_name LIKE '_her%'; -- returns first names that have only a single character followed by "her"
*/

-- ILIKE operator removes case-sensitivity!!
/*
SELECT first_name, last_name
FROM customer
WHERE first_name ILIKE 'BaR%'; -- 
*/

-- Challenge:  "How many payment transactions were greater than $5.00?"
/*
SELECT COUNT (amount)
FROM payment
WHERE amount > 5;
*/

-- Challenge: "How many actors have a first nmae that starts with the letter 'P'?"
/*
SELECT COUNT (*)
FROM actor
WHERE first_name LIKE 'P%';
*/

-- Challenge: "How many unique districts are our customers from?"
/*
SELECT COUNT (DISTINCT district)
FROM address;
*/

-- Challenge: "Retrieve the list of names for those distinct districts from the previous question."
/*
SELECT DISTINCT district
FROM address;
*/

-- Challenge: "How many films have a rating of R, and a replacement cost between $5 and %15?"
/*
SELECT COUNT (*)
FROM film
WHERE rating = 'R' AND replacement_cost BETWEEN 5 and 15;
*/


-- Challenge: "How many films havve the word "Truman" somewhere in the title?"
/*
SELECT COUNT (*)
FROM film
WHERE title ILIKE '%Truman%';
*/