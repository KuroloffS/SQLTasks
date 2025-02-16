-- Drop the table if it exists
DROP TABLE IF EXISTS invoice;

-- Create the invoice table with an IDENTITY column
CREATE TABLE invoice (
    invoice_id INT IDENTITY(1,1) PRIMARY KEY,
    amount DECIMAL(10,2)  -- No constraint
);

-- Insert 5 rows without specifying invoice_id
INSERT INTO invoice (amount) VALUES (100.50), (200.75), (150.00), (300.25), (250.60);

-- Enable IDENTITY_INSERT to manually insert a row with a specific invoice_id
SET IDENTITY_INSERT invoice ON;

-- Insert a row with invoice_id = 100
INSERT INTO invoice (invoice_id, amount) VALUES (100, 500.00);

-- Disable IDENTITY_INSERT to return to auto-increment mode
SET IDENTITY_INSERT invoice OFF;

-- Select data to verify the insertions
SELECT * FROM invoice;
