drop table if exists items;
go

create table items
(
	ID						varchar(10),
	CurrentQuantity			int,
	QuantityChange   		int,
	ChangeType				varchar(10),
	Change_datetime			datetime
);
go

insert into items values
('A0013', 278,   99 ,   'out', '2020-05-25 0:25'), 
('A0012', 377,   31 ,   'in',  '2020-05-24 22:00'),
('A0011', 346,   1  ,   'out', '2020-05-24 15:01'),
('A0010', 347,   1  ,   'out', '2020-05-23 5:00'),
('A009',  348,   102,   'in',  '2020-04-25 18:00'),
('A008',  246,   43 ,   'in',  '2020-04-25 2:00'),
('A007',  203,   2  ,   'out', '2020-02-25 9:00'),
('A006',  205,   129,   'out', '2020-02-18 7:00'),
('A005',  334,   1  ,   'out', '2020-02-18 6:00'),
('A004',  335,   27 ,   'out', '2020-01-29 5:00'),
('A003',  362,   120,   'in',  '2019-12-31 2:00'),
('A002',  242,   8  ,   'out', '2019-05-22 0:50'),
('A001',  250,   250,   'in',  '2019-05-20 0:45');

-- Create temporary tables to track batches and out events
DROP TABLE IF EXISTS #batches;
CREATE TABLE #batches (
    id INT IDENTITY(1,1) PRIMARY KEY,
    entry_date DATETIME,
    quantity INT,
    remaining_quantity INT,
    exit_date DATETIME
);

DROP TABLE IF EXISTS #outs;
CREATE TABLE #outs (
    id INT IDENTITY(1,1) PRIMARY KEY,
    out_date DATETIME,
    out_quantity INT
);

-- Populate batches with 'in' events in chronological order
INSERT INTO #batches (entry_date, quantity, remaining_quantity, exit_date)
SELECT Change_datetime, QuantityChange, QuantityChange, NULL
FROM items
WHERE ChangeType = 'in'
ORDER BY Change_datetime;

-- Populate outs with 'out' events in chronological order
INSERT INTO #outs (out_date, out_quantity)
SELECT Change_datetime, QuantityChange
FROM items
WHERE ChangeType = 'out'
ORDER BY Change_datetime;

-- Process each out event to deduct from batches (FIFO)
DECLARE @current_out_id INT = 1;
DECLARE @total_outs INT = (SELECT COUNT(*) FROM #outs);

WHILE @current_out_id <= @total_outs
BEGIN
    DECLARE @out_quantity INT, @out_date DATETIME;
    SELECT @out_quantity = out_quantity, @out_date = out_date
    FROM #outs
    WHERE id = @current_out_id;

    DECLARE @remaining_out INT = @out_quantity;

    WHILE @remaining_out > 0
    BEGIN
        DECLARE @batch_id INT;
        SELECT TOP 1 @batch_id = id
        FROM #batches
        WHERE remaining_quantity > 0 AND entry_date <= @out_date
        ORDER BY entry_date;

        IF @batch_id IS NULL
            BREAK;

        DECLARE @batch_remaining INT;
        SELECT @batch_remaining = remaining_quantity
        FROM #batches
        WHERE id = @batch_id;

        IF @batch_remaining >= @remaining_out
        BEGIN
            UPDATE #batches
            SET remaining_quantity = remaining_quantity - @remaining_out,
                exit_date = CASE WHEN remaining_quantity - @remaining_out = 0 THEN @out_date ELSE exit_date END
            WHERE id = @batch_id;

            SET @remaining_out = 0;
        END
        ELSE
        BEGIN
            SET @remaining_out = @remaining_out - @batch_remaining;

            UPDATE #batches
            SET remaining_quantity = 0,
                exit_date = @out_date
            WHERE id = @batch_id;
        END
    END

    SET @current_out_id = @current_out_id + 1;
END

-- Set exit_date for remaining batches to the latest event date
DECLARE @latest_date DATETIME;
SELECT @latest_date = MAX(Change_datetime) FROM items;

UPDATE #batches
SET exit_date = @latest_date
WHERE exit_date IS NULL;

-- Calculate intervals using numbers table for groups 0-4 (up to 450 days)
WITH numbers AS (
    SELECT 0 AS n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
),
batch_durations AS (
    SELECT 
        id,
        entry_date,
        quantity,
        remaining_quantity,
        exit_date,
        DATEDIFF(DAY, entry_date, exit_date) AS duration_days
    FROM #batches
)
SELECT
    SUM(CASE WHEN n = 0 THEN days_in_group * quantity ELSE 0 END) AS [1-90 days old],
    SUM(CASE WHEN n = 1 THEN days_in_group * quantity ELSE 0 END) AS [91-180 days old],
    SUM(CASE WHEN n = 2 THEN days_in_group * quantity ELSE 0 END) AS [181-270 days old],
    SUM(CASE WHEN n = 3 THEN days_in_group * quantity ELSE 0 END) AS [271-360 days old],
    SUM(CASE WHEN n = 4 THEN days_in_group * quantity ELSE 0 END) AS [361-450 days old]
FROM (
    SELECT 
        bd.id,
        bd.quantity,
        n.n,
        CASE 
            WHEN bd.duration_days < (n.n * 90 + 1) THEN 0
            WHEN bd.duration_days >= (n.n + 1) * 90 THEN 90
            ELSE bd.duration_days - (n.n * 90)
        END AS days_in_group
    FROM batch_durations bd
    CROSS JOIN numbers n
) AS interval_data;

select * from items;