-- ================================================
-- Combined Script: DELETE vs. TRUNCATE vs. DROP
-- ================================================

-------------------------------
-- Test Case 1: DELETE
-------------------------------
PRINT 'Test Case 1: DELETE demonstration';
GO

-- Ensure the table does not exist
IF OBJECT_ID('dbo.test_identity', 'U') IS NOT NULL
    DROP TABLE dbo.test_identity;
GO

-- Create the table with an IDENTITY column
CREATE TABLE test_identity (
    id INT IDENTITY(1,1) PRIMARY KEY,
    value VARCHAR(50)
);
GO

-- Insert 5 rows
INSERT INTO test_identity (value)
VALUES ('Row1'), ('Row2'), ('Row3'), ('Row4'), ('Row5');
GO

PRINT 'Data after inserting 5 rows:';
SELECT * FROM test_identity;
GO

-- DELETE all rows (the table structure remains and the identity counter is not reset)
PRINT 'Deleting all rows using DELETE...';
DELETE FROM test_identity;
GO

-- Insert a new row to observe identity behavior
PRINT 'Inserting a new row after DELETE (identity should continue from last value)...';
INSERT INTO test_identity (value) VALUES ('Row6');
GO

PRINT 'Data after DELETE and new insert:';
SELECT * FROM test_identity;
GO

-------------------------------
-- Test Case 2: TRUNCATE
-------------------------------
PRINT 'Test Case 2: TRUNCATE demonstration';
GO

-- Drop and recreate the table for a fresh start
IF OBJECT_ID('dbo.test_identity', 'U') IS NOT NULL
    DROP TABLE dbo.test_identity;
GO

CREATE TABLE test_identity (
    id INT IDENTITY(1,1) PRIMARY KEY,
    value VARCHAR(50)
);
GO

-- Insert 5 rows again
INSERT INTO test_identity (value)
VALUES ('Row1'), ('Row2'), ('Row3'), ('Row4'), ('Row5');
GO

PRINT 'Data after inserting 5 rows:';
SELECT * FROM test_identity;
GO

-- TRUNCATE the table, which removes all rows and resets the identity
PRINT 'Truncating the table using TRUNCATE TABLE...';
TRUNCATE TABLE test_identity;
GO

-- Insert a new row to see the identity restart
PRINT 'Inserting a new row after TRUNCATE (identity should reset to 1)...';
INSERT INTO test_identity (value) VALUES ('Row6');
GO

PRINT 'Data after TRUNCATE and new insert:';
SELECT * FROM test_identity;
GO

-------------------------------
-- Test Case 3: DROP
-------------------------------
PRINT 'Test Case 3: DROP demonstration';
GO

-- Drop and recreate the table for the DROP test
IF OBJECT_ID('dbo.test_identity', 'U') IS NOT NULL
    DROP TABLE dbo.test_identity;
GO

CREATE TABLE test_identity (
    id INT IDENTITY(1,1) PRIMARY KEY,
    value VARCHAR(50)
);
GO

-- Insert 5 rows once more
INSERT INTO test_identity (value)
VALUES ('Row1'), ('Row2'), ('Row3'), ('Row4'), ('Row5');
GO

PRINT 'Data after inserting 5 rows:';
SELECT * FROM test_identity;
GO

-- DROP the table completely (removes both structure and data)
PRINT 'Dropping the table using DROP TABLE...';
DROP TABLE test_identity;
GO

-- PRINT 'Attempting to query the dropped table (this will error):';
-- SELECT * FROM test_identity;
-- GO

PRINT 'All tests completed.';
GO
