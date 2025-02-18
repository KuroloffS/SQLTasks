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
    ;WITH MostExpensiveProducts AS (
        SELECT 
            Category,
            Price,
            Stock,
            IIF(Stock = 0, 'Out of Stock',
                IIF(Stock BETWEEN 1 AND 10, 'Low Stock', 'In Stock')) AS InventoryStatus,
            ROW_NUMBER() OVER (PARTITION BY Category ORDER BY Price DESC) AS rn
        FROM Products
    )
    SELECT 
        Category,
        Price,
        Stock,
        InventoryStatus
    FROM MostExpensiveProducts
    WHERE rn = 1
    ORDER BY Price DESC
    OFFSET 5 ROWS;  -- Skips the first 5 rows of the ordered result
END TRY
BEGIN CATCH
    PRINT 'An error occurred in the Product Inventory Check query: ' + ERROR_MESSAGE();
END CATCH;
