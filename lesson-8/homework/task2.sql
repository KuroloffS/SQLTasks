SET NOCOUNT ON;

BEGIN TRY
    -- Drop the table if it already exists
    IF OBJECT_ID('dbo.EMPLOYEES_N', 'U') IS NOT NULL
        DROP TABLE dbo.EMPLOYEES_N;
    GO

    -- Create the EMPLOYEES_N table
    CREATE TABLE [dbo].[EMPLOYEES_N]
    (
        [EMPLOYEE_ID] INT NOT NULL,
        [FIRST_NAME]  VARCHAR(20) NULL,
        [HIRE_DATE]   DATE NOT NULL
    );
    GO

    PRINT 'Table [dbo].[EMPLOYEES_N] created successfully.';
END TRY
BEGIN CATCH
    PRINT 'Error occurred while creating [dbo].[EMPLOYEES_N]: ' + ERROR_MESSAGE();
END CATCH;
GO
