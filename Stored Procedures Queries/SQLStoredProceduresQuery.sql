

-- 1. sp_MarkBookUnavailable(BookID)
CREATE OR ALTER PROCEDURE sp_MarkBookUnavailable
    @BookID INT
AS
BEGIN
    UPDATE Book
    SET Availability_Status = 0
    WHERE Book_ID = @BookID;
END;
GO

-- 2. sp_UpdateLoanStatus()
CREATE OR ALTER PROCEDURE sp_UpdateLoanStatus
AS
BEGIN
    -- Update to 'Overdue' where due date has passed and not returned
    UPDATE Loan
    SET Status = 'Overdue'
    WHERE Return_Date IS NULL AND Due_Date < CAST(GETDATE() AS DATE);

    -- Update to 'Returned' where Return_Date is filled
    UPDATE Loan
    SET Status = 'Returned'
    WHERE Return_Date IS NOT NULL;

    -- Update to 'Issued' where active but not overdue
    UPDATE Loan
    SET Status = 'Issued'
    WHERE Return_Date IS NULL AND Due_Date >= CAST(GETDATE() AS DATE);
END;
GO

-- 3. sp_RankMembersByFines()
CREATE OR ALTER PROCEDURE sp_RankMembersByFines
AS
BEGIN
    SELECT 
        m.Member_ID,
        m.Name,
        SUM(p.Amount) AS TotalFines
    FROM Member m
    JOIN Loan l ON m.Member_ID = l.Member_ID
    JOIN Payment p ON l.Payment_ID = p.Payment_ID
    GROUP BY m.Member_ID, m.Name
    ORDER BY TotalFines DESC;
END;
GO


--///////////////////////////////////////////////////////////////////////////////////////////////////////testing////////////////////////////////////////////////////////////////////

--  Test Script for Stored Procedures

-- 1. Test sp_MarkBookUnavailable

SELECT Book_ID, Title, Availability_Status FROM Book WHERE Book_ID = 1;

EXEC sp_MarkBookUnavailable @BookID = 1;


SELECT Book_ID, Title, Availability_Status FROM Book WHERE Book_ID = 1;

-- 2. Test sp_UpdateLoanStatus

SELECT Loan_ID, Book_ID, Due_Date, Return_Date, Status FROM Loan;

EXEC sp_UpdateLoanStatus;


SELECT Loan_ID, Book_ID, Due_Date, Return_Date, Status FROM Loan;

-- 3. Test sp_RankMembersByFines

EXEC sp_RankMembersByFines;
