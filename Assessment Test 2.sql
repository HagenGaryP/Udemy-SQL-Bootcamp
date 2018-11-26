/*
*********************************** 	ASSESSMENT TEST 2	**************************************

-- Just to see everything in bookings table
SELECT *
FROM bookings;  -- gives an ERROR: relation "bookings" does not exist.  
--		Must specify the schema, since bookings is in cd schema and not in public schema.


SELECT *
FROM cd.bookings;

********************************************************************************************************
ASSESSMENT TEST 2
Remember you need to restore the exercises database and use the cd schema!

****************

Note: Having trouble unzipping the file from the previous lecture? 
You can download an already unzipped version of the database here: 
	Dropbox Link for Unzipped Version of exercises .tar file

All you have to do is make a new database, restore it by pointing it to the downloaded file 
	from the dropbox link (no need to unzip), and then refresh the database.

*************

These questions start off really basic and then get continually more difficult:

1)	How can you retrieve all the information from the cd.facilities table?
2)	You want to print out a list of all of the facilities and their cost to members. 
		How would you retrieve a list of only facility names and costs?
3)	How can you produce a list of facilities that charge a fee to members?
4)	How can you produce a list of facilities that charge a fee to members, and that fee 
		is less than 1/50th of the monthly maintenance cost? 
		Return the facid, facility name, member cost, 
		and monthly maintenance of the facilities in question.
5)	How can you produce a list of all facilities with the word 'Tennis' in their name?
6)	How can you retrieve the details of facilities with ID 1 and 5? 
		Try to do it without using the OR operator.
7)	How can you produce a list of members who joined after the start of September 2012? 
		Return the memid, surname, firstname, and joindate of the members in question.
8)	How can you produce an ordered list of the first 10 surnames in the members table? 
		The list must not contain duplicates.
9)	You'd like to get the signup date of your last member. How can you retrieve this information?
10)	Produce a count of the number of facilities that have a cost to guests of 10 or more.
11)	Skip this one, no question for #11.
12)	Produce a list of the total number of slots booked per facility in the month of September 2012. 
		Produce an output table consisting of facility id and slots, sorted by the number of slots.
13)	Produce a list of facilities with more than 1000 slots booked. Produce an output table consisting 
		of facility id and total slots, sorted by facility id.
14)	How can you produce a list of the start times for bookings for tennis courts, for the date '2012-09-21'? 
		Return a list of start time and facility name pairings, ordered by the time.
15)	How can you produce a list of the start times for bookings by members named 'David Farrell'?
********************************************************************************************************


-- 1)	How can you retrieve all the information from the cd.facilities table?

SELECT *
FROM cd.facilities;

-- 2)	You want to print out a list of all of the facilities and their cost to members. 

SELECT name, membercost
FROM cd.facilities
ORDER BY membercost DESC;

-- 3)	How can you produce a list of facilities that charge a fee to members?

SELECT name, membercost
FROM cd.facilities
WHERE membercost > 0
ORDER BY membercost DESC;



--SELECT SUM(monthlymaintenance) FROM cd.facilities;  -- sum: 6570
--SELECT SUM(monthlymaintenance)/50 FROM cd.facilities;  -- ?column? is 1/50th montly maintenance cost = 131.4

SELECT facid, name, membercost
FROM cd.facilities
WHERE membercost < (SELECT SUM(monthlymaintenance)/50 FROM cd.facilities)
ORDER BY membercost DESC;  -- this would return all of them.

-- Question 4 wasn't explicit, and meant 1/50th of the monthly maintenance cost of that specific facility.

-- 4)	How can you produce a list of facilities that charge a fee to members, and that fee 
--		is less than 1/50th of the monthly maintenance cost? 
--		Return the facid, facility name, member cost, 

SELECT facid, name, membercost, monthlymaintenance, (monthlymaintenance)/50 AS "1/50th monthly maintenance"
FROM cd.facilities
WHERE membercost > 0 AND (membercost < (monthlymaintenance)/50)
ORDER BY membercost DESC;  
-- Result: returns facilities with faceid 4, 5, 2, 3, 7, 8.

-- 5)	How can you produce a list of all facilities with the word 'Tennis' in their name?

SELECT *
FROM cd.facilities
WHERE name LIKE '%Tennis%';
-- returned should be faceid: 0, 1, 3


***************************************************************************************************************
**********************     Viewing info of an entire schema, or all schemas 		***********************
***************************************************************************************************************
--SELECT nspname from pg_catalog.pg_namespace;  -- lists namespace of all schemas.

SELECT * FROM information_schema.tables
WHERE table_schema = 'cd'
***************************************************************************************************************
***************************************************************************************************************


-- 6)	How can you retrieve the details of facilities with ID 1 and 5? 

SELECT *
FROM cd.facilities
WHERE facid = 1 OR facid = 5;

-- 6)	How can you retrieve the details of facilities with ID 1 and 5? without using OR operator

SELECT *
FROM cd.facilities
WHERE facid IN (1,5);

-- 7)	How can you produce a list of members who joined after the start of September 2012? 
--		Return the memid, surname, firstname, and joindate of the members in question.

SELECT memid,surname,firstname,joindate
FROM cd.members
WHERE joindate >= '2012-09-01';


-- 8)	How can you produce an ordered list of the first 10 surnames in the members table? 
--		The list must not contain duplicates.


SELECT DISTINCT surname
FROM cd.members
WHERE memid BETWEEN 0 AND 10
ORDER BY surname;

from solutions:  select distinct surname from cd.members order by surname limit 10;


****************************************************************
SELECT DISTINCT surname
FROM cd.members
WHERE memid IN 
	(SELECT memid
	FROM cd.members
	WHERE memid > 0
	ORDER BY memid)
		
--GROUP BY members.memid
ORDER BY surname
LIMIT 10;
-- Results should include "smith, rownam, joplette, butters, tracy, dare, boothe, stibbons, owen, jones"
*******************************************************************



-- 9)	You'd like to get the signup date of your last member. How can you retrieve this information?

SELECT *
FROM cd.members
ORDER BY memid DESC
LIMIT 1;

-------------------------from solutions:

SELECT MAX(joindate) AS latest
FROM cd.members;
-----------------------------------

-- 10)	Produce a count of the number of facilities that have a cost to guests of 10 or more.

SELECT COUNT(name)
FROM cd.facilities
WHERE guestcost >= 10;

------------------- 	from solutions:
SELECT COUNT(*)
FROM cd.facilities
WHERE guestcost >=10;
-------------------------


-- 12)	Produce a list of the total number of slots booked per facility in the month of September 2012. 
--		Produce an output table consisting of facility id and slots, sorted by the number of slots.

SELECT bookings.facid, SUM(slots) AS total_slots
FROM cd.bookings
WHERE starttime BETWEEN '2012-09-01' AND '2012-09-30'
GROUP BY bookings.facid;
----------------------------------------- solutions: --------------------
select facid, sum(slots) as "Total Slots" 
from cd.bookings 
where starttime >= '2012-09-01' and starttime < '2012-10-01' 
group by facid 
order by sum(slots);
-------------------------------------------------------------------------

-- 13)	Produce a list of facilities with more than 1000 slots booked. Produce an output table consisting 
--		of facility id and total slots, sorted by facility id. (facid: 0,1,2,4,6)

SELECT bookings.facid, SUM(slots)
FROM cd.bookings
GROUP BY bookings.facid
HAVING SUM(slots) > 1000  -- HAVING clause comes after GROUP BY
ORDER BY bookings.facid;


-- 14)	How can you produce a list of the start times for bookings for tennis courts, for the date '2012-09-21'? 
--		Return a list of start time and facility name pairings, ordered by the time.


SELECT bookings.facid, facilities.name, bookings.starttime
FROM cd.bookings
JOIN cd.facilities ON bookings.facid = facilities.facid
WHERE name LIKE '%Tennis%' AND 
	starttime BETWEEN '2012-09-21' AND '2012-09-22'
ORDER BY starttime;
----------------------------------------------------------solution------------------------------------------
select bks.starttime as start, facs.name as name 
from cd.facilities facs 
inner join cd.bookings bks on facs.facid = bks.facid 
where facs.facid in (0,1) and bks.starttime >= '2012-09-21' 
	and bks.starttime < '2012-09-22' 
order by bks.starttime;



-- 15)	How can you produce a list of the start times for bookings by members named 'David Farrell'?


SELECT members.firstname || ' ' || members.surname AS member_name, bookings.starttime 
FROM cd.members
JOIN cd.bookings ON members.memid = bookings.memid
WHERE members.firstname = 'David' AND members.surname = 'Farrell'


******************************		Solutions to Assessment Test 2 		*****************************

1. select * from cd.facilities; 


2. select name, membercost from cd.facilities;


3. select * from cd.facilities where membercost > 0;


4. select facid, name, membercost, monthlymaintenance from cd.facilities where membercost > 0 and (membercost < monthlymaintenance/50.0);


5. select * from cd.facilities where name like '%Tennis%';


6. select * from cd.facilities where facid in (1,5);


7. select memid, surname, firstname, joindate from cd.members where joindate >= '2012-09-01';


8. select distinct surname from cd.members order by surname limit 10;


9. select max(joindate) as latest from cd.members;


10. select count(*) from cd.facilities where guestcost >= 10;


11. Skip this one.


12. select facid, sum(slots) as "Total Slots" from cd.bookings where starttime >= '2012-09-01' and starttime < '2012-10-01' group by facid order by sum(slots);


13. select facid, sum(slots) as "Total Slots" from cd.bookings group by facid having sum(slots) > 1000 order by facid;


14. 
select bks.starttime as start, facs.name as name 
from cd.facilities facs 
inner join cd.bookings bks on facs.facid = bks.facid 
where facs.facid in (0,1) and bks.starttime >= '2012-09-21' 
	and bks.starttime < '2012-09-22' 
order by bks.starttime;


15. 

select bks.starttime 
from cd.bookings bks 
inner join cd.members mems on mems.memid = bks.memid 
where mems.firstname='David' and mems.surname='Farrell';
*/