
--  Advanced Aggregations – Analytical Insight


-- 1. HAVING for filtering aggregates:

-- Genres with more than 3 books and average price > 20

SELECT Genre, COUNT(*) AS BookCount, AVG(Price) AS AvgPrice
FROM Book
GROUP BY Genre
HAVING COUNT(*) > 3 AND AVG(Price) > 20;


-- 2. Subquery: Max price book per genre

SELECT b.Genre, b.Title, b.Price
FROM Book b
WHERE b.Price = (
    SELECT MAX(b2.Price)
    FROM Book b2
    WHERE b2.Genre = b.Genre
);


-- 3. Occupancy rate per library: % of books currently issued

SELECT 
    lib.Library_ID,
    lib.Name AS LibraryName,
    CAST(SUM(CASE WHEN b.Availability_Status = 0 THEN 1 ELSE 0 END) * 100.0 
         / COUNT(*) AS DECIMAL(5,2)) AS OccupancyRate
FROM Book b
JOIN Library lib ON b.Library_ID = lib.Library_ID
GROUP BY lib.Library_ID, lib.Name;


-- 4. Members with loans but no fine (i.e., NULL payment)

SELECT DISTINCT m.Member_ID, m.Name
FROM Member m
JOIN Loan l ON m.Member_ID = l.Member_ID
LEFT JOIN Payment p ON l.Payment_ID = p.Payment_ID
WHERE p.Payment_ID IS NULL;


-- 5. Genres with high average ratings (avg rating > 4.0)

SELECT b.Genre, AVG(r.Rating) AS AvgRating
FROM Review r
JOIN Book b ON r.Book_ID = b.Book_ID
GROUP BY b.Genre
HAVING AVG(r.Rating) > 4.0;

