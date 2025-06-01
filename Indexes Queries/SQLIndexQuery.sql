-- Indexing Strategy Script

-- 1. Library Table
CREATE NONCLUSTERED INDEX IX_Library_Name ON Library(Name);
CREATE NONCLUSTERED INDEX IX_Library_Location ON Library(Location);

-- 2. Book Table
CREATE NONCLUSTERED INDEX IX_Book_LibraryID_ISBN ON Book(Library_ID, ISBN);
CREATE NONCLUSTERED INDEX IX_Book_Genre ON Book(Genre);

-- 3. Loan Table
CREATE NONCLUSTERED INDEX IX_Loan_MemberID ON Loan(Member_ID);
CREATE NONCLUSTERED INDEX IX_Loan_Status ON Loan(Status);
CREATE NONCLUSTERED INDEX IX_Loan_Book_Loan_Return 
    ON Loan(Book_ID, Loan_Date, Return_Date);


-----------------------------------------------------------------------------------------------Testing-------------------------------------------------------------------------------------------------------------

-- 1. Library Table Tests

-- a. Search by Name 
SELECT * 
FROM Library 
WHERE Name = 'Central Library';

-- b. Filter by Location 
SELECT DISTINCT Location FROM Library;
SELECT * FROM Library WHERE Location = 'Central';


-- 2. Book Table Tests
-- a. Lookup by Library_ID and ISBN 
SELECT * 
FROM Book 
WHERE Library_ID = 1 AND ISBN = '9781234567890';

-- b. Filter by Genre 
SELECT * 
FROM Book 
WHERE Genre = 'Fiction';

-- 3. Loan Table Tests
-- a. Member loan history 
SELECT * 
FROM Loan 
WHERE Member_ID = 5;

-- b. Filter by Status 
SELECT * 
FROM Loan 
WHERE Status = 'Overdue';

-- c. Composite index for overdue logic 
SELECT * 
FROM Loan 
WHERE Book_ID = 4 AND Loan_Date >= '2024-01-10' AND Return_Date IS NULL;

