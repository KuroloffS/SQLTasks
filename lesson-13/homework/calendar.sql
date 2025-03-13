SET NOCOUNT ON;

-- Determine the first and last day of the current month
DECLARE @MonthStart DATE = DATEADD(DAY, 1 - DAY(GETDATE()), CAST(GETDATE() AS DATE));
DECLARE @MonthEnd DATE = EOMONTH(GETDATE());

-- Generate a calendar for the month using a recursive CTE
WITH Calendar AS
(
    -- Start with the first day of the month
    SELECT 
        @MonthStart AS CalendarDate,
        DATENAME(WEEKDAY, @MonthStart) AS DayName,
        DATEPART(WEEK, @MonthStart) AS WeekNumber
    UNION ALL
    -- Recursively add one day until the end of the month is reached
    SELECT 
        DATEADD(DAY, 1, CalendarDate),
        DATENAME(WEEKDAY, DATEADD(DAY, 1, CalendarDate)),
        DATEPART(WEEK, DATEADD(DAY, 1, CalendarDate))
    FROM Calendar
    WHERE CalendarDate < @MonthEnd
)
SELECT 
    CalendarDate,
    DayName,
    WeekNumber
FROM Calendar
ORDER BY CalendarDate
OPTION (MAXRECURSION 0);
