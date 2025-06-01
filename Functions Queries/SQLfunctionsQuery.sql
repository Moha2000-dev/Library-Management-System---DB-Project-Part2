-- 1. GetBookAverageRating(BookID)
CREATE FUNCTION GetBookAverageRating (@BookID INT)
RETURNS FLOAT
AS
BEGIN
    DECLARE @AvgRating FLOAT;
    SELECT @AvgRating = AVG(Rating)
    FROM Review
    WHERE Book_ID = @BookID;
    RETURN ISNULL(@AvgRating, 0);
END;

-- 2. GetNextAvailableBook(Genre, Title, LibraryID)
CREATE FUNCTION GetNextAvailableBook (
    @Genre NVARCHAR(100),
    @Title NVARCHAR(255),
    @LibraryID INT
)
RETURNS TABLE
AS
RETURN (
    SELECT TOP 1 *
    FROM Book
    WHERE Genre = @Genre AND Title = @Title AND Library_ID = @LibraryID AND Availability_Status = 1
    ORDER BY Book_ID
);

-- 3. CalculateLibraryOccupancyRate(LibraryID)
CREATE FUNCTION CalculateLibraryOccupancyRate (@LibraryID INT)
RETURNS FLOAT
AS
BEGIN
    DECLARE @TotalBooks INT, @IssuedBooks INT;

    SELECT @TotalBooks = COUNT(*) FROM Book WHERE Library_ID = @LibraryID;
    SELECT @IssuedBooks = COUNT(*) 
    FROM Book b
    WHERE b.Library_ID = @LibraryID AND b.Availability_Status = 0;

    RETURN CASE 
        WHEN @TotalBooks = 0 THEN 0
        ELSE CAST(@IssuedBooks AS FLOAT) / @TotalBooks * 100
    END;
END;

-- 4. fn_GetMemberLoanCount(MemberID)
CREATE FUNCTION fn_GetMemberLoanCount (@MemberID INT)
RETURNS INT
AS
BEGIN
    DECLARE @Count INT;
    SELECT @Count = COUNT(*) FROM Loan WHERE Member_ID = @MemberID;
    RETURN @Count;
END;

-- 5. fn_GetLateReturnDays(LoanID)
CREATE FUNCTION fn_GetLateReturnDays (@LoanID INT)
RETURNS INT
AS
BEGIN
    DECLARE @DueDate DATE, @ReturnDate DATE, @Days INT;
    SELECT @DueDate = Due_Date, @ReturnDate = Return_Date FROM Loan WHERE Loan_ID = @LoanID;

    IF @ReturnDate IS NULL OR @ReturnDate <= @DueDate
        SET @Days = 0;
    ELSE
        SET @Days = DATEDIFF(DAY, @DueDate, @ReturnDate);

    RETURN @Days;
END;

-- 6. fn_ListAvailableBooksByLibrary(@LibraryID)
CREATE FUNCTION fn_ListAvailableBooksByLibrary (@LibraryID INT)
RETURNS TABLE
AS
RETURN (
    SELECT Book_ID, Title, Genre, Price
    FROM Book
    WHERE Library_ID = @LibraryID AND Availability_Status = 1
);

-- 7. fn_GetTopRatedBooks()
CREATE FUNCTION fn_GetTopRatedBooks ()
RETURNS TABLE
AS
RETURN (
    SELECT b.Book_ID, b.Title, AVG(r.Rating) AS AvgRating
    FROM Book b
    JOIN Review r ON b.Book_ID = r.Book_ID
    GROUP BY b.Book_ID, b.Title
    HAVING AVG(r.Rating) >= 4.5
);

-- 8. fn_FormatMemberName(FirstName, LastName)
CREATE FUNCTION fn_FormatMemberName (
    @FirstName NVARCHAR(100),
    @LastName NVARCHAR(100)
)
RETURNS NVARCHAR(201)
AS
BEGIN
    RETURN CONCAT(@LastName, ', ', @FirstName);
END;
