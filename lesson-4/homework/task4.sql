CREATE TABLE letters
(
    letter CHAR(1)
);
GO

INSERT INTO letters(letter)
VALUES ('a'), ('a'), ('a'), 
       ('b'), ('c'), ('d'), ('e'), ('f');
GO
SET NOCOUNT ON;

BEGIN TRY
    SELECT letter
    FROM letters
    ORDER BY 
      CASE WHEN letter = 'b' THEN 0 ELSE 1 END, 
      letter;
END TRY
BEGIN CATCH
    PRINT 'Error ordering letters with ''b'' first: ' + ERROR_MESSAGE();
END CATCH;
GO
SET NOCOUNT ON;

BEGIN TRY
    SELECT letter
    FROM letters
    ORDER BY 
      CASE WHEN letter = 'b' THEN 1 ELSE 0 END, 
      letter;
END TRY
BEGIN CATCH
    PRINT 'Error ordering letters with ''b'' last: ' + ERROR_MESSAGE();
END CATCH;
GO
SET NOCOUNT ON;

BEGIN TRY
    ;WITH SortedNonB AS (
        SELECT letter,
               ROW_NUMBER() OVER (ORDER BY letter) AS rn
        FROM letters
        WHERE letter <> 'b'
    )
    SELECT letter
    FROM (
        -- First two non-'b' rows
        SELECT letter, rn AS sort_order
        FROM SortedNonB
        WHERE rn <= 2

        UNION ALL

        -- The 'b' row (forced to position 3)
        SELECT letter, 3 AS sort_order
        FROM letters
        WHERE letter = 'b'

        UNION ALL

        -- Remaining non-'b' rows, shifted by +1
        SELECT letter, rn + 1 AS sort_order
        FROM SortedNonB
        WHERE rn > 2
    ) t
    ORDER BY sort_order;
END TRY
BEGIN CATCH
    PRINT 'Error ordering letters with ''b'' as 3rd: ' + ERROR_MESSAGE();
END CATCH;
GO
