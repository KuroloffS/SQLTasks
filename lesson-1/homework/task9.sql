-- Create the Book table
DROP TABLE IF EXISTS Loan;
DROP TABLE IF EXISTS Book;
DROP TABLE IF EXISTS Member;
CREATE TABLE Book (
    book_id INT PRIMARY KEY,
    title NVARCHAR(255) NOT NULL,
    author NVARCHAR(255) NOT NULL,
    published_year INT NOT NULL
);
GO

-- Create the Member table
CREATE TABLE Member (
    member_id INT PRIMARY KEY,
    name NVARCHAR(255) NOT NULL,
    email NVARCHAR(255) NOT NULL,
    phone_number NVARCHAR(50)
);
GO

-- Create the Loan table with foreign key constraints linking to Book and Member
CREATE TABLE Loan (
    loan_id INT PRIMARY KEY,
    book_id INT NOT NULL,
    member_id INT NOT NULL,
    loan_date DATE NOT NULL,
    return_date DATE NULL,
    CONSTRAINT FK_Loan_Book FOREIGN KEY (book_id) REFERENCES Book(book_id),
    CONSTRAINT FK_Loan_Member FOREIGN KEY (member_id) REFERENCES Member(member_id)
);
GO

-- Insert sample records into the Book table
INSERT INTO Book (book_id, title, author, published_year)
VALUES
    (1, 'The Great Gatsby', 'F. Scott Fitzgerald', 1925),
    (2, '1984', 'George Orwell', 1949),
    (3, 'To Kill a Mockingbird', 'Harper Lee', 1960);
GO

-- Insert sample records into the Member table
INSERT INTO Member (member_id, name, email, phone_number)
VALUES
    (1, 'Alice Johnson', 'alice@example.com', '555-1234'),
    (2, 'Bob Smith', 'bob@example.com', '555-5678'),
    (3, 'Charlie Brown', 'charlie@example.com', '555-9012');
GO

-- Insert sample records into the Loan table
INSERT INTO Loan (loan_id, book_id, member_id, loan_date, return_date)
VALUES
    (1, 1, 1, '2025-02-01', '2025-02-15'),  -- Alice borrowed "The Great Gatsby" and returned it.
    (2, 2, 1, '2025-02-05', NULL),           -- Alice borrowed "1984" and hasn't returned it yet.
    (3, 3, 2, '2025-02-10', '2025-02-20');    -- Bob borrowed "To Kill a Mockingbird" and returned it.
GO

SELECT * FROM Loan;
SELECT * FROM Book;
SELECT * FROM Member;