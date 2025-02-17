-- =============================================
-- Script: data_types_demo - Common Data Types
-- =============================================

-- Drop the table if it already exists
IF OBJECT_ID('dbo.data_types_demo', 'U') IS NOT NULL
    DROP TABLE dbo.data_types_demo;
GO

-- Create the table with a variety of common data types
CREATE TABLE data_types_demo (
    DemoID INT IDENTITY(1,1) PRIMARY KEY,          -- Auto-incrementing primary key
    DemoInt INT,                                    -- Integer
    DemoBigInt BIGINT,                              -- Large integer
    DemoSmallInt SMALLINT,                          -- Small integer
    DemoTinyInt TINYINT,                            -- Tiny integer (0-255)
    DemoBit BIT,                                    -- Boolean (0 or 1)
    DemoDecimal DECIMAL(10,2),                      -- Fixed precision and scale
    DemoNumeric NUMERIC(10,2),                      -- Similar to DECIMAL
    DemoMoney MONEY,                                -- Currency value
    DemoFloat FLOAT,                                -- Floating-point number
    DemoReal REAL,                                  -- Approximate floating-point number
    DemoDate DATE,                                  -- Date only
    DemoTime TIME,                                  -- Time only
    DemoDateTime DATETIME,                          -- Date and time (accuracy: 3.33 ms)
    DemoDateTime2 DATETIME2,                        -- Date and time (higher precision)
    DemoDateTimeOffset DATETIMEOFFSET,              -- Date and time with time zone offset
    DemoChar CHAR(10),                              -- Fixed-length non-Unicode string
    DemoVarChar VARCHAR(50),                        -- Variable-length non-Unicode string
    DemoNChar NCHAR(10),                            -- Fixed-length Unicode string
    DemoNVarChar NVARCHAR(50),                      -- Variable-length Unicode string
    DemoUniqueIdentifier UNIQUEIDENTIFIER,          -- Globally unique identifier
    DemoBinary BINARY(5),                           -- Fixed-length binary data
    DemoVarBinary VARBINARY(50),                    -- Variable-length binary data
    DemoXML XML                                   -- XML data type
);
GO

-- Insert a sample row into the table
INSERT INTO data_types_demo (
    DemoInt,
    DemoBigInt,
    DemoSmallInt,
    DemoTinyInt,
    DemoBit,
    DemoDecimal,
    DemoNumeric,
    DemoMoney,
    DemoFloat,
    DemoReal,
    DemoDate,
    DemoTime,
    DemoDateTime,
    DemoDateTime2,
    DemoDateTimeOffset,
    DemoChar,
    DemoVarChar,
    DemoNChar,
    DemoNVarChar,
    DemoUniqueIdentifier,
    DemoBinary,
    DemoVarBinary,
    DemoXML
)
VALUES (
    100,                                     -- DemoInt
    10000000000,                             -- DemoBigInt
    32000,                                   -- DemoSmallInt
    255,                                     -- DemoTinyInt
    1,                                       -- DemoBit (true)
    12345.67,                                -- DemoDecimal
    76543.21,                                -- DemoNumeric
    98765.43,                                -- DemoMoney
    3.14159,                                 -- DemoFloat
    2.718,                                   -- DemoReal
    '2025-02-16',                            -- DemoDate
    '12:34:56.789',                          -- DemoTime
    '2025-02-16 12:34:56',                     -- DemoDateTime
    '2025-02-16 12:34:56.1234567',             -- DemoDateTime2
    '2025-02-16 12:34:56 -05:00',              -- DemoDateTimeOffset
    'FixedChar',                             -- DemoChar (will be padded to 10 characters)
    'This is a varchar value',               -- DemoVarChar
    N'NCharVal',                             -- DemoNChar (will be padded to 10 characters)
    N'This is an NVARCHAR value',            -- DemoNVarChar
    NEWID(),                                 -- DemoUniqueIdentifier (auto-generated)
    0x0102030405,                            -- DemoBinary (5 bytes)
    0xDEADBEEF,                              -- DemoVarBinary
    '<root><child>XML Data</child></root>'    -- DemoXML
);
GO

-- Retrieve and display the values from the table
SELECT * FROM data_types_demo;
GO
