-- Таблица Читатели
CREATE TABLE Readers (
    ReaderID INT IDENTITY(1,1) PRIMARY KEY,
    LastName NVARCHAR(50) NOT NULL,
    FirstName NVARCHAR(50) NOT NULL,
    MiddleName NVARCHAR(50) NULL,
    CardNumber VARCHAR(20) NOT NULL UNIQUE, -- Номер читательского билета
    CardIssueDate DATE NOT NULL DEFAULT GETDATE() -- Дата выдачи билета
);
GO

-- Таблица Книги (Каталог)
CREATE TABLE Books (
    BookID INT IDENTITY(1,1) PRIMARY KEY,
    Title NVARCHAR(255) NOT NULL,
    Authors NVARCHAR(255) NOT NULL, -- Список авторов строкой
    LibraryCode VARCHAR(50) NOT NULL UNIQUE, -- Библиотечный шифр
    PublishYear INT NOT NULL,
    PublishPlace NVARCHAR(100) NULL,
    Publisher NVARCHAR(100) NULL,
    TotalCopies INT NOT NULL DEFAULT 1, -- Общее количество экземпляров
    AvailableCopies INT NOT NULL DEFAULT 1, -- Доступно в текущий момент
    CONSTRAINT CHK_Copies CHECK (AvailableCopies <= TotalCopies AND AvailableCopies >= 0)
);
GO

-- Таблица Выдачи книг (Регистрация взятых/возвращенных книг)
CREATE TABLE Loans (
    LoanID INT IDENTITY(1,1) PRIMARY KEY,
    BookID INT NOT NULL FOREIGN KEY REFERENCES Books(BookID),
    ReaderID INT NOT NULL FOREIGN KEY REFERENCES Readers(ReaderID),
    IssueDate DATE NOT NULL DEFAULT GETDATE(), -- Когда выдана
    DueDate DATE NOT NULL, -- Когда должна быть возвращена
    ReturnDate DATE NULL, -- Когда фактически возвращена (NULL = еще на руках)
    CONSTRAINT CHK_Dates CHECK (DueDate >= IssueDate),
    CONSTRAINT CHK_ReturnDate CHECK (ReturnDate IS NULL OR ReturnDate >= IssueDate)
);
GO