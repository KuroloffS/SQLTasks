CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Department VARCHAR(50),
    Salary DECIMAL(10,2),
    HireDate DATE
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    OrderDate DATE,
    TotalAmount DECIMAL(10,2),
    Status VARCHAR(20) CHECK (Status IN ('Pending', 'Shipped', 'Delivered', 'Cancelled'))
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2),
    Stock INT
);
SET NOCOUNT ON;

BEGIN TRY
    -- Select the top 10% highest-paid employees using a CTE.
    WITH Top10Percent AS (
        SELECT TOP (10) PERCENT *
        FROM Employees
        ORDER BY Salary DESC
    )
    -- Group by Department, calculate AverageSalary, determine SalaryCategory, and apply paging.
    SELECT 
        Department,
        AVG(Salary) AS AverageSalary,
        CASE 
            WHEN AVG(Salary) > 80000 THEN 'High'
            WHEN AVG(Salary) BETWEEN 50000 AND 80000 THEN 'Medium'
            ELSE 'Low'
        END AS SalaryCategory
    FROM Top10Percent
    GROUP BY Department
    ORDER BY AverageSalary DESC
    OFFSET 2 ROWS FETCH NEXT 5 ROWS ONLY;
END TRY
BEGIN CATCH
    -- Error handling: Print error messages.
    PRINT 'An error occurred while executing the Employee Salary Report query:';
    PRINT ERROR_MESSAGE();
END CATCH;
