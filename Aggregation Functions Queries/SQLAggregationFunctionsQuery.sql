
--  Aggregation Dashboard Reports


-- 1. Total Fines Per Member

SELECT 
    m.Member_ID,
    m.Name,
    SUM(p.Amount) AS TotalFines
FROM Member m
JOIN Loan l ON m.Member_ID = l.Member_ID
JOIN Payment p ON l.Payment_ID = p.Payment_ID
GROUP BY m.Member_ID, m.Name;



PRINT '2. Most Active Libraries';
SELECT 
    lib.Library_ID,
    lib.Name AS LibraryName,
    COUNT(*) AS LoanCount
FROM Loan l
JOIN Book b ON l.Book_ID = b.Book_ID
JOIN Library lib ON b.Library_ID = lib.Library_ID
GROUP BY lib.Library_ID, lib.Name
ORDER BY LoanCount DESC;


-- 3. Average Book Price Per Genre

SELECT 
    Genre,
    AVG(Price) AS AvgPrice
FROM Book
GROUP BY Genre;


-- 4. Top 3 Most Reviewed Books

SELECT TOP 3 
    b.Title,
    COUNT(r.Review_ID) AS ReviewCount
FROM Review r
JOIN Book b ON r.Book_ID = b.Book_ID
GROUP BY b.Title
ORDER BY ReviewCount DESC;


-- 5. Library Revenue Report

SELECT 
    lib.Library_ID,
    lib.Name AS LibraryName,
    SUM(p.Amount) AS TotalRevenue
FROM Payment p
JOIN Loan l ON p.Payment_ID = l.Payment_ID
JOIN Book b ON l.Book_ID = b.Book_ID
JOIN Library lib ON b.Library_ID = lib.Library_ID
GROUP BY lib.Library_ID, lib.Name;


-- 6. Member Activity Summary (Loans + Fines)

SELECT 
    m.Member_ID,
    m.Name,
    COUNT(l.Loan_ID) AS TotalLoans,
    SUM(p.Amount) AS TotalFines
FROM Member m
LEFT JOIN Loan l ON m.Member_ID = l.Member_ID
LEFT JOIN Payment p ON l.Payment_ID = p.Payment_ID
GROUP BY m.Member_ID, m.Name;

