-- 1. ViewPopularBooks: Books with average rating > 4.5 + total loans
CREATE VIEW ViewPopularBooks AS
SELECT 
    b.Book_ID,
    b.Title,
    COUNT(l.Loan_ID) AS TotalLoans,
    AVG(r.Rating) AS AverageRating
FROM Book b
LEFT JOIN Loan l ON b.Book_ID = l.Book_ID
LEFT JOIN Review r ON b.Book_ID = r.Book_ID
GROUP BY b.Book_ID, b.Title
HAVING AVG(r.Rating) > 4.5;

-- 2. ViewMemberLoanSummary: Member loan count + total fines paid
CREATE VIEW ViewMemberLoanSummary AS
SELECT 
    m.Member_ID,
    m.Name,
    COUNT(l.Loan_ID) AS TotalLoans,
    SUM(p.Amount) AS TotalFinesPaid
FROM Member m
LEFT JOIN Loan l ON m.Member_ID = l.Member_ID
LEFT JOIN Payment p ON l.Payment_ID = p.Payment_ID
GROUP BY m.Member_ID, m.Name;

-- 3. ViewAvailableBooks: Available books grouped by genre, ordered by price
CREATE OR ALTER VIEW ViewAvailableBooks AS
SELECT TOP 100 PERCENT
    Genre,
    Title,
    Price
FROM Book
WHERE Availability_Status = 1
ORDER BY Genre, Price; 


-- 4. ViewLoanStatusSummary: Loan stats (issued, returned, overdue) per library
CREATE VIEW ViewLoanStatusSummary AS
SELECT 
    lib.Library_ID,
    lib.Name AS LibraryName,
    l.Status,
    COUNT(*) AS StatusCount
FROM Loan l
JOIN Book b ON l.Book_ID = b.Book_ID
JOIN Library lib ON b.Library_ID = lib.Library_ID
GROUP BY lib.Library_ID, lib.Name, l.Status;

-- 5. ViewPaymentOverview: Payment info with member, book, and status
CREATE VIEW ViewPaymentOverview AS
SELECT 
    p.Payment_ID,
    m.Name AS MemberName,
    b.Title AS BookTitle,
    p.Amount,
    l.Status
FROM Payment p
JOIN Loan l ON p.Payment_ID = l.Payment_ID
JOIN Member m ON l.Member_ID = m.Member_ID
JOIN Book b ON l.Book_ID = b.Book_ID;


----------------------------------------------------------------------------------------------------------TESTING-----------------------------------------------------------------------------------------------------------------------
SELECT * FROM ViewPopularBooks;

SELECT * FROM ViewMemberLoanSummary;

SELECT * FROM ViewAvailableBooks;

SELECT * FROM ViewLoanStatusSummary;

SELECT * FROM ViewPaymentOverview;
