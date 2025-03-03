WITH StatusGroups AS
(
    SELECT 
        StepNumber,
        Status,
        /* 
           Flag new group whenever the Status changes compared to the previous row.
           For the first row (no previous row), treat it as a new group by default.
        */
        CASE 
            WHEN LAG(Status) OVER (ORDER BY StepNumber) = Status THEN 0 
            ELSE 1 
        END AS IsNewGroup
    FROM YourTable
),
AccumulatedGroups AS
(
    SELECT
        StepNumber,
        Status,
        /* 
           Create a running total of IsNewGroup to produce a distinct group ID 
           each time the Status changes. 
        */
        SUM(IsNewGroup) OVER (
            ORDER BY StepNumber
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS GroupID
    FROM StatusGroups
)
SELECT 
    MIN(StepNumber) AS MinStepNumber,
    MAX(StepNumber) AS MaxStepNumber,
    Status,
    COUNT(*) AS ConsecutiveCount
FROM AccumulatedGroups
GROUP BY GroupID, Status
ORDER BY MinStepNumber;
