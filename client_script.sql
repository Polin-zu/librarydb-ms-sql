USE LibraryDB;
GO

PRINT '--- 1. Добавление новых читателей и книг ---';
EXEC sp_AddReader 'Смирнов', 'Алексей', 'Владимирович', 'LIB004';
EXEC sp_AddBook '1984', 'Дж. Оруэлл', 'ББК 84(Вел)', 1949, 'Лондон', 'Secker & Warburg', 4;
GO

PRINT '--- 2. Поиск книг по названию и шифру ---';
EXEC sp_SearchBooks 'Война';
EXEC sp_SearchBooks 'ББК 84(34Вел)';
GO

PRINT '--- 3. Выдача книг (Читателю 1 - книгу 1, Читателю 2 - книгу 4) ---';
EXEC sp_IssueBook @BookID = 1, @ReaderID = 1, @DaysToReturn = 14;
EXEC sp_IssueBook @BookID = 4, @ReaderID = 2, @DaysToReturn = 7;
GO

PRINT '--- 4. Проверка доступных книг (VIEW) ---';
SELECT * FROM vw_AvailableBooks;
GO

PRINT '--- 5. Проверка, какие книги у читателя с ID=1 ---';
EXEC sp_GetReaderBooks 1;
GO

PRINT '--- 6. Проверка наличия конкретной книги (ID=1) ---';
EXEC sp_CheckAvailability 1;
GO

PRINT '--- 7. Возврат книги (LoanID=1) ---';
EXEC sp_ReturnBook 1;
GO

PRINT '--- 8. Проверка доступных книг после возврата ---';
SELECT * FROM vw_AvailableBooks;
GO

PRINT '--- 9. Отчет: Книги, выданные за период (за все время) ---';
EXEC sp_GetIssuedBooks '2020-01-01', '2030-12-31';
GO

PRINT '--- 10. Отчет: Книги, возвращенные за период ---';
EXEC sp_GetReturnedBooks '2020-01-01', '2030-12-31';
GO

PRINT '--- 11. Просмотр текущих выдач (кто что не вернул) ---';
SELECT * FROM vw_CurrentLoans;
GO