-- Drop the table if it exists
DROP TABLE IF EXISTS account;

-- Create the account table with explicitly named CHECK constraints
CREATE TABLE account (
    account_id INT PRIMARY KEY,
    balance DECIMAL(10,2),
    account_type VARCHAR(20),
    CONSTRAINT chk_balance CHECK (balance >= 0),
    CONSTRAINT chk_account_type CHECK (account_type IN ('Saving', 'Checking'))
);

-- Drop CHECK constraints using their explicit names
ALTER TABLE account DROP CONSTRAINT chk_balance;
ALTER TABLE account DROP CONSTRAINT chk_account_type;

-- Re-add CHECK constraints using ALTER TABLE
ALTER TABLE account 
ADD CONSTRAINT chk_balance CHECK (balance >= 0);

ALTER TABLE account 
ADD CONSTRAINT chk_account_type CHECK (account_type IN ('Saving', 'Checking'));

-- Select data to verify structure
SELECT * FROM account;
