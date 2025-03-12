SET NOCOUNT ON;

BEGIN TRY
    DECLARE @sql NVARCHAR(MAX) = N'';

    -- Build a UNION ALL query for each user database
    SELECT @sql = @sql +
    N'UNION ALL
     SELECT ''' + d.name + ''' AS DatabaseName,
            s.name AS SchemaName,
            t.name AS TableName,
            c.name AS ColumnName,
            ty.name AS DataType
     FROM [' + d.name + '].sys.columns AS c
     INNER JOIN [' + d.name + '].sys.tables AS t
         ON c.object_id = t.object_id
     INNER JOIN [' + d.name + '].sys.types AS ty
         ON c.user_type_id = ty.user_type_id
     INNER JOIN [' + d.name + '].sys.schemas AS s
         ON t.schema_id = s.schema_id
     WHERE t.is_ms_shipped = 0
    ' + CHAR(13) + CHAR(10)
    FROM sys.databases AS d
    WHERE d.name NOT IN ('master','tempdb','model','msdb');  -- Exclude system databases

    -- If we have at least one user database, remove the first 'UNION ALL' and execute
    IF LEN(@sql) > 0
    BEGIN
        -- Remove the first UNION ALL
        SET @sql = STUFF(@sql, 1, 10, '');

        -- Add final ORDER BY
        SET @sql += '
        ORDER BY 
            DatabaseName,
            SchemaName,
            TableName,
            ColumnName;';

        PRINT 'Executing dynamic query against all user databases...';
        EXEC sp_executesql @sql;
    END
    ELSE
    BEGIN
        PRINT 'No user databases found.';
    END
END TRY
BEGIN CATCH
    PRINT 'Error occurred while retrieving database/schema/table/column info: ' + ERROR_MESSAGE();
END CATCH;
GO
