
--  Triggers – Real-Time Business Logic

-- 1. trg_UpdateBookAvailability: After new loan → set book to unavailable
CREATE OR ALTER TRIGGER trg_UpdateBookAvailability
ON Loan
AFTER INSERT
AS
BEGIN
    UPDATE Book
    SET Availability_Status = 0
    WHERE Book_ID IN (SELECT Book_ID FROM inserted);
END;
GO

-- 2. trg_CalculateLibraryRevenue: After new payment → update library revenue

CREATE OR ALTER TRIGGER trg_CalculateLibraryRevenue
ON Payment
AFTER INSERT
AS
BEGIN
    DECLARE @LibraryID INT, @Amount DECIMAL(10,2);

    SELECT TOP 1
        @LibraryID = b.Library_ID,
        @Amount = i.Amount
    FROM inserted i
    JOIN Loan l ON i.Payment_ID = l.Payment_ID
    JOIN Book b ON l.Book_ID = b.Book_ID;

END;
GO

-- 3. trg_LoanDateValidation: Prevent invalid return dates on insert
CREATE OR ALTER TRIGGER trg_LoanDateValidation
ON Loan
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE Return_Date IS NOT NULL AND Return_Date < Loan_Date
    )
    BEGIN
        RAISERROR('Return date cannot be earlier than loan date.', 16, 1);
        ROLLBACK TRANSACTION;
    END
    ELSE
    BEGIN
        INSERT INTO Loan (Book_ID, Member_ID, Payment_ID, Loan_Date, Due_Date, Return_Date, Status)
        SELECT Book_ID, Member_ID, Payment_ID, Loan_Date, Due_Date, Return_Date, Status
        FROM inserted;
    END
END;
GO
  


 ----------------------------------------------------------------------------------------------------testing---------------------------------------------------------------------------------------------------------------


--  TRIGGER TEST SCRIPT (No LibraryRevenue Table)



--  1. Test: trg_UpdateBookAvailability


-- Check book availability before loan
SELECT Book_ID, Title, Availability_Status FROM Book WHERE Book_ID = 1;

-- Insert loan → trigger sets Availability_Status = 0
INSERT INTO Loan (Book_ID, Member_ID, Payment_ID, Loan_Date, Due_Date, Return_Date, Status)
VALUES (1, 1, NULL, '2024-06-01', '2024-06-10', NULL, 'Issued');

-- Check availability after
SELECT Book_ID, Title, Availability_Status FROM Book WHERE Book_ID = 1;



--  2. Test: trg_CalculateLibraryRevenue (with PRINT only)


-- Insert payment (linked later to a loan)
INSERT INTO Payment (Date, Amount, Method_ID)
VALUES (GETDATE(), 5.00, 1);


-- Link the payment to the most recent loan
DECLARE @NewPaymentID INT = SCOPE_IDENTITY();

-- Link it to the latest loan
UPDATE Loan
SET Payment_ID = @NewPaymentID
WHERE Loan_ID = (SELECT MAX(Loan_ID) FROM Loan);


-- Show which Library received the payment
SELECT b.Title, b.Library_ID, p.Amount
FROM Payment p
JOIN Loan l ON p.Payment_ID = l.Payment_ID
JOIN Book b ON l.Book_ID = b.Book_ID
WHERE p.Payment_ID = 6;




--  3. Test: trg_LoanDateValidation (should block invalid date)


-- Try inserting a loan with Return_Date before Loan_Date → should fail
BEGIN TRY
    INSERT INTO Loan (Book_ID, Member_ID, Payment_ID, Loan_Date, Due_Date, Return_Date, Status)
    VALUES (1, 1, NULL, '2024-06-10', '2024-06-15', '2024-06-05', 'Returned');
END TRY
BEGIN CATCH
    SELECT ERROR_MESSAGE() AS ValidationError;
END CATCH;


 --3b. Valid Loan Insert 


INSERT INTO Loan (Book_ID, Member_ID, Payment_ID, Loan_Date, Due_Date, Return_Date, Status)
VALUES (1, 1, NULL, '2024-06-01', '2024-06-10', '2024-06-08', 'Returned');
