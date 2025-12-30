/*

indexes in sql server:

- indexes are used to retrieve data from the database more quickly
- users cannot see the indexes, it is used to speed up the search operation

*/

/*

-- syntax of index:

CREATE INDEX index_name
ON table_name (column1, column2, ...);

*/

USE COLLEGE0;
-- example of index:
SELECT * FROM student

CREATE INDEX IX_DNAME
ON student(name, age)

-- syntax for viewinging the index: SP_HELPINDEX TABLE_NAME
-- EXAMPLE

SP_HELPINDEX student

-- syntax: DROP INDEX TABLENAME.INDEXNAME
--EXAMPLE

DROP INDEX student.IX_DNAME



/*

there are two types of indexes:
1. clustered index
2. non-clustered index

difference between them
- A clustered index will sort the table or arrange the table by alphabetical order
- A clustered index specifies the physical storage order of the table
- A non-clustered index collects the data at one place and records at another place
- A clustered index is faster than non-clustered index

SQL server automatically creates indexes when PRIMARY KEY and UNIQUE constraint are defined on table columns

like when you create a table with a unique constraint, it automatically create a nonclustered index.

if you configure a PRIMARY KEY , it automatically creates a clustered index, unless a clustered index already exists.

*/

/*

syntax for clustered index:

CREATE CLUSTERED INDEX index_name
ON table_name (column1, column2, ...);
*/



/*

SELECT * FROM student
-- example 
CREATE CLUSTERED INDEX IX_CDNAME
ON student(age)   

-- this shows error because we can only create one clustered index
-- and there is primary key which automatically creates clustered index


*/

-- SP_HELPINDEX student

/*

syntax for non clustered index:

CREATE NONCLUSTERED INDEX index_name
ON table_name (column1, column2, ...);

*/

-- example 
CREATE NONCLUSTERED INDEX IX_CDNAME
ON student(age)   

SP_HELPINDEX student




/*

query optimisation techniques

*/

-- query optimisation is a technique to improve the database performance

/*
Different techniques for optimisation

1.
- create index
- index are very helpful to improve the search performance of the query

2.
- use union all rather than choosing union
- union all - shows every record from the database
- union - it will remove duplicate values and shows unique records

3.
- using select statement followed by column name
- do not try to retrieve all the records from a table everytime

4.
- minimize the usage of Distinct
- as it takes time to search and give the unique values

5.
- use Top/Limit to check the data
- example: select top5 customers from customer_table

6.
- avoid multiple joining
- example: do not try to join more than 2-3 tables because it slows down the performance

7.
- use varchar rather than char to save the space in Database
- example: Employee_Firstname char(200) not null - the remaining space is of no use.
- avoid using != or <> because it will eliminate index and use full table scan
- for example: select first_name,age from employee where age <>30 -avoid this

8.
- try to use separate queries
- select first_name, age from employee where age>30
- select first_name, age from employee where age<30


*/





