
CREATE DATABASE college0;   -- create database

USE college0;   -- use database

CREATE TABLE student (    -- create table
id int primary key,
name varchar(50),
age int not null
); 

INSERT INTO student VALUES(1,'ALU',26);
INSERT INTO student VALUES(2,'MAYALU',20);

SELECT * FROM student;

CREATE TABLE student2(
    rollno INT PRIMARY KEY,
    name VARCHAR (50),
    marks INT NOT NULL,
    grade VARCHAR(1),
    city VARCHAR(20)
);

INSERT INTO student2
(rollno, name, marks, grade, city)
VALUES
(101, 'anil', 78, 'C', 'Pune'),
(102, 'sunil', 89, 'A', 'Dhune'),
(103, 'kapil', 45, 'B', 'Sune'),
(104, 'sabin', 68, 'D', 'Kune'),
(105, 'dhruba', 97, 'A', 'Lune'),
(106, 'santosh', 85, 'B', 'Jhune');

SELECT * FROM student2;


/*

Common Table Expression (CTE)

- a common table expression, or CTE, is a temporary named result set created from a simple SELECT statement that can be used in a subsequent SELECT statement.
- we can define CTEs by adding a WITH clause directly before SELECT, INSERT, UPDATE, or MERGE statement.
- the WITH clause can include one or more CTEs separated by commas.

Syntax

With my_cte AS (
    SELECT a,b,c     -- cte query
    FROM Table1)
SELECT a,c        -- main query
FROM my_cte

*/

SELECT * FROM student

WITH my_cte AS (
    SELECT * 
    FROM student
    )
SELECT name, age
FROM my_cte


-- we can also use multiple CTEs

WITH my_a AS (
    SELECT *
    FROM student
    ),
my_b AS (
    SELECT *
    FROM student2
)
SELECT a.age, b.marks, b.city
FROM my_a as a, my_b as b

/*

CASE statements/expression

- the case expression goes through conditions and returns a value when the first condition is met (like if-then-else statement). if no conditions are true, it returns the value in the ELSE clause.
- if there is no else part and no conditions are true, it returns null

syntax: case statements 

CASE
    WHEN condition1 THEN result1
    WHEN condition2 THEN result2
    WHEN conditionN THEN resultN
    ELSE other_result
END;

example:

SELECT customer_id, amount,
CASE
    WHEN amount > 100 THEN 'Expensive product'
    WHEN amount = 100 THEN 'Moderate product'
    ELSE 'Inexpensive product'
END AS ProductStatus
FROM payment

*/

SELECT marks, city,
CASE 
    WHEN marks > 70 THEN 'Excellent'
    WHEN marks < 70 THEN 'Good'
    ELSE 'MODERATE'
END AS remarks
FROM student2


/* 

syntax : case expression

CASE Expression
    WHEN value1 THEN result1
    WHEN value2 THEN result2
    WHEN valueN THEN resultN
    ELSE other_result
END;

example:

SELECT customer_id,
CASE amount
    WHEN 500 THEN 'Prime Customer'
    WHEN 100 THEN 'Plus product'
    ELSE 'Regular Customer'
END AS CustomerStatus
FROM payment

*/


SELECT rollno, 
CASE marks
    WHEN 78 THEN 'A'
    WHEN 45 THEN 'B'
    ELSE 'C'
END AS grade_remarks
FROM student2

SELECT * FROM student2


/*

window function

- window functions applies aggregate, ranking and analytic functions over a particular window (set of rows)
- and OVER clause is used with window functions to define that window.

# in comparison to aggregate functions (sum, avg, etc.)

- aggregate function give output one row per aggregation  ; many to one
- window function ; the rows maintain their separate identities  ; one to one

syntax:

SELECT column_name(s),
    fun()over([<PARTITION BY Clause>]
              [<ORDER BY Clause>]
              [<ROW or RANGE Clause>])
FROM table_name

# for fun() - select a function
1 aggregate functions
2 ranking functions
3 value/analytic functions

- and define a window
1 PARTITION BY
2 ORDER BY
3 ROWS



DEFINITIONS
1. window function - applies aggregate, ranking and analytic functions over a particular window; for example, sum, avg, or row_number
2. Expression - is the name of the column that we want the window function operated on. This may not be necessary depending on what window function is used.
3. OVER - is just to signify that this is a window function
4. PARTITION BY - divides the rows into partitions so we can specify which rows to use to compute the window function
5. ORDER BY - is used so that we can order the rows within each partition. This is optional and does not have to be specified
6. ROWS can be used if we want to further limit the rows within our partition. This is optional and usually not used.

WINDOW FUNCTION TYPES
-> there is no official division of the SQL window functions into categories but high level we cvan divide into three types:

1. Aggregate 
- SUM
- AVG
- COUNT
- MIN
- MAX

2. Ranking
- ROW_NUMBER
- RANK
- DENSE_RANK
- PERCENT_RANK

3. Value/Analytic
- LEAD
- LAG
- FIRST_VALUE
- LAST_VALUE

# Example:

*/
USE college0;

CREATE TABLE practice(
    new_id INT ,
    new_cat VARCHAR(50),
    Total INT,
    Average FLOAT,
    COUNT INT,
    Min INT,
    Max INT
    
);
SELECT * from practice;

INSERT INTO practice
(new_id, new_cat, Total, Average, Count, Min, Max)
VALUES
(100,'Agni',300,150,2,100,200),
(200,'Agni',300,150,2,100,200),
(500,'Dharti',1200,600,2,500,700),
(700,'Dharti',1200,600,2,500,700),
(200,'Vayu',1000,333.33333,3,200,500),
(300,'Vayu',1000,333.33333,3,200,500),
(500,'Vayu',1000,333.33333,3,200,500);

-- here is window function for aggregate

SELECT new_id, new_cat,
SUM(new_id) OVER( PARTITION BY new_cat ORDER BY new_id) AS "Total",
AVG(new_id) OVER( PARTITION BY new_cat ORDER BY new_id) AS "Average",
COUNT(new_id) OVER( PARTITION BY new_cat ORDER BY new_id) AS "Count",
MIN(new_id) OVER( PARTITION BY new_cat ORDER BY new_id) AS "Min",
MAX(new_id) OVER( PARTITION BY new_cat ORDER BY new_id) AS "Max"

FROM practice


-- rows

SELECT new_id, new_cat,
SUM(new_id) OVER(ORDER BY new_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS "Total",
AVG(new_id) OVER(ORDER BY new_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS "Average",
COUNT(new_id) OVER(ORDER BY new_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS "Count",
MIN(new_id) OVER(ORDER BY new_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS "Min",
MAX(new_id) OVER(ORDER BY new_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS "Max"
FROM practice


-- for ranking

SELECT new_id,
ROW_NUMBER() OVER( ORDER BY new_id) AS "ROW_NUMBER",
RANK() OVER( ORDER BY new_id) AS "RANK",
DENSE_RANK() OVER( ORDER BY new_id) AS "DENSE_RANK",
PERCENT_RANK() OVER( ORDER BY new_id) AS "PERCENT_RANK"
FROM practice

-- for value/analytic
-- if you want the single last value from column, use:"ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING"

SELECT new_id,
FIRST_VALUE(new_id) OVER(ORDER BY new_id) AS "FIRST_VALUE",
LAST_VALUE(new_id) OVER(ORDER BY new_id) AS "LAST_VALUE",
LEAD(new_id) OVER(ORDER BY new_id) AS "LEAD",
LAG(new_id) OVER(ORDER BY new_id) AS "LAG"
FROM practice


-- interview   question 
-- Q1. offset the LEAD and LAG values by 2 in the output columns ?

SELECT new_id,
LEAD(new_id,2) OVER( ORDER BY new_id) AS "LEAD_by_2",
LAG(new_id,2) OVER( ORDER BY new_id) AS "LAG_by_2"
FROM practice