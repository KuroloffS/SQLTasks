CREATE TABLE Employees (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Department VARCHAR(50) NOT NULL,
    Salary DECIMAL(10,2) NOT NULL,
    HireDate DATE NOT NULL
);

INSERT INTO Employees (Name, Department, Salary, HireDate) VALUES
    ('Alice', 'HR', 50000, '2020-06-15'),
    ('Bob', 'HR', 60000, '2018-09-10'),
    ('Charlie', 'IT', 70000, '2019-03-05'),
    ('David', 'IT', 80000, '2021-07-22'),
    ('Eve', 'Finance', 90000, '2017-11-30'),
    ('Frank', 'Finance', 75000, '2019-12-25'),
    ('Grace', 'Marketing', 65000, '2016-05-14'),
    ('Hank', 'Marketing', 72000, '2019-10-08'),
    ('Ivy', 'IT', 67000, '2022-01-12'),
    ('Jack', 'HR', 52000, '2021-03-29');
--task1
SET NOCOUNT ON;

BEGIN TRY
    SELECT 
        EmployeeID,
        Name,
        Department,
        Salary,
        RANK() OVER (ORDER BY Salary DESC) AS SalaryRank
    FROM Employees;
END TRY
BEGIN CATCH
    PRINT 'Error in Task 1: ' + ERROR_MESSAGE();
END CATCH;
GO
--task2
SET NOCOUNT ON;

BEGIN TRY
    ;WITH RankedEmployees AS (
        SELECT 
            EmployeeID,
            Name,
            Department,
            Salary,
            RANK() OVER (ORDER BY Salary DESC) AS SalaryRank
        FROM Employees
    )
    SELECT *
    FROM RankedEmployees
    WHERE SalaryRank IN (
        SELECT SalaryRank
        FROM RankedEmployees
        GROUP BY SalaryRank
        HAVING COUNT(*) > 1
    );
END TRY
BEGIN CATCH
    PRINT 'Error in Task 2: ' + ERROR_MESSAGE();
END CATCH;
GO
--task3
SET NOCOUNT ON;

BEGIN TRY
    ;WITH DeptRanking AS (
        SELECT 
            EmployeeID,
            Name,
            Department,
            Salary,
            RANK() OVER (PARTITION BY Department ORDER BY Salary DESC) AS DeptSalaryRank
        FROM Employees
    )
    SELECT *
    FROM DeptRanking
    WHERE DeptSalaryRank <= 2;
END TRY
BEGIN CATCH
    PRINT 'Error in Task 3: ' + ERROR_MESSAGE();
END CATCH;
GO
--task4
SET NOCOUNT ON;

BEGIN TRY
    ;WITH DeptLowest AS (
        SELECT 
            EmployeeID,
            Name,
            Department,
            Salary,
            RANK() OVER (PARTITION BY Department ORDER BY Salary ASC) AS SalaryRankAsc
        FROM Employees
    )
    SELECT *
    FROM DeptLowest
    WHERE SalaryRankAsc = 1;
END TRY
BEGIN CATCH
    PRINT 'Error in Task 4: ' + ERROR_MESSAGE();
END CATCH;
GO
--task5
SET NOCOUNT ON;

BEGIN TRY
    SELECT 
        EmployeeID,
        Name,
        Department,
        Salary,
        HireDate,
        SUM(Salary) OVER (PARTITION BY Department ORDER BY HireDate ROWS UNBOUNDED PRECEDING) AS RunningTotal
    FROM Employees;
END TRY
BEGIN CATCH
    PRINT 'Error in Task 5: ' + ERROR_MESSAGE();
END CATCH;
GO
--task6
SET NOCOUNT ON;

BEGIN TRY
    SELECT 
        EmployeeID,
        Name,
        Department,
        Salary,
        SUM(Salary) OVER (PARTITION BY Department) AS TotalDeptSalary
    FROM Employees;
END TRY
BEGIN CATCH
    PRINT 'Error in Task 6: ' + ERROR_MESSAGE();
END CATCH;
GO
--task7
SET NOCOUNT ON;

BEGIN TRY
    SELECT 
        EmployeeID,
        Name,
        Department,
        Salary,
        AVG(Salary) OVER (PARTITION BY Department) AS DeptAvgSalary
    FROM Employees;
END TRY
BEGIN CATCH
    PRINT 'Error in Task 7: ' + ERROR_MESSAGE();
END CATCH;
GO
--task8
SET NOCOUNT ON;

BEGIN TRY
    SELECT 
        EmployeeID,
        Name,
        Department,
        Salary,
        AVG(Salary) OVER (PARTITION BY Department) AS DeptAvgSalary,
        Salary - AVG(Salary) OVER (PARTITION BY Department) AS DiffFromAvg
    FROM Employees;
END TRY
BEGIN CATCH
    PRINT 'Error in Task 8: ' + ERROR_MESSAGE();
END CATCH;
GO
--task9
SET NOCOUNT ON;

BEGIN TRY
    SELECT 
        EmployeeID,
        Name,
        Department,
        Salary,
        AVG(Salary) OVER (ORDER BY EmployeeID ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS MovingAvgSalary
    FROM Employees;
END TRY
BEGIN CATCH
    PRINT 'Error in Task 9: ' + ERROR_MESSAGE();
END CATCH;
GO
--task10
SET NOCOUNT ON;

BEGIN TRY
    SELECT TOP 1
           SUM(Salary) OVER (ORDER BY HireDate DESC ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS SumLast3Hired
    FROM Employees
    ORDER BY HireDate DESC;
END TRY
BEGIN CATCH
    PRINT 'Error in Task 10 (Option A): ' + ERROR_MESSAGE();
END CATCH;
GO
--task11
SET NOCOUNT ON;

BEGIN TRY
    SELECT 
        EmployeeID,
        Name,
        Department,
        Salary,
        AVG(Salary) OVER (ORDER BY EmployeeID ROWS UNBOUNDED PRECEDING) AS RunningAvgSalary
    FROM Employees;
END TRY
BEGIN CATCH
    PRINT 'Error in Task 11: ' + ERROR_MESSAGE();
END CATCH;
GO
--task12
SET NOCOUNT ON;

BEGIN TRY
    SELECT 
        EmployeeID,
        Name,
        Department,
        Salary,
        MAX(Salary) OVER (ORDER BY EmployeeID ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING) AS MaxSlidingSalary
    FROM Employees;
END TRY
BEGIN CATCH
    PRINT 'Error in Task 12: ' + ERROR_MESSAGE();
END CATCH;
GO
--task13
SET NOCOUNT ON;

BEGIN TRY
    SELECT 
        EmployeeID,
        Name,
        Department,
        Salary,
        SUM(Salary) OVER (PARTITION BY Department) AS TotalDeptSalary,
        (Salary * 100.0 / SUM(Salary) OVER (PARTITION BY Department)) AS PercentContribution
    FROM Employees;
END TRY
BEGIN CATCH
    PRINT 'Error in Task 13: ' + ERROR_MESSAGE();
END CATCH;
GO
