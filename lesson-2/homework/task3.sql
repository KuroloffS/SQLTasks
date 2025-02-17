-- Ensure the Photos table doesn't exist
IF OBJECT_ID('dbo.Photos', 'U') IS NOT NULL
    DROP TABLE dbo.Photos;
GO

-- Create the Photos table
CREATE TABLE Photos (
    id INT IDENTITY(1,1) PRIMARY KEY,
    image_data VARBINARY(MAX)
);
GO

-- Insert the image using OPENROWSET (adjust the file path as needed)
INSERT INTO Photos (image_data)
SELECT BulkColumn 
FROM OPENROWSET(BULK 'C:\Temp\edinarog.jpg', SINGLE_BLOB) AS ImageFile;
GO

-- Verify the insert
SELECT id, DATALENGTH(image_data) AS ImageSizeBytes
FROM Photos;
GO
