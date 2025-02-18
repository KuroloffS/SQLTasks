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
    SELECT 
        OrderStatus,
        COUNT(*) AS TotalOrders,
        SUM(TotalAmount) AS TotalRevenue
    FROM (
        SELECT 
            TotalAmount,
            -- Compute a new OrderStatus based on the original Status.
            CASE 
                WHEN Status IN ('Shipped', 'Delivered') THEN 'Completed'
                WHEN Status = 'Pending' THEN 'Pending'
                WHEN Status = 'Cancelled' THEN 'Cancelled'
                ELSE 'Unknown'
            END AS OrderStatus,
            OrderDate
        FROM Orders
        WHERE OrderDate BETWEEN '2023-01-01' AND '2023-12-31'
    ) AS FilteredOrders
    GROUP BY OrderStatus
    HAVING SUM(TotalAmount) > 5000
    ORDER BY TotalRevenue DESC;
END TRY
BEGIN CATCH
    PRINT 'An error occurred in Task 2: ' + ERROR_MESSAGE();
END CATCH;
