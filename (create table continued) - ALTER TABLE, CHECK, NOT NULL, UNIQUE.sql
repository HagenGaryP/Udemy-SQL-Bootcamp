/*

-- remove the "link" table from the database schemas by using DROP TABLE

DROP TABLE IF EXISTS link;

-- Create a new table named "link"

CREATE TABLE link (
link_id serial PRIMARY KEY,
title VARCHAR(512) NOT NULL,
url VARCHAR(1024) NOT NULL UNIQUE);  -- Query returned successfully with no result.. Created table "link" with 3 columns.

-- Using ALTER TABLE keywords:  	ADD COLUMN
-- 	Steps: "ALTER TABLE table_name ADD COLUMN column_name datatype;"

ALTER TABLE link ADD COLUMN active boolean;  -- must specify data type when creating a table/column
-- this added a column called "active" that has a boolean (True/False) datatype 


SELECT * FROM link;
-- Query results now show 4 columns (instead of 3), since we added the "active" column (boolean) and data type.

-- How to DROP that "active" column that we just added.

ALTER TABLE link DROP COLUMN active; -- Query returned successfully with no result in 13 msec.

SELECT * FROM link; -- "active" column is no longer there.

-- Rename the "title" column to "new_title_name"
-- STEPS/SYNTAX: 	ALTER TABLE table_name RENAME COLUMN column_name TO new_column_name;

ALTER TABLE link RENAME COLUMN title TO new_title_name;

SELECT * FROM link;  -- now the middle column is "new_title_name" instead of "title"


-- rename the entire link table, using RENAME TO

ALTER TABLE link RENAME TO url_table;

SELECT * FROM url_table;  -- table name is no longer "link", since we renamed it to url_table.

*/

/*
**************************************************************************************
****************************		DROP TABLE 		**********************
**************************************************************************************

To remove an existing table from the database, you use the DROP TABLE statement as followed:

DROP TABLE [IF EXISTS] table_name  -- [IF EXISTS] is optional

IF EXISTS is an optional statement to avoid errors if a table does not exist.
For instance, if you ran the code "DROP TABLE table_xyz;" and table_xyz 
	does not exist, the query will return an error.
However, if you used IF EXISTS, there will be no error. (and nothing to drop)

-- create a table to work with

CREATE TABLE test_two(
test_id serial PRIMARY KEY);

-- check to see if this table "test_two" exists.

SELECT * FROM test_two;  -- returns no rows, but 1 column called "test_id"

-- Drop the table.  Syntax: "DROP TABLE table_name;"

DROP TABLE test_two;

-- check to see if the table was actually dropped (deleted)

SELECT * FROM test_two;
-- OUTPUT PANE - Messages - 	ERROR:  relation "test_two" does not exist
				LINE 75: SELECT * FROM test_two;
						       ^
				********** Error **********
				
				ERROR: relation "test_two" does not exist
				SQL state: 42P01
				Character: 2574


-- how to use the IF EXISTS statement
-- first showing without it, to show the error message.
DROP TABLE test_two;
	-- Output Pane - Messages
				ERROR:  table "test_two" does not exist
				********** Error **********
				
				ERROR: table "test_two" does not exist
				SQL state: 42P01

-- using IF EXISTS
DROP TABLE IF EXISTS test_two;
	-- Output pane - Message
		NOTICE:  table "test_two" does not exist, skipping
		Query returned successfully with no result in 16 msec.


-- RESTRICT is a keyword that you can put after your table to "restrict" the action
-- 	and doesn't allow it to drop the table.

-- for example: " DROP TABLE IF EXISTS test_two RESTRICT; "  

-- however, RESTRICT is already implied automatically within PostgreSQL


-- CASCADE

-- If you want to remove this table that has dependencies on it, and you 
	want to remove the dependent objects together, use CASCADE keyword.
DROP TABLE IF EXISTS test_two CASCADE;

-- used when youw ant to drop a table that has constraints or dependencies
-- or other objects have dependencies on that table you're trying to draw,
-- or is used in some sort of "view".  Can use CASCADE.

*/

/*
lecture 79
*************************************************************************************
***************			CHECK Constraint		*********************
*************************************************************************************

A CHECK constraint is a kind of constraint that allows you to specify if a value
in a column must meet a specific requirement.

The CHECK constraint uses a Boolean expression to evaluate the values of a column.

if the values of the column pass the check, PostgreSQL will insert or update those values.

-- examples
--CHECK syntax(while creating a table):
CREATE TABLE table_name
c1 datatype PRIMARY KEY,
c2 datatype CHECK(boolean condition)


-- create a table

CREATE TABLE new_users (
id serial PRIMARY KEY,
first_name VARCHAR (50),
birth_date DATE CHECK(birth_date > '1900-01-01'),	-- using the CHECK constraint on column "birth_date"
join_date DATE CHECK (join_date > birth_date),		-- CHECK constraint, with another boolean condition.
salary integer CHECK (salary>0));


SELECT * FROM new_users;
-- returns table with no rows, and the columns: id, first_name, birth_date, and salary.


-- INSERT a new row into new_users table and see if we get errors based off our CHECKS

INSERT INTO new_users(first_name, birth_date,join_date,salary)
VALUES ('Joe','1980-02-02','1990-04-04', -10);
------------------------------------------------------------------------------
-- OUTPUT PANE - Messages ----------------------------------------------------
ERROR:  new row for relation "new_users" violates check constraint "new_users_salary_check"
DETAIL:  Failing row contains (1, Joe, 1980-02-02, 1990-04-04, -10).
********** Error **********

ERROR: new row for relation "new_users" violates check constraint "new_users_salary_check"
SQL state: 23514
Detail: Failing row contains (1, Joe, 1980-02-02, 1990-04-04, -10).
-------------------------------------------------------------------------------

PostgreSQL automatically names the specific constraint, and does it by basically concatenating
	the table name (new_users), with an underscore of the column name (salary) and	
	then it specifies CHECK.  i.e., "new_users_salary_check", but can manually name constraints.

-- create another table to work with

CREATE TABLE checktest(
sales integer CONSTRAINT positive_sales CHECK(sales>0));	-- manually named the constraint "positive_sales"


-- INSERT INTO checktest table; using a VALUES that satisfy CHECK constraint.
INSERT INTO checktest(sales)
VALUES (10);

-- INSERT INTO checktest table; using a VALUES that violates the CHECK constraint.
INSERT INTO checktest(sales)
VALUES (-22);  -- negative value violates check constraint (sales > 0)
------------------------------------------------------------------------------
-- OUTPUT PANE - Messages ----------------------------------------------------
ERROR:  new row for relation "checktest" violates check constraint "positive_sales"
DETAIL:  Failing row contains (-22).
********** Error **********

ERROR: new row for relation "checktest" violates check constraint "positive_sales"
SQL state: 23514
Detail: Failing row contains (-22).
-------------------------------------------------------------------------------
*/

/*
lecture 80
*************************************************************************************
***************			NOT NULL Constraint		*********************
*************************************************************************************

in database theory, NULL is unknown or missing info.  
The NULL value is different from empty or zero.
For example, we can ask for the email address of a person, if we don't know, we use the NULL value.
In case the person doesn't have an email address, we can mark it as an empty string.

PostgreSQL provides the not-null constraint to enforce a column to only accept values
	that are NOT NULL.  Must not be NULL values.

It means that whenever you insert or update data, you must specify a value that 
	is different from the NULL value.


-- Create a table to work with.

CREATE TABLE learn_null(
first_name VARCHAR(50),
sales integer NOT NULL);  -- table with 2 columns

-- INSERT INTO table; a value into first_name, while leaving sales NULL

INSERT INTO learn_null (first_name)  -- inserting values into first_name, but not into sales column.
VALUES ('John');
------------------------------------------------------------------------------
-- OUTPUT PANE - Messages ----------------------------------------------------
ERROR:  null value in column "sales" violates not-null constraint
DETAIL:  Failing row contains (John, null).
********** Error **********

ERROR: null value in column "sales" violates not-null constraint
SQL state: 23502
Detail: Failing row contains (John, null).
-------------------------------------------------------------------------------

-- INSERT INTO table; a value into first_name and sales column.  giving no error.

INSERT INTO learn_null (first_name,sales)
VALUES ('John',12);
-- Query returned successfully: one row affected, 13 msec execution time.


SELECT * FROM learn_null;
-- Data Output --
row#	first_name	sales
1	"John";		12
*/

/*
lecture 81
*************************************************************************************
***************			UNIQUE Constraint		*********************
*************************************************************************************

UNIQUE constraint makes sure that the value in a column 
	or a group of columns is unique in a table.

Sometimes you want to ensure that the value in a column or a group of 
	columns is unique across the whole table.
Such as email address, username, employee id, etc...

PostgreSQL provides you with the UNIQUE constraint to make sure that the
	uniqueness of thedata is maintained correctly.

With the UNIQUE constraint, every time you insert a new row, PostgreSQL checks if
	the value is already in the table.

If it finds that the new value is already in the table, it gives an error message
	and rejects the changes.
The same process is carried out when you UPDATE existing data.

-- create a table to work with unique.

CREATE TABLE people(
id serial PRIMARY KEY,
first_name VARCHAR(50),
email VARCHAR(100) UNIQUE);  

-- Using the INSERT statement along with UNIQUE.

INSERT INTO people(id,first_name,email)
VALUES(1,'Joe','joe@joe.com');

SELECT * FROM people; -- checking data we inserted.
-- Data Output -- 
row#	id	first_name	email
1	1;	"Joe";		"joe@joe.com"

-- Now try to see if we get an error from inserting a row with the same email

INSERT INTO people(id,first_name,email)
VALUES(2,'Joseph','joe@joe.com');
------------------------------------------------------------------------------
-- OUTPUT PANE - Messages ----------------------------------------------------
ERROR:  duplicate key value violates unique constraint "people_email_key"
DETAIL:  Key (email)=(joe@joe.com) already exists.

********** Error **********

ERROR: duplicate key value violates unique constraint "people_email_key"
SQL state: 23505
Detail: Key (email)=(joe@joe.com) already exists.
-------------------------------------------------------------------------------