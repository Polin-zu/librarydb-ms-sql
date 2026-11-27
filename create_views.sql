-- Представление: Книги, доступные в наличии
CREATE VIEW vw_AvailableBooks AS
SELECT 
    BookID, Title, Authors, LibraryCode, AvailableCopies 
FROM Books 
WHERE AvailableCopies > 0;
GO

-- Представление: Текущие выдачи (книги на руках у читателей)
CREATE VIEW vw_CurrentLoans AS
SELECT 
    L.LoanID,
    R.LastName + ' ' + R.FirstName + ISNULL(' ' + R.MiddleName, '') AS ReaderName,
    B.Title AS BookTitle,
    L.IssueDate,
    L.DueDate
FROM Loans L
JOIN Readers R ON L.ReaderID = R.ReaderID
JOIN Books B ON L.BookID = B.BookID
WHERE L.ReturnDate IS NULL;
GO