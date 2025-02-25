-- Employees Table
CREATE TABLE Employees
(
    EmployeeID   INT,
    Name         VARCHAR(50),
    DepartmentID INT,
    Salary       DECIMAL(10,2)
);

-- Sample Data for Employees
INSERT INTO Employees (EmployeeID, Name, DepartmentID, Salary)
VALUES
    (1, 'Alice',   101, 60000),
    (2, 'Bob',     102, 70000),
    (3, 'Charlie', 101, 65000),
    (4, 'David',   103, 72000),
    (5, 'Eva',     NULL,68000);

-- Departments Table
CREATE TABLE Departments
(
    DepartmentID   INT,
    DepartmentName VARCHAR(50)
);

-- Sample Data for Departments
INSERT INTO Departments (DepartmentID, DepartmentName)
VALUES
    (101, 'IT'),
    (102, 'HR'),
    (103, 'Finance'),
    (104, 'Marketing');

-- Projects Table
CREATE TABLE Projects
(
    ProjectID   INT,
    ProjectName VARCHAR(50),
    EmployeeID  INT
);

-- Sample Data for Projects
INSERT INTO Projects (ProjectID, ProjectName, EmployeeID)
VALUES
    (1, 'Alpha',  1),
    (2, 'Beta',   2),
    (3, 'Gamma',  1),
    (4, 'Delta',  4),
    (5, 'Omega',  NULL);
--1. INNER JOIN
SELECT 
    e.EmployeeID,
    e.Name,
    d.DepartmentName
FROM Employees e
INNER JOIN Departments d
    ON e.DepartmentID = d.DepartmentID;
--2. LEFT JOIN
SELECT 
    e.EmployeeID,
    e.Name,
    d.DepartmentName
FROM Employees e
LEFT JOIN Departments d
    ON e.DepartmentID = d.DepartmentID;
--3. RIGHT JOIN
BEGIN TRY
    SELECT
        d.DepartmentID,
        d.DepartmentName,
        e.EmployeeID,
        e.Name
    FROM Employees AS e
    RIGHT JOIN Departments AS d
        ON e.DepartmentID = d.DepartmentID;
END TRY
BEGIN CATCH
    PRINT 'Error in RIGHT JOIN query: ' + ERROR_MESSAGE();
END CATCH;
GO
--4. FULL OUTER JOIN
BEGIN TRY
    SELECT
        e.EmployeeID,
        e.Name,
        e.DepartmentID AS EmpDeptID,
        d.DepartmentID AS DeptDeptID,
        d.DepartmentName
    FROM Employees AS e
    FULL OUTER JOIN Departments AS d
        ON e.DepartmentID = d.DepartmentID;
END TRY
BEGIN CATCH
    PRINT 'Error in FULL OUTER JOIN query: ' + ERROR_MESSAGE();
END CATCH;
GO
--5. JOIN with Aggregation
BEGIN TRY
    SELECT 
        d.DepartmentName,
        COALESCE(SUM(e.Salary), 0) AS TotalSalary
    FROM Departments AS d
    LEFT JOIN Employees AS e
        ON d.DepartmentID = e.DepartmentID
    GROUP BY d.DepartmentName;
END TRY
BEGIN CATCH
    PRINT 'Error in JOIN with Aggregation query: ' + ERROR_MESSAGE();
END CATCH;
GO
--6. CROSS JOIN
BEGIN TRY
    SELECT 
        d.DepartmentName,
        p.ProjectName
    FROM Departments AS d
    CROSS JOIN Projects AS p;
END TRY
BEGIN CATCH
    PRINT 'Error in CROSS JOIN query: ' + ERROR_MESSAGE();
END CATCH;
GO
--7. MULTIPLE JOINS
BEGIN TRY
    SELECT
        e.EmployeeID,
        e.Name,
        d.DepartmentName,
        p.ProjectName
    FROM Employees AS e
    LEFT JOIN Departments AS d
        ON e.DepartmentID = d.DepartmentID
    LEFT JOIN Projects AS p
        ON e.EmployeeID = p.EmployeeID
    ORDER BY e.EmployeeID;
END TRY
BEGIN CATCH
    PRINT 'Error in MULTIPLE JOINS query: ' + ERROR_MESSAGE();
END CATCH;
GO
