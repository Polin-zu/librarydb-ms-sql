-- Процедура: Добавление читателя
CREATE PROCEDURE sp_AddReader
    @LastName NVARCHAR(50),
    @FirstName NVARCHAR(50),
    @MiddleName NVARCHAR(50) = NULL,
    @CardNumber VARCHAR(20)
AS
BEGIN
    INSERT INTO Readers (LastName, FirstName, MiddleName, CardNumber)
    VALUES (@LastName, @FirstName, @MiddleName, @CardNumber);
END;
GO

-- Процедура: Добавление книги в каталог
CREATE PROCEDURE sp_AddBook
    @Title NVARCHAR(255),
    @Authors NVARCHAR(255),
    @LibraryCode VARCHAR(50),
    @PublishYear INT,
    @PublishPlace NVARCHAR(100) = NULL,
    @Publisher NVARCHAR(100) = NULL,
    @TotalCopies INT = 1
AS
BEGIN
    INSERT INTO Books (Title, Authors, LibraryCode, PublishYear, PublishPlace, Publisher, TotalCopies, AvailableCopies)
    VALUES (@Title, @Authors, @LibraryCode, @PublishYear, @PublishPlace, @Publisher, @TotalCopies, @TotalCopies);
END;
GO

-- Процедура: Выдача книги читателю
CREATE PROCEDURE sp_IssueBook
    @BookID INT,
    @ReaderID INT,
    @DaysToReturn INT = 14
AS
BEGIN
    DECLARE @Available INT;
    SELECT @Available = AvailableCopies FROM Books WHERE BookID = @BookID;
    
    IF @Available > 0
    BEGIN
        INSERT INTO Loans (BookID, ReaderID, IssueDate, DueDate)
        VALUES (@BookID, @ReaderID, GETDATE(), DATEADD(DAY, @DaysToReturn, GETDATE()));
    END
    ELSE
    BEGIN
        RAISERROR('Ошибка: Данная книга отсутствует в наличии.', 16, 1);
    END
END;
GO

-- Процедура: Возврат книги
CREATE PROCEDURE sp_ReturnBook
    @LoanID INT
AS
BEGIN
    UPDATE Loans
    SET ReturnDate = GETDATE()
    WHERE LoanID = @LoanID AND ReturnDate IS NULL;
END;
GO

-- Процедура: Поиск книг по названию или шифру
CREATE PROCEDURE sp_SearchBooks
    @SearchString NVARCHAR(255)
AS
BEGIN
    SELECT * FROM Books
    WHERE Title LIKE '%' + @SearchString + '%' 
       OR LibraryCode LIKE '%' + @SearchString + '%';
END;
GO

-- Процедура: Проверка наличия книги (Справочная информация)
CREATE PROCEDURE sp_CheckAvailability
    @BookID INT
AS
BEGIN
    SELECT Title, AvailableCopies,
           CASE WHEN AvailableCopies > 0 THEN 'В наличии' ELSE 'Нет в наличии' END AS Status
    FROM Books
    WHERE BookID = @BookID;
END;
GO

-- Процедура: Какие книги были выданы за данный промежуток времени
CREATE PROCEDURE sp_GetIssuedBooks
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    SELECT L.LoanID, B.Title, R.LastName + ' ' + R.FirstName AS ReaderName, L.IssueDate
    FROM Loans L
    JOIN Books B ON L.BookID = B.BookID
    JOIN Readers R ON L.ReaderID = R.ReaderID
    WHERE L.IssueDate BETWEEN @StartDate AND @EndDate;
END;
GO

-- Процедура: Какие книги были возвращены за данный промежуток времени
CREATE PROCEDURE sp_GetReturnedBooks
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    SELECT L.LoanID, B.Title, R.LastName + ' ' + R.FirstName AS ReaderName, L.ReturnDate
    FROM Loans L
    JOIN Books B ON L.BookID = B.BookID
    JOIN Readers R ON L.ReaderID = R.ReaderID
    WHERE L.ReturnDate BETWEEN @StartDate AND @EndDate;
END;
GO

-- Процедура: Какие книги находятся у данного читателя
CREATE PROCEDURE sp_GetReaderBooks
    @ReaderID INT
AS
BEGIN
    SELECT B.Title, L.IssueDate, L.DueDate
    FROM Loans L
    JOIN Books B ON L.BookID = B.BookID
    WHERE L.ReaderID = @ReaderID AND L.ReturnDate IS NULL;
END;
GO