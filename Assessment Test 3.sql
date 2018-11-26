/* 			Assessment Test 3

-- Create a new database called "School" this database should have two tables: teachers and students.

Right click on Databases > New Database > type "School" > click OK.

-- The students table should have columns for student_id, first_name,last_name, homeroom_number, phone,email, and graduation year.

-- The teachers table should have columns for teacher_id, first_name, last_name, homeroom_number, department, email, and phone.


-- creating students table

CREATE TABLE students(
student_id serial PRIMARY KEY,
first_name VARCHAR(50),
last_name VARCHAR(50),
homeroom_number integer,
phone numeric UNIQUE,
email VARCHAR(100) UNIQUE,
graduation_year DATE);


SELECT * FROM students;


-- ALTER TABLE, to add the NOT NULL constraint to phone column, using ALTER COLUMN.

ALTER TABLE students ALTER COLUMN phone SET NOT NULL;

-- Alter the phone datatype; change from numeric to varchar.

ALTER TABLE students ALTER COLUMN phone TYPE VARCHAR(50);

ALTER TABLE students ALTER COLUMN graduation_year TYPE VARCHAR(50);

SELECT * FROM students;

-- INSERT INTO students, a student's information.

INSERT INTO students(student_id, first_name, last_name, homeroom_number, phone, graduation_year)
VALUES (1, 'Mark', 'Watney', 5, '777-555-1234', 2035);


SELECT * FROM students;


-- made a mistake on teachers table, drop the table, then create it again.

DROP TABLE teachers;

-- CREATE teachers table

CREATE TABLE teachers(
teacher_id serial PRIMARY KEY,
first_name VARCHAR(50),
last_name VARCHAR(50),
homeroom_number integer,
department VARCHAR(50),
email VARCHAR(100) UNIQUE,
phone VARCHAR(20) NOT NULL UNIQUE);


Then insert a teacher names Jonas Salk (teacher_id = 1) who as a 
homeroom number of 5 and is from the Biology department. 
His contact info is: jsalk@school.org and phone is 777-555-4321.


INSERT INTO teachers (teacher_id, first_name, last_name, homeroom_number, department, email,phone)
VALUES (1, 'Jonas', 'Salk', 5, 'Biology', 'jsalk@school.org','777-555-4321');


*************************************************************************
		Solutions		
*************************************************************************

To create the database  simply right-click on the databases drop down menu and select "New Database".

Then you can use the following SQL scripts to execute the tasks:

To create the students table:

CREATE TABLE students(
student_id serial PRIMARY KEY,
first_name VARCHAR(45) NOT NULL,
last_name VARCHAR(45) NOT NULL, 
homeroom_number integer,
phone VARCHAR(20) UNIQUE NOT NULL,
email VARCHAR(115) UNIQUE,
grad_year integer);


To create the teachers table:

CREATE TABLE teachers(
teacher_id serial PRIMARY KEY,
first_name VARCHAR(45) NOT NULL,
last_name VARCHAR(45) NOT NULL, 
homeroom_number integer,
department VARCHAR(45),
email VARCHAR(20) UNIQUE,
phone VARCHAR(20) UNIQUE);


Then for inserting the student information:

INSERT INTO students(first_name,last_name, homeroom_number,phone,grad_year)
VALUES ('Mark','Watney',5,'7755551234',2035);


Then for inserting the teacher information:

INSERT INTO teachers(first_name,last_name, homeroom_number,department,email,phone)
VALUES ('Jonas','Salk',5,'Biology','jsalk@school.org','7755554321');
