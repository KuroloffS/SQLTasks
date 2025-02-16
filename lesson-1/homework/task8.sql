-- Drop the table if it exists
DROP TABLE IF EXISTS books;

-- Create the books table with all constraints
CREATE TABLE books (
    book_id INT IDENTITY(1,1) PRIMARY KEY,  -- Auto-increment
    title VARCHAR(255) NOT NULL,            -- Must not be empty
    price DECIMAL(10,2) CHECK (price > 0),  -- Must be greater than 0
    genre VARCHAR(50) DEFAULT 'Unknown'     -- Default value
);

-- Insert valid data (should succeed)
INSERT INTO books (title, price, genre) VALUES 
('Book A', 15.99, 'Fiction'),
('Book B', 22.50, 'Non-Fiction'),
('Book C', 10.00, 'Mystery');

-- Insert valid data without specifying genre (should default to 'Unknown')
INSERT INTO books (title, price) VALUES 
('Book D', 18.75);

-- Insert invalid data (should fail due to constraints)
BEGIN TRY
    INSERT INTO books (title, price) VALUES ('', 12.99);  -- Empty title (should fail)
END TRY
BEGIN CATCH
    PRINT 'ERROR: Title cannot be empty';
END CATCH;

BEGIN TRY
    INSERT INTO books (title, price) VALUES ('Book E', -5.00);  -- Price <= 0 (should fail)
END TRY
BEGIN CATCH
    PRINT 'ERROR: Price must be greater than 0';
END CATCH;

-- Select all books to verify successful insertions
SELECT * FROM books;
