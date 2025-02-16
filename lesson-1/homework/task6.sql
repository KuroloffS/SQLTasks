-- Drop the table if it exists
DROP TABLE IF EXISTS customer;

-- Create the customer table with an explicitly named DEFAULT constraint
CREATE TABLE customer (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),  -- No constraint
    city VARCHAR(100) CONSTRAINT DF_customer_city DEFAULT 'Unknown'
);

-- Drop the DEFAULT constraint using its explicit name
ALTER TABLE customer DROP CONSTRAINT DF_customer_city;

-- Re-add the DEFAULT constraint using ALTER TABLE
ALTER TABLE customer 
ADD CONSTRAINT DF_customer_city DEFAULT 'Unknown' FOR city;

-- Select data to verify structure
SELECT * FROM customer;
