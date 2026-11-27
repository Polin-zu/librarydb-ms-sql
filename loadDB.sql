USE LibraryDB;
GO

-- Добавление читателей
INSERT INTO Readers (LastName, FirstName, MiddleName, CardNumber)
VALUES 
('Иванов', 'Иван', 'Иванович', 'LIB001'),
('Петров', 'Петр', 'Петрович', 'LIB002'),
('Сидорова', 'Анна', 'Сергеевна', 'LIB003');

-- Добавление книг
INSERT INTO Books (Title, Authors, LibraryCode, PublishYear, PublishPlace, Publisher, TotalCopies, AvailableCopies)
VALUES 
('Война и мир', 'Л.Н. Толстой', 'ББК 84(2Рос)1', 1869, 'Москва', 'Эксмо', 5, 5),
('Преступление и наказание', 'Ф.М. Достоевский', 'ББК 84(2Рос)2', 1866, 'Санкт-Петербург', 'Азбука', 3, 3),
('Мастер и Маргарита', 'М.А. Булгаков', 'ББК 84(2Рос)6', 1967, 'Москва', 'АСТ', 2, 2);
GO