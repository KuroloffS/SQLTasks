CREATE TABLE TestMax
(
    Year1 INT
    ,Max1 INT
    ,Max2 INT
    ,Max3 INT
);
GO
 
INSERT INTO TestMax 
VALUES
    (2001,10,101,87)
    ,(2002,103,19,88)
    ,(2003,21,23,89)
    ,(2004,27,28,91);

SET NOCOUNT ON;

BEGIN TRY
    SELECT 
        Year1,
        (SELECT MAX(v)
         FROM (VALUES (Max1), (Max2), (Max3)) AS T(v)
        ) AS MaximumValue
    FROM TestMax;
END TRY
BEGIN CATCH
    PRINT 'An error occurred: ' + ERROR_MESSAGE();
END CATCH;
GO
