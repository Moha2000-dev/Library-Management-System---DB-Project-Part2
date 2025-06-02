
--  Transactions – Ensuring Consistency


-- 1. Borrowing a Book (Loan insert + update availability)

BEGIN TRANSACTION;
BEGIN TRY
    INSERT INTO Loan (Book_ID, Member_ID, Loan_Date, Due_Date, Status)
    VALUES (1, 1, GETDATE(), DATEADD(DAY, 14, GETDATE()), 'Issued');

    UPDATE Book SET Availability_Status = 0 WHERE Book_ID = 1;

    COMMIT;
    PRINT ' Borrowing successful';
END TRY
BEGIN CATCH
    ROLLBACK;
    PRINT ' Error during borrowing: ' + ERROR_MESSAGE();
END CATCH;



-- 2. Returning a Book (update status, return date, availability)

BEGIN TRANSACTION;
BEGIN TRY
    UPDATE Loan
    SET Return_Date = GETDATE(), Status = 'Returned'
    WHERE Loan_ID = (SELECT MAX(Loan_ID) FROM Loan WHERE Return_Date IS NULL);

    UPDATE Book
    SET Availability_Status = 1
    WHERE Book_ID = (
        SELECT Book_ID FROM Loan
        WHERE Loan_ID = (SELECT MAX(Loan_ID) FROM Loan WHERE Return_Date = GETDATE())
    );

    COMMIT;
  
END TRY
BEGIN CATCH
    ROLLBACK;
    PRINT 'Error during return: ' + ERROR_MESSAGE();
END CATCH;



-- 3. Registering a Payment (with validation)
BEGIN TRANSACTION;
BEGIN TRY
    DECLARE @Amount DECIMAL(10, 2) = 10.00;

    IF @Amount <= 0
        THROW 50000, 'Invalid payment amount.', 1;

    INSERT INTO Payment (Date, Amount, Method_ID)
    VALUES (GETDATE(), @Amount, 1);  -- Ensure Method_ID = 1 exists

    COMMIT;
  
END TRY
BEGIN CATCH
    ROLLBACK;
    PRINT ' Error during payment: ' + ERROR_MESSAGE();
END CATCH;



-- 4. Batch Loan Insert with Rollback on Failure

BEGIN TRANSACTION;
BEGIN TRY
    INSERT INTO Loan (Book_ID, Member_ID, Loan_Date, Due_Date, Status)
    VALUES 
        (2, 2, GETDATE(), DATEADD(DAY, 10, GETDATE()), 'Issued'),
        (3, 3, GETDATE(), DATEADD(DAY, 7, GETDATE()), 'Issued');

    UPDATE Book SET Availability_Status = 0 WHERE Book_ID IN (2, 3);

    COMMIT;
END TRY
BEGIN CATCH
    ROLLBACK;
    PRINT ' Error in batch insert: ' + ERROR_MESSAGE();
END CATCH;


--///////////////////////////////////////////////////////////////////////////////////////testing///////////////////////////////////////////////////////////////////
SELECT * FROM Loan;
SELECT * FROM Book;
SELECT * FROM Payment;
