-- ============================================
-- CSV to SQL Server: Importing Worker Data
-- ============================================

-- Drop the worker table if it exists
IF OBJECT_ID('dbo.worker', 'U') IS NOT NULL
    DROP TABLE dbo.worker;
GO

-- Create the worker table with two columns: id and name
CREATE TABLE dbo.worker (
    id INT,
    name VARCHAR(50)
);
GO

-- Use BULK INSERT to import the CSV file into the worker table
BULK INSERT dbo.worker
FROM 'D:\CSV\worker_data.csv'
WITH (
    FIELDTERMINATOR = ',',   -- Fields are separated by commas
    ROWTERMINATOR = '\n',    -- Each row ends with a new line
    FIRSTROW = 2             -- Skip the header row (if your file has one)
);
GO

-- Verify the imported data by selecting all rows from the worker table
SELECT * FROM dbo.worker;
GO
