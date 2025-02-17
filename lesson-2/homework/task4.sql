-- Drop the student table if it exists
IF OBJECT_ID('dbo.student', 'U') IS NOT NULL
    DROP TABLE dbo.student;
GO

-- Create the student table with a computed column total_tuition
CREATE TABLE student (
    student_id INT IDENTITY(1,1) PRIMARY KEY,
    student_name VARCHAR(50),
    classes INT,
    tuition_per_class DECIMAL(10,2),
    total_tuition AS (classes * tuition_per_class)  -- Computed column
);
GO

-- Insert 3 sample rows
INSERT INTO student (student_name, classes, tuition_per_class)
VALUES 
    ('Alice', 5, 200.00),
    ('Bob', 3, 250.00),
    ('Charlie', 4, 225.50);
GO

-- Retrieve and display all data
SELECT * FROM student;
GO
