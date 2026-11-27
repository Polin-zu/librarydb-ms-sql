-- Триггер: При выдаче книги уменьшает AvailableCopies в таблице Books
CREATE TRIGGER trg_IssueBook
ON Loans
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE B
    SET B.AvailableCopies = B.AvailableCopies - 1
    FROM Books B
    INNER JOIN inserted I ON B.BookID = I.BookID;
END;
GO

-- Триггер: При возврате книги (обновлении ReturnDate) увеличивает AvailableCopies
CREATE TRIGGER trg_ReturnBook
ON Loans
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    -- Проверяем, что обновилось именно поле ReturnDate
    IF UPDATE(ReturnDate)
    BEGIN
        UPDATE B
        SET B.AvailableCopies = B.AvailableCopies + 1
        FROM Books B
        INNER JOIN inserted I ON B.BookID = I.BookID
        INNER JOIN deleted D ON I.LoanID = D.LoanID
        WHERE I.ReturnDate IS NOT NULL AND D.ReturnDate IS NULL;
    END
END;
GO