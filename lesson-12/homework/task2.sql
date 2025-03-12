SET NOCOUNT ON;
GO

IF OBJECT_ID('dbo.sp_GetProcFuncParameters', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_GetProcFuncParameters;
GO

CREATE PROCEDURE dbo.sp_GetProcFuncParameters
    @DatabaseName NVARCHAR(128) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @sql NVARCHAR(MAX);

    -- If a database name is provided, build and execute a query for that database only.
    IF @DatabaseName IS NOT NULL
    BEGIN
        SET @sql = N'
            SELECT 
                ''' + @DatabaseName + ''' AS DatabaseName,
                SCHEMA_NAME(o.schema_id) AS SchemaName,
                o.name AS ObjectName,
                p.name AS ParameterName,
                t.name AS ParameterDataType,
                p.max_length AS ParameterMaxLength,
                p.parameter_id AS ParameterOrdinal
            FROM [' + @DatabaseName + '].sys.objects o
            LEFT JOIN [' + @DatabaseName + '].sys.parameters p
                ON o.object_id = p.object_id
            LEFT JOIN [' + @DatabaseName + '].sys.types t
                ON p.user_type_id = t.user_type_id
            WHERE o.type IN (''P'',''FN'',''TF'',''IF'')
            ORDER BY SchemaName, ObjectName, p.parameter_id;
        ';
        BEGIN TRY
            EXEC sp_executesql @sql;
        END TRY
        BEGIN CATCH
            PRINT 'Error in sp_GetProcFuncParameters for database ' + @DatabaseName + ': ' + ERROR_MESSAGE();
        END CATCH
    END
    ELSE
    BEGIN
        -- Process all user databases (exclude master, tempdb, model, msdb)
        DECLARE @dbName NVARCHAR(128);

        DECLARE db_cursor CURSOR LOCAL FAST_FORWARD FOR
            SELECT name 
            FROM sys.databases
            WHERE name NOT IN ('master','tempdb','model','msdb')
              AND state_desc = 'ONLINE'
            ORDER BY name;

        OPEN db_cursor;
        FETCH NEXT FROM db_cursor INTO @dbName;
        WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @sql = N'
                SELECT 
                    ''' + @dbName + ''' AS DatabaseName,
                    SCHEMA_NAME(o.schema_id) AS SchemaName,
                    o.name AS ObjectName,
                    p.name AS ParameterName,
                    t.name AS ParameterDataType,
                    p.max_length AS ParameterMaxLength,
                    p.parameter_id AS ParameterOrdinal
                FROM [' + @dbName + '].sys.objects o
                LEFT JOIN [' + @dbName + '].sys.parameters p
                    ON o.object_id = p.object_id
                LEFT JOIN [' + @dbName + '].sys.types t
                    ON p.user_type_id = t.user_type_id
                WHERE o.type IN (''P'',''FN'',''TF'',''IF'')
                ORDER BY Schema_NAME(o.schema_id), o.name, p.parameter_id;
            ';
            BEGIN TRY
                EXEC sp_executesql @sql;
            END TRY
            BEGIN CATCH
                PRINT 'Error in sp_GetProcFuncParameters for database ' + @dbName + ': ' + ERROR_MESSAGE();
            END CATCH

            FETCH NEXT FROM db_cursor INTO @dbName;
        END

        CLOSE db_cursor;
        DEALLOCATE db_cursor;
    END
END
GO

-- Example usage:
-- To get info for a specific database:
-- EXEC dbo.sp_GetProcFuncParameters @DatabaseName = 'YourDatabaseName';
--
-- To get info for all user databases:
-- EXEC dbo.sp_GetProcFuncParameters;
