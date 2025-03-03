

-- Drop tables if they exist to start fresh
IF OBJECT_ID('dbo.OrderDetails','U') IS NOT NULL DROP TABLE dbo.OrderDetails;
IF OBJECT_ID('dbo.Orders','U') IS NOT NULL DROP TABLE dbo.Orders;
IF OBJECT_ID('dbo.Products','U') IS NOT NULL DROP TABLE dbo.Products;
IF OBJECT_ID('dbo.Customers','U') IS NOT NULL DROP TABLE dbo.Customers;
GO

-- Create Customers Table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);
GO

-- Create Orders Table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE
);
GO

-- Create OrderDetails Table
CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT FOREIGN KEY REFERENCES Orders(OrderID),
    ProductID INT,
    Quantity INT,
    Price DECIMAL(10,2)
);
GO

-- Create Products Table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50)
);
GO

-- =======================================================
-- Query 1: Retrieve All Customers With Their Orders (Include Customers Without Orders)
-- =======================================================
SET NOCOUNT ON;
BEGIN TRY
    SELECT 
        c.CustomerID,
        c.CustomerName,
        o.OrderID,
        o.OrderDate
    FROM Customers c
    LEFT JOIN Orders o 
        ON c.CustomerID = o.CustomerID;
END TRY
BEGIN CATCH
    PRINT 'Error in Query 1 (All Customers with Orders): ' + ERROR_MESSAGE();
END CATCH;
GO

-- =======================================================
-- Query 2: Find Customers Who Have Never Placed an Order
-- =======================================================
SET NOCOUNT ON;
BEGIN TRY
    SELECT 
        c.CustomerID,
        c.CustomerName
    FROM Customers c
    LEFT JOIN Orders o 
        ON c.CustomerID = o.CustomerID
    WHERE o.OrderID IS NULL;
END TRY
BEGIN CATCH
    PRINT 'Error in Query 2 (Customers With No Orders): ' + ERROR_MESSAGE();
END CATCH;
GO

-- =======================================================
-- Query 3: List All Orders With Their Products
-- =======================================================
SET NOCOUNT ON;
BEGIN TRY
    SELECT 
        o.OrderID,
        o.OrderDate,
        p.ProductName,
        od.Quantity
    FROM Orders o
    INNER JOIN OrderDetails od 
        ON o.OrderID = od.OrderID
    INNER JOIN Products p 
        ON od.ProductID = p.ProductID
    ORDER BY o.OrderID;
END TRY
BEGIN CATCH
    PRINT 'Error in Query 3 (Orders with Products): ' + ERROR_MESSAGE();
END CATCH;
GO

-- =======================================================
-- Query 4: Find Customers With More Than One Order
-- =======================================================
SET NOCOUNT ON;
BEGIN TRY
    SELECT 
        c.CustomerID,
        c.CustomerName,
        COUNT(o.OrderID) AS OrderCount
    FROM Customers c
    INNER JOIN Orders o 
        ON c.CustomerID = o.CustomerID
    GROUP BY c.CustomerID, c.CustomerName
    HAVING COUNT(o.OrderID) > 1;
END TRY
BEGIN CATCH
    PRINT 'Error in Query 4 (Customers With >1 Order): ' + ERROR_MESSAGE();
END CATCH;
GO

-- =======================================================
-- Query 5: Find the Most Expensive Product in Each Order
-- =======================================================
SET NOCOUNT ON;
BEGIN TRY
    ;WITH MostExpensive AS (
        SELECT 
            od.OrderID,
            od.ProductID,
            od.Price,
            ROW_NUMBER() OVER (PARTITION BY od.OrderID ORDER BY od.Price DESC) AS rn
        FROM OrderDetails od
    )
    SELECT 
        me.OrderID,
        p.ProductName,
        me.Price AS HighestPrice
    FROM MostExpensive me
    INNER JOIN Products p 
        ON me.ProductID = p.ProductID
    WHERE me.rn = 1;
END TRY
BEGIN CATCH
    PRINT 'Error in Query 5 (Most Expensive Product in Each Order): ' + ERROR_MESSAGE();
END CATCH;
GO

-- =======================================================
-- Query 6: Find the Latest Order for Each Customer
-- =======================================================
SET NOCOUNT ON;
BEGIN TRY
    ;WITH LatestOrder AS (
        SELECT 
            o.CustomerID,
            o.OrderID,
            o.OrderDate,
            ROW_NUMBER() OVER (PARTITION BY o.CustomerID ORDER BY o.OrderDate DESC) AS rn
        FROM Orders o
    )
    SELECT 
        c.CustomerID,
        c.CustomerName,
        lo.OrderID,
        lo.OrderDate
    FROM LatestOrder lo
    INNER JOIN Customers c 
        ON lo.CustomerID = c.CustomerID
    WHERE lo.rn = 1;
END TRY
BEGIN CATCH
    PRINT 'Error in Query 6 (Latest Order for Each Customer): ' + ERROR_MESSAGE();
END CATCH;
GO

-- =======================================================
-- Query 7: Find Customers Who Ordered Only 'Electronics' Products
-- =======================================================
SET NOCOUNT ON;
BEGIN TRY
    SELECT DISTINCT c.CustomerID, c.CustomerName
    FROM Customers c
    INNER JOIN Orders o 
        ON c.CustomerID = o.CustomerID
    INNER JOIN OrderDetails od 
        ON o.OrderID = od.OrderID
    INNER JOIN Products p 
        ON od.ProductID = p.ProductID
    WHERE NOT EXISTS (
        SELECT 1
        FROM Orders o2
        INNER JOIN OrderDetails od2 
            ON o2.OrderID = od2.OrderID
        INNER JOIN Products p2 
            ON od2.ProductID = p2.ProductID
        WHERE o2.CustomerID = c.CustomerID
          AND p2.Category <> 'Electronics'
    );
END TRY
BEGIN CATCH
    PRINT 'Error in Query 7 (Customers Who Ordered Only Electronics): ' + ERROR_MESSAGE();
END CATCH;
GO

-- =======================================================
-- Query 8: Find Customers Who Ordered at Least One 'Stationery' Product
-- =======================================================
SET NOCOUNT ON;
BEGIN TRY
    SELECT DISTINCT c.CustomerID, c.CustomerName
    FROM Customers c
    INNER JOIN Orders o 
        ON c.CustomerID = o.CustomerID
    INNER JOIN OrderDetails od 
        ON o.OrderID = od.OrderID
    INNER JOIN Products p 
        ON od.ProductID = p.ProductID
    WHERE p.Category = 'Stationery';
END TRY
BEGIN CATCH
    PRINT 'Error in Query 8 (Customers Who Ordered at Least One Stationery Product): ' + ERROR_MESSAGE();
END CATCH;
GO

-- =======================================================
-- Query 9: Find Total Amount Spent by Each Customer
-- =======================================================
SET NOCOUNT ON;
BEGIN TRY
    SELECT 
        c.CustomerID,
        c.CustomerName,
        SUM(od.Quantity * od.Price) AS TotalSpent
    FROM Customers c
    INNER JOIN Orders o 
        ON c.CustomerID = o.CustomerID
    INNER JOIN OrderDetails od 
        ON o.OrderID = od.OrderID
    GROUP BY c.CustomerID, c.CustomerName;
END TRY
BEGIN CATCH
    PRINT 'Error in Query 9 (Total Amount Spent by Each Customer): ' + ERROR_MESSAGE();
END CATCH;
GO
