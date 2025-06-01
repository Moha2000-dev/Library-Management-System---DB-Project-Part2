

USE LibrarySystemDB;
GO

-- 1-GET loans overdue
SELECT m.Name, b.Title, l.Due_Date
FROM Loan l
JOIN Member m ON l.Member_ID = m.Member_ID
JOIN Book b ON l.Book_ID = b.Book_ID
WHERE l.Status = 'Overdue';


-- 2-GET books unavailable
SELECT Title
FROM Book
WHERE Availability_Status = 1; --ALL ARE ZERO (TEST BY 1)

-- 3-GET members top-borrowers
SELECT m.Name, COUNT(*) AS BorrowedBooks
FROM Loan l
JOIN Member m ON l.Member_ID = m.Member_ID
GROUP BY m.Name
HAVING COUNT(*) > 1;-- MUST BE 2 BUT I DONT HAVE (TEST BY 1 )

-- 4-GET books ratings
-- Declare the variable
DECLARE @BookID INT = 1;
SELECT AVG(Rating) AS AverageRating
FROM Review
WHERE Book_ID = @BookID;

-- 5-GET libraries genres
-- Declare the variable
DECLARE @LibraryID INT = 1;
SELECT Genre, COUNT(*) AS CountPerGenre
FROM Book
WHERE Library_ID = @LibraryID
GROUP BY Genre;

-- 6-GET members the no lonass 
SELECT m.*
FROM Member m
LEFT JOIN Loan l ON m.Member_ID = l.Member_ID
WHERE l.Loan_ID IS NULL;

-- 7-GET payments summary per member 
SELECT m.Name, SUM(p.Amount) AS TotalPaid
FROM Payment p
JOIN Loan l ON p.Payment_ID = l.Payment_ID
JOIN Member m ON l.Member_ID = m.Member_ID
GROUP BY m.Name;

-- 8- GET  reviews
SELECT m.Name, b.Title, r.Rating, r.Comments
FROM Review r
JOIN Member m ON r.Member_ID = m.Member_ID
JOIN Book b ON r.Book_ID = b.Book_ID;

-- 9- GET books popular
SELECT TOP 3 b.Title, COUNT(*) AS LoanCount
FROM Loan l
JOIN Book b ON l.Book_ID = b.Book_ID
GROUP BY b.Title
ORDER BY LoanCount DESC;

--10- GET  the members history
DECLARE @MemberID INT = 1;
SELECT b.Title, l.Loan_Date, l.Return_Date
FROM Loan l
JOIN Book b ON l.Book_ID = b.Book_ID
WHERE l.Member_ID = @MemberID;

-- 11- GET books reviews
DECLARE @BookID INT = 1;
SELECT m.Name, r.Comments
FROM Review r
JOIN Member m ON r.Member_ID = m.Member_ID
WHERE r.Book_ID = @BookID;

-- 12- GET all the staff working in guiven  libraries 
DECLARE @LibraryID INT = 2;
SELECT *
FROM Staff
WHERE Library_ID = @LibraryID;

-- 13- GET all the books that price-range btween 5 and 15 
SELECT *
FROM Book
WHERE Price BETWEEN 5 AND 15;

-- 14- GET all loans wich are active
SELECT m.Name, b.Title, l.Loan_Date
FROM Loan l
JOIN Member m ON l.Member_ID = m.Member_ID
JOIN Book b ON l.Book_ID = b.Book_ID
WHERE l.Return_Date IS NULL;

--  15- GET all members with-fines
SELECT DISTINCT m.*
FROM Loan l
JOIN Payment p ON l.Payment_ID = p.Payment_ID
JOIN Member m ON l.Member_ID = m.Member_ID
WHERE p.Amount > 0;

-- 16- GET all books that never been reviewed
SELECT b.*
FROM Book b
LEFT JOIN Review r ON b.Book_ID = r.Book_ID
WHERE r.Review_ID IS NULL;

-- 17- GET  giveb members with loan-history
DECLARE @MemberID INT = 1;
SELECT b.Title, l.Status, l.Loan_Date, l.Return_Date
FROM Loan l
JOIN Book b ON l.Book_ID = b.Book_ID
WHERE l.Member_ID = @MemberID;

-- 18- GET members inactive (never borrowed)
SELECT m.*
FROM Member m
LEFT JOIN Loan l ON m.Member_ID = l.Member_ID
WHERE l.Member_ID IS NULL;

-- 19- GET all bookswich never-loaned
SELECT b.*
FROM Book b
LEFT JOIN Loan l ON b.Book_ID = l.Book_ID
WHERE l.Book_ID IS NULL;

--20- GET all payments with names and titles and amount 
SELECT m.Name, b.Title, p.Amount
FROM Payment p
JOIN Loan l ON p.Payment_ID = l.Payment_ID
JOIN Member m ON l.Member_ID = m.Member_ID
JOIN Book b ON l.Book_ID = b.Book_ID;

-- 21- GET listt all members lona and bbok detiles 
SELECT 
    l.Loan_ID,
    m.Member_ID,
    m.Name AS MemberName,
    m.Email,
    m.Phone,
    b.Book_ID,
    b.Title AS BookTitle,
    b.Genre,
    b.Price,
    l.Loan_Date,
    l.Due_Date,
    l.Status
FROM Loan l
JOIN Member m ON l.Member_ID = m.Member_ID
JOIN Book b ON l.Book_ID = b.Book_ID
WHERE l.Status = 'Overdue';


-- 22- GET given  booksid and count loan-count
DECLARE @BookID INT = 2;
SELECT COUNT(*) AS LoanCount
FROM Loan
WHERE Book_ID = @BookID;

-- 23- GET all members fines
DECLARE @MemberID INT = 2;
SELECT SUM(p.Amount) AS TotalFine
FROM Payment p
JOIN Loan l ON p.Payment_ID = l.Payment_ID
WHERE l.Member_ID = @MemberID;

-- 24- GET /libraries/:id/book-stats
DECLARE @LibraryID INT = 2;
SELECT
    SUM(CASE WHEN Availability_Status = 1 THEN 1 ELSE 0 END) AS AvailableBooks,
    SUM(CASE WHEN Availability_Status = 0 THEN 1 ELSE 0 END) AS UnavailableBooks
FROM Book
WHERE Library_ID = @LibraryID;

--25- GET /reviews/top-rated
SELECT b.Title, COUNT(*) AS ReviewCount, AVG(r.Rating) AS AvgRating
FROM Review r
JOIN Book b ON r.Book_ID = b.Book_ID
GROUP BY b.Title
HAVING COUNT(*) >= 5 AND AVG(r.Rating) >= 4.0;





----------------------------------------------------------INSERTS TO TEST THE PROGRAM-----------------------------------------------------------------------------------------------
-- Insert Members
INSERT INTO Member (Name, Email, Phone, Membership_Start_Date)
VALUES 
('Ali Al-Busaidi', 'ali101@email.com', '99887766', '2023-01-01'),
('Sara Al-Harthy', 'sara102@email.com', '99887777', '2023-01-02'),
('Nasser Al-Zadjali', 'nasser103@email.com', '99887788', '2023-01-03'),
('Huda Al-Lawati', 'huda104@email.com', '99887799', '2023-01-04'),
('Mona Al-Salti', 'mona105@email.com', '99887711', '2023-01-05'),
('Talal Al-Riyami', 'talal106@email.com', '99887722', '2023-01-06'),
('Ahmed Al-Kindi', 'ahmed107@email.com', '99887733', '2023-01-07'),
('Fatma Al-Maskari', 'fatma108@email.com', '99887744', '2023-01-08'),
('Hassan Al-Balushi', 'hassan109@email.com', '99887755', '2023-01-09'),
('Aisha Al-Shukaili', 'aisha110@email.com', '99887766', '2023-01-10'),
('Rashid Al-Nabhani', 'rashid111@email.com', '99887777', '2023-01-11'),
('Noora Al-Farsi', 'noora112@email.com', '99887788', '2023-01-12'),
('Khalid Al-Amri', 'khalid113@email.com', '99887799', '2023-01-13'),
('Laila Al-Zakwani', 'laila114@email.com', '99887700', '2023-01-14');

-- Insert Books with safe genre 'Fiction'
INSERT INTO Book (ISBN, Title, Genre, Price, Shelf_Location, Availability_Status, Library_ID)
VALUES 
('9781234567890', 'Clean Code', 'Fiction', 30.00, 'A1', 1, 1),
('9780987654321', 'The Pragmatic Programmer', 'Fiction', 28.00, 'A2', 1, 1),
('9781111111111', 'Design Patterns', 'Fiction', 35.00, 'B1', 1, 1),
('9782222222222', 'Code Complete', 'Fiction', 40.00, 'B2', 1, 1);



INSERT INTO Review (Member_ID, Book_ID, Review_Date, Comments, Rating)
VALUES 
(1, 1, '2024-01-01', 'Excellent book!', 5),
(2, 1, '2024-01-02', 'Very useful.', 5),
(3, 1, '2024-01-03', 'Highly recommend.', 4),
(4, 1, '2024-01-04', 'Great for beginners.', 5),
(5, 1, '2024-01-05', 'Loved it.', 5),
(6, 1, '2024-01-06', 'Outstanding!', 5),

(7, 2, '2024-02-01', 'Good insights.', 4),
(10, 2, '2024-02-03', 'Learned a lot.', 5),
(11, 2, '2024-02-04', 'Awesome.', 5),
(12, 2, '2024-02-05', 'Good examples.', 5),
(13, 2, '2024-02-06', 'Informative.', 5),
(14, 2, '2024-02-07', 'Solid read.', 5),

(15, 3, '2024-03-01', 'Hard to follow.', 3),
(16, 3, '2024-03-02', 'Complex.', 3),
(17, 3, '2024-03-03', 'Needs better examples.', 3),
(18, 3, '2024-03-04', 'Challenging but useful.', 4),
(19, 3, '2024-03-05', 'Good content.', 4),
(20, 3, '2024-03-06', 'Very theoretical.', 3);
