USE [Project-Library Management System];

-- ===========================================
-- CREATE TABLES 
-- ===========================================

CREATE TABLE Library (
    LibraryID INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Location VARCHAR(100),
    ContactNumber VARCHAR(15),
    EstablishedYear INT CHECK (EstablishedYear > 1800)
);

CREATE TABLE Member (
    MemberID INT IDENTITY(1,1) PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    PhoneNumber VARCHAR(15),
    MembershipStartDate DATE NOT NULL
);

CREATE TABLE Book (
    BookID INT IDENTITY(1,1) PRIMARY KEY,
    LibraryID INT NOT NULL,
    ISBN VARCHAR(20) UNIQUE NOT NULL,
    Title VARCHAR(150) NOT NULL,
    Genre VARCHAR(50) NOT NULL CHECK (Genre IN ('Fiction', 'Non-fiction', 'Reference', 'Children')),
    Price DECIMAL(6,2) NOT NULL CHECK (Price > 0),
    AvailabilityStatus BIT DEFAULT 1,
    ShelfLocation VARCHAR(20),
    FOREIGN KEY (LibraryID) REFERENCES Library(LibraryID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Staff (
    StaffID INT IDENTITY(1,1) PRIMARY KEY,
    LibraryID INT NOT NULL,
    FullName VARCHAR(100) NOT NULL,
    Position VARCHAR(50),
    ContactNumber VARCHAR(15),
    FOREIGN KEY (LibraryID) REFERENCES Library(LibraryID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Loan (
    LoanID INT IDENTITY(1,1) PRIMARY KEY,
    MemberID INT NOT NULL,
    BookID INT NOT NULL,
    LoanDate DATE NOT NULL,
    DueDate DATE NOT NULL,
    ReturnDate DATE,
    Status VARCHAR(10) DEFAULT 'Issued' CHECK (Status IN ('Issued', 'Returned', 'Overdue')),
    FOREIGN KEY (MemberID) REFERENCES Member(MemberID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (BookID) REFERENCES Book(BookID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Payment (
    PaymentID INT IDENTITY(1,1) PRIMARY KEY,
    LoanID INT NOT NULL,
    PaymentDate DATE NOT NULL,
    Amount DECIMAL(6,2) NOT NULL CHECK (Amount > 0),
    Method VARCHAR(50) NOT NULL,
    FOREIGN KEY (LoanID) REFERENCES Loan(LoanID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Review (
    ReviewID INT IDENTITY(1,1) PRIMARY KEY,
    MemberID INT NOT NULL,
    BookID INT NOT NULL,
    Rating INT CHECK (Rating BETWEEN 1 AND 5),
    Comments TEXT DEFAULT 'No comments',
    ReviewDate DATE NOT NULL,
    FOREIGN KEY (MemberID) REFERENCES Member(MemberID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (BookID) REFERENCES Book(BookID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- ========================
-- INSERT REALISTIC DATA
-- ========================

-- Library table (with redundancy on ContactNumber and EstablishedYear)
INSERT INTO Library (Name, Location, ContactNumber, EstablishedYear) VALUES
('Central Library', 'Downtown', '1112223333', 1980),
('Central Library', 'Downtown', '1112223333', 1980),  -- duplicate library (repeating group issue)
('East Branch', 'East Street', '4445556666', 1995),
('West Branch', 'West Avenue', '7778889999', 2005);

-- Member table (introducing duplicated emails and partial data)
INSERT INTO Member (FullName, Email, PhoneNumber, MembershipStartDate) VALUES
('Alice Kim', 'alice@example.com', '1010101010', '2023-01-01'),
('Alice Kim', 'alice@example.com', '1010101010', '2023-01-01'), -- duplicate member (violates 1NF)
('Bob Lee', 'bob@example.com', '2020202020', '2023-03-15'),
('Clara Zhou', 'clara@example.com', '3030303030', '2023-05-10'),
('Daniel Singh', 'daniel@example.com', '4040404040', '2023-07-20'),
('Eva Martinez', NULL, '5050505050', '2023-09-01'), -- missing email, NULL not atomic
('Frank Wu', 'frank@example.com', NULL, '2023-11-11'); -- missing phone

-- Book table (introducing partial dependency and transitive dependency issues)
INSERT INTO Book (LibraryID, ISBN, Title, Genre, Price, AvailabilityStatus, ShelfLocation) VALUES
(1, '9780000000001', 'Clean Code', 'Reference', 45.00, 1, 'A1'),
(1, '9780000000001', 'Clean Code', 'Reference', 45.00, 1, 'A1'),  -- duplicate book (1NF violation)
(1, '9780000000002', 'Effective Java', 'Reference', 55.00, 1, 'A2'),
(2, '9780000000003', '1984', 'Fiction', 20.00, 1, 'B1'),
(2, '9780000000004', 'To Kill a Mockingbird', 'Fiction', 22.00, 1, 'B2'),
(3, '9780000000005', 'A Brief History of Time', 'Non-fiction', 30.00, 0, 'C1'),
(3, '9780000000006', 'Algorithms Unlocked', 'Reference', 40.00, 1, 'C2'),
(1, '9780000000007', 'The Hobbit', 'Fiction', 18.00, 1, 'A3'),
(2, '9780000000008', 'Harry Potter 1', 'Children', 25.00, 1, 'B3'),
(3, '9780000000009', 'Sapiens', 'Non-fiction', 35.00, 1, 'C3'),
(1, '9780000000010', 'Charlie and the Chocolate Factory', 'Children', 28.00, 1, 'A4'),
(1, NULL, 'Unknown Book', 'Mystery', 15.00, 1, 'A5'); -- NULL ISBN (violates 1NF atomicity)

-- Staff table (introducing transitive dependency on ContactNumber)
INSERT INTO Staff (LibraryID, FullName, Position, ContactNumber) VALUES
(1, 'Grace Park', 'Librarian', '1119990000'),
(1, 'Grace Park', 'Librarian', '1119990000'), -- duplicate staff (1NF)
(1, 'Hassan Omar', 'Assistant', '2229990000'),
(2, 'Irene Chen', 'Manager', '3339990000'),
(3, 'James Patel', 'Technician', '4449990000');

-- Loan table (introducing partial dependency on MemberID and BookID composite key)
INSERT INTO Loan (MemberID, BookID, LoanDate, DueDate, ReturnDate, Status) VALUES
(1, 3, '2024-05-01', '2024-05-10', NULL, 'Overdue'),
(2, 2, '2024-04-10', '2024-04-20', '2024-04-18', 'Returned'),
(3, 1, '2024-04-25', '2024-05-05', NULL, 'Issued'),
(4, 5, '2024-03-01', '2024-03-10', '2024-03-09', 'Returned'),
(5, 6, '2024-05-01', '2024-05-11', NULL, 'Issued'),
(6, 8, '2024-03-15', '2024-03-25', '2024-03-24', 'Returned'),
(1, 4, '2024-05-02', '2024-05-12', NULL, 'Issued'),
(3, 7, '2024-04-10', '2024-04-20', '2024-04-18', 'Returned'),
(1, NULL, '2024-06-01', '2024-06-11', NULL, 'Issued'); -- NULL BookID (violates atomicity)

-- Payment table (introducing transitive dependency)
INSERT INTO Payment (LoanID, PaymentDate, Amount, Method) VALUES
(1, '2024-05-15', 5.00, 'Cash'),
(2, '2024-04-18', 3.50, 'Card'),
(4, '2024-03-11', 2.00, 'Online'),
(6, '2024-03-25', 4.00, 'Cash'),
(7, '2024-06-01', 3.00, 'Cash'); -- LoanID that may not exist (referential integrity error)

-- Review table (introducing partial dependencies and missing values)
INSERT INTO Review (MemberID, BookID, Rating, Comments, ReviewDate) VALUES
(1, 3, 4, 'Thought-provoking.', '2024-05-01'),
(2, 2, 5, 'Highly recommend!', '2024-04-12'),
(3, 1, 3, 'Could be clearer.', '2024-04-27'),
(4, 5, 5, 'Mind-blowing!', '2024-03-10'),
(5, 6, 4, 'Good reference.', '2024-05-02'),
(6, 8, NULL, 'Great for kids.', '2024-03-16'), -- NULL rating (violates atomicity)
(7, 9, 5, NULL, '2024-04-01'); -- NULL comments (could be okay depending on rules, but may violate completeness)


-- ========================
-- DML SIMULATION
-- ========================

UPDATE Book SET AvailabilityStatus = 1 WHERE BookID = 3;
UPDATE Loan SET ReturnDate = '2024-05-11', Status = 'Returned' WHERE LoanID = 1;
DELETE FROM Review WHERE ReviewID = 1;
DELETE FROM Payment WHERE PaymentID = 2;

-- ================================
-- ERROR LOG TABLE
-- ================================

CREATE TABLE SqlErrorLog (
    ErrorID INT IDENTITY(1,1) PRIMARY KEY,
    AttemptedAction VARCHAR(255),
    SQLStatement TEXT,
    ErrorMessage TEXT,
    Cause TEXT,
    Resolution TEXT,
    LoggedAt DATETIME DEFAULT GETDATE()
);

-- ================================
-- ERROR SIMULATION LOG ENTRIES
-- ================================

INSERT INTO SqlErrorLog (AttemptedAction, SQLStatement, ErrorMessage, Cause, Resolution) VALUES
('Delete member with loan',
 'DELETE FROM Member WHERE MemberID = 1;',
 'Foreign key constraint violation on Loan table.',
 'Member has active loan records referencing MemberID.',
 'Delete related loans or use ON DELETE CASCADE.'),
('Delete member with reviews',
 'DELETE FROM Member WHERE MemberID = 2;',
 'Foreign key constraint violation on Review table.',
 'Member has existing reviews referencing MemberID.',
 'Delete related reviews or use ON DELETE CASCADE.'),
('Delete book on loan',
 'DELETE FROM Book WHERE BookID = 3;',
 'Foreign key constraint violation on Loan table.',
 'Book is currently referenced by active loans.',
 'Delete related loan records first or use ON DELETE CASCADE.'),
('Loan for non-existent member',
 'INSERT INTO Loan (MemberID, BookID, LoanDate, DueDate) VALUES (999, 2, GETDATE(), DATEADD(day, 14, GETDATE()));',
 'Foreign key constraint violation on MemberID.',
 'MemberID 999 does not exist in Member table.',
 'Ensure MemberID exists before inserting loan.'),
('Update book genre to disallowed value',
 'UPDATE Book SET Genre = ''Sci-Fi'' WHERE BookID = 2;',
 'CHECK constraint failed on Genre.',
 '''Sci-Fi'' is not allowed in Genre column.',
 'Use allowed genre values: Fiction, Non-fiction, Reference, Children.');

 Select * from Loan



-- ===========================================
--Error Log Simulation
-- ===========================================
-- 1. Delete a member who has active loan (will fail - FK constraint)
DELETE FROM Member WHERE MemberID = 1;
-- Error: Member has active loans → violates FK constraint.

-- 2. Delete a member who wrote book reviews (will fail - FK constraint)
DELETE FROM Member WHERE MemberID = 2;
-- Error: Member has reviews → violates FK constraint.

-- 3. Delete a book that is currently on loan (will fail - FK constraint)
DELETE FROM Book WHERE BookID = 3;
-- Error: Book is referenced in Loan table.

-- 4. Delete a book with multiple reviews (will fail - FK constraint)
DELETE FROM Book WHERE BookID = 2;
-- Error: Book is referenced in Review table.

-- 5. Insert a loan for non-existent member (will fail - FK constraint)
INSERT INTO Loan (MemberID, BookID, LoanDate, DueDate, Status)
VALUES (999, 2, '2024-06-01', '2024-06-10', 'Issued');
-- Error: MemberID 999 does not exist.

-- 6. Insert a loan for non-existent book (will fail - FK constraint)
INSERT INTO Loan (MemberID, BookID, LoanDate, DueDate, Status)
VALUES (1, 9999, '2024-06-01', '2024-06-10', 'Issued');
-- Error: BookID 9999 does not exist.

-- 7. Update book genre to disallowed value (will fail - CHECK constraint)
UPDATE Book SET Genre = 'Sci-Fi' WHERE BookID = 2;
-- Error: Genre must be one of: Fiction, Non-fiction, Reference, Children.

-- 8. Insert payment with zero amount (will fail - CHECK constraint)
INSERT INTO Payment (LoanID, PaymentDate, Amount, Method)
VALUES (1, '2024-06-01', 0.00, 'Cash');
--Error: Amount must be > 0.

-- 9. Insert payment with negative amount (will fail - CHECK constraint)
INSERT INTO Payment (LoanID, PaymentDate, Amount, Method)
VALUES (1, '2024-06-01', -10.00, 'Card');
-- Error: Amount must be > 0.

-- 10. Insert payment without method (will fail - NOT NULL constraint)
INSERT INTO Payment (LoanID, PaymentDate, Amount)
VALUES (1, '2024-06-01', 5.00);
-- Error: Method cannot be NULL.

-- 11. Insert review for non-existent book (will fail - FK constraint)
INSERT INTO Review (MemberID, BookID, Rating, Comments, ReviewDate)
VALUES (1, 9999, 4, 'Nice book.', '2024-06-01');
-- Error: BookID 9999 does not exist.

-- 12. Insert review for non-existent member (will fail - FK constraint)
INSERT INTO Review (MemberID, BookID, Rating, Comments, ReviewDate)
VALUES (9999, 1, 4, 'Very useful.', '2024-06-01');
-- Error: MemberID 9999 does not exist.

-- 13. Update Loan to non-existent MemberID (will fail - FK constraint)
UPDATE Loan SET MemberID = 999 WHERE LoanID = 1;
-- Error: Cannot update to a member that doesn't exist.



-- ===========================================
-- SELECT Queries
-- ===========================================
-- 1. GET /loans/overdue
SELECT 
    M.FullName AS MemberName,
    B.Title AS BookTitle,
    L.DueDate
FROM Loan L
JOIN Member M ON L.MemberID = M.MemberID
JOIN Book B ON L.BookID = B.BookID
WHERE L.DueDate < GETDATE() AND L.Status = 'Issued';


-- 2. GET /books/unavailable
SELECT 
    B.BookID,
    B.Title,
    B.Genre
FROM Book B
WHERE B.BookID IN (
    SELECT BookID
    FROM Loan
    WHERE Status = 'Issued'
);


-- 3. GET /members/top-borrowers
SELECT 
    M.MemberID,
    M.FullName,
    COUNT(L.LoanID) AS TotalLoans
FROM Member M
JOIN Loan L ON M.MemberID = L.MemberID
GROUP BY M.MemberID, M.FullName
HAVING COUNT(L.LoanID) > 2;


-- 4. GET /books/:id/ratings
SELECT 
    B.BookID,
    B.Title,
    AVG(R.Rating) AS AverageRating
FROM Book B
LEFT JOIN Review R ON B.BookID = R.BookID
GROUP BY B.BookID, B.Title;

-- 5. GET /libraries/:id/genres
SELECT 
    B.Genre,
    COUNT(*) AS BookCount
FROM Book B
WHERE B.LibraryID = ?
GROUP BY B.Genre;


-- 6. GET /members/inactive
SELECT 
    M.MemberID,
    M.FullName,
    M.Email
FROM Member M
LEFT JOIN Loan L ON M.MemberID = L.MemberID
WHERE L.LoanID IS NULL;

-- 7.  GET /payments/summary
SELECT 
    M.MemberID,
    M.FullName,
    SUM(P.Amount) AS TotalPaid
FROM Payment P
JOIN Loan L ON P.LoanID = L.LoanID
JOIN Member M ON L.MemberID = M.MemberID
GROUP BY M.MemberID, M.FullName;

-- 8. GET /reviews
SELECT 
    R.ReviewID,
    M.FullName AS Reviewer,
    B.Title AS BookTitle,
    R.Rating,
    R.Comments,
    R.ReviewDate
FROM Review R
JOIN Member M ON R.MemberID = M.MemberID
JOIN Book B ON R.BookID = B.BookID;
