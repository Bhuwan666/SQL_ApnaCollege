/*

How to Read a SQL Server Execution Plan (SSMS) – Step by Step

Step 1: Generate a Real Execution Plan in SSMS

*/

SET STATISTICS IO ON;
SET STATISTICS TIME ON;
GO

SELECT Brand, Year, SellingPrice
FROM Cars
WHERE Brand = 'Toyota';
GO

/*

Before running:
?? Press Ctrl + M (Include Actual Execution Plan)

After execution:

Click the Execution Plan tab

*/

/*
Step 2: Reading Direction (VERY IMPORTANT)

?? SQL Server reads execution plans from RIGHT ? LEFT

Even though arrows point left, data flows right to left.

*/

/*
Step 3: Typical Execution Plan (Before Index)

You will usually see ONE big operator:

?? Table Scan (Cars) – 100%

What you see in SSMS

Icon: ?? table

Name: Table Scan

Cost: ~100%

Meaning

SQL Server read every row in Cars

No useful index exists

Very slow for large tables

Why it’s bad

High logical reads

High CPU usage

?? This is your first red flag

*/


-- Step 4: After Adding an Index

CREATE INDEX idx_cars_brand
ON Cars(Brand);

-- Re-run the query.

/*
Step 5: New Execution Plan (Much Better)

Now you’ll usually see TWO operators:

*/
Index Seek ? Key Lookup


/*

Let’s break them down.

?? 1. Index Seek (idx_cars_brand) – ~20%

What you see

Icon: ??

Name: Index Seek

Predicate: Brand = 'Toyota'

Meaning

SQL Server jumps directly to matching rows

Uses B-tree index

Very fast

? This is what you WANT

?? 2. Key Lookup (Clustered) – ~80%

What you see

Icon: ??

Name: Key Lookup (Clustered)

Warning symbol ?? (often)

Meaning

Index contains only Brand

SQL Server must go back to the table

Fetch Year, SellingPrice row-by-row

Why it can be bad

Happens once per matching row

Becomes slow when many rows match

?? This is a yellow warning, not always bad, but risky.

*/


-- Step 6: Fixing the Key Lookup (Covering Index)

CREATE INDEX idx_cars_brand_cover
ON Cars(Brand)
INCLUDE (Year, SellingPrice);

-- rerun the query


/*

Step 7: Final (Best) Execution Plan

Now you see:

?? Index Seek (Covering Index) – ~100%

What changed

No Key Lookup

All required columns are in the index

One operator only

This is optimal

? Fast
? Low IO
? Low CPU

*/


/*

Step 8: Hover Over Operators (DO THIS IN SSMS)

When you hover over an operator, look for:

1? Actual vs Estimated Rows

*/

Estimated Rows: 10
Actual Rows: 50,000


-- Huge difference = bad statistics or bad index
-- 2? Predicate

Shows filter condition:
-- Confirms index is used correctly.

--3? Cost Percentage

-- Highest cost operator = optimisation target

-- Focus there first


/*

Step 9: Common Operators You WILL See in SSMS
Operator	Meaning	Good/Bad
Table Scan	Reads entire table	? Bad (large tables)
Index Scan	Reads whole index	?? Sometimes ok
Index Seek	Targeted lookup	? Best
Key Lookup	Fetch missing columns	?? Fix if frequent
Nested Loops	Small joins	?
Hash Match	Large joins	??
Sort	ORDER BY	?? Costly
*/


-- Step 10: Using IO Stats to Confirm
-- After query runs, check Messages tab:

Table 'Cars'. Logical reads 1200

-- After optimisation:
Logical reads 50

-- ?? Lower reads = faster query



/*

How to Explain This in an Interview (Perfect Answer)

I enable the actual execution plan in SSMS, read it from right to left, look for table scans or expensive operators, check row estimates versus actuals, replace scans with index seeks by adding appropriate indexes, remove key lookups using covering indexes, and confirm improvements using IO and execution time statistics.

One-Sentence Rule (Memorise)

Table Scan ? Index Seek ? Covering Index = performance improvement path

*/

