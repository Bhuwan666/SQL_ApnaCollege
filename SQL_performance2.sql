/*

 sql performance
 skills
 
 1. indexes
 2. query optimisation
 3. execution plans (basic)


 for this i have make a step by step example:

 */

 -- improving slow sql query in ssms (Step by step)

 -- Step 0: Create sample table (run once)

DROP TABLE IF EXISTS Cars;
GO

CREATE TABLE Cars (
    CarID INT IDENTITY PRIMARY KEY,
    Brand VARCHAR(50),
    Year INT,
    Fuel VARCHAR(20),
    SellingPrice INT
);
GO

-- insert sample data
-- these creates 50,000 rows so performance differences are visible

INSERT INTO Cars (Brand, Year, Fuel, SellingPrice)
SELECT
    CASE WHEN number % 3 = 0 THEN 'Toyota'
         WHEN number % 3 = 1 THEN 'Honda'
         ELSE 'BMW' END,
    2015 + (number % 8),
    CASE WHEN number % 2 = 0 THEN 'Petrol' ELSE 'Diesel' END,
    5000 + (number * 10)
FROM master..spt_values
WHERE type = 'P' AND number < 50000;
GO


-- step 1 : run a slow query (No index)

SELECT *
FROM Cars
WHERE Brand = 'Toyota';

/* what happens here

- sql server performs a table scan
- reads every row
- slow on large tables

*/

-- step 2 : check execution plan
/*
 in ssms
 1. press ctrl + M ( include actual execution plan)
 2. run the query again

 */

 /*
 what you see
 1. table scan
 2. high percentage cost

 table scan = performance problem
 
 */

 -- step 3 : reduce selected columns

 -- bad

SELECT *
FROM Cars
WHERE Brand = 'Toyota';



-- good
-- less data read from disk
-- still a scan, but cheaper

SELECT Brand, Year, SellingPrice
FROM Cars
WHERE Brand = 'Toyota';


-- step 4: add an index (most important step)

CREATE INDEX idx_cars_brand
ON Cars(Brand);
GO

-- re run query
-- exexutio plan now:
-- 1. index seek
-- 2. much lower cost
-- massive performance improvement

SELECT Brand, Year, SellingPrice
FROM Cars
WHERE Brand = 'Toyota';

/*

step 5: covering index (avoid key lookup)

if execution plan shows:
- index seek + key lookup (yellow warning)

*/

-- create a covering index:

CREATE INDEX idx_cars_brand_cover
ON Cars(Brand)
INCLUDE (Year, SellingPrice);
GO

/*

result
- only index seek
- no lookup

fastest version

*/

--step 6 : avoid functions on indexed columns

--bad (index NOT used):
SELECT *
FROM Cars
WHERE YEAR(Year) = 2020;



-- good
-- functions on indexed columns disable index usage

SELECT *
FROM Cars
WHERE Year = 2020;


-- step 7: subquery vs exists
-- create another table:

CREATE TABLE LuxuryBrands (
    Brand VARCHAR(50)
);

INSERT INTO LuxuryBrands VALUES ('BMW');
GO


-- slower
SELECT *
FROM Cars
WHERE Brand IN (SELECT Brand FROM LuxuryBrands);

-- faster
-- exists stops searching once a match is found
SELECT *
FROM Cars c
WHERE EXISTS (
    SELECT 1
    FROM LuxuryBrands l
    WHERE l.Brand = c.Brand
);


-- step 8: join instead of subquery
-- usually easier for optimizer
-- cleaner and faster
SELECT c.*
FROM Cars c
JOIN LuxuryBrands l
ON c.Brand = l.Brand;


-- step 9 : measure performance (before & after)
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

SELECT Brand, Year, SellingPrice
FROM Cars
WHERE Brand = 'Toyota';

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;

-- look for:
--1. logical reads
--2. cpu time


-- step 10 : update statistics (SQL Server-Specific)
UPDATE STATISTICS Cars;
-- helps optimizer choose better plans



-- final answer
-- i improve a slow query in ssms by enabling the actual execution plan, identifying table scans or expensive operators, adding appropriate indexes on filter and join columns, reducing selected columns, rewriting subqueries using joins or EXISTS, and validating improvements using IO and time statistics.

/*
Quick Checklist (Memorise)

✔ Use Ctrl + M
✔ Prefer Index Seek
✔ Avoid SELECT *
✔ Create covering indexes
✔ Avoid functions in WHERE
✔ Use JOIN / EXISTS
✔ Check IO & TIME

*/




