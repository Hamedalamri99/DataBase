Use UnionDB;

-- Create tables

CREATE TABLE Trainees (
    TraineeID INT PRIMARY KEY,
    FullName VARCHAR(100),
    Email VARCHAR(100),
    Program VARCHAR(50),
    GraduationDate DATE
);

CREATE TABLE Applicants (
    ApplicantID INT PRIMARY KEY,
    FullName VARCHAR(100),
    Email VARCHAR(100),
    Source VARCHAR(20),
    AppliedDate DATE
);

-- Insert sample data

INSERT INTO Trainees VALUES
(1, 'Layla Al Riyami', 'layla.r@example.com', 'Full Stack .NET', '2025-04-30'),
(2, 'Salim Al Hinai', 'salim.h@example.com', 'Outsystems', '2025-03-15'),
(3, 'Fatma Al Amri', 'fatma.a@example.com', 'Database Admin', '2025-05-01');

INSERT INTO Applicants VALUES
(101, 'Hassan Al Lawati', 'hassan.l@example.com', 'Website', '2025-05-02'),
(102, 'Layla Al Riyami', 'layla.r@example.com', 'Referral', '2025-05-05'), -- same person as trainee
(103, 'Aisha Al Farsi', 'aisha.f@example.com', 'Website', '2025-04-28');

--------------------------------------------------------
-- Part 1: UNION Practice

-- 1. List unique people who either trained or applied (no duplicates)
SELECT FullName, Email FROM Trainees
UNION
SELECT FullName, Email FROM Applicants;

-- 2. Use UNION ALL (with duplicates)
SELECT FullName, Email FROM Trainees
UNION ALL
SELECT FullName, Email FROM Applicants;

-- Observation: 'Layla Al Riyami' appears twice because she is in both tables.

-- 3. Find people who are in both tables (by Email)
-- Using INTERSECT (if supported)
SELECT FullName, Email FROM Trainees
INTERSECT
SELECT FullName, Email FROM Applicants;

-- If INTERSECT is NOT supported, use INNER JOIN:
SELECT t.FullName, t.Email
FROM Trainees t
INNER JOIN Applicants a ON t.Email = a.Email;




--------------------------------------------------------
------------ Part 2: DROP vs DELETE vs TRUNCATE Observation ----------
--------------------------------------------------------

-- 4. Delete trainees enrolled in 'Outsystems'
DELETE FROM Trainees WHERE Program = 'Outsystems';
SELECT * FROM Trainees;
-- Observation: Rows deleted, table structure still exists.

-- 5. Truncate Applicants table
-- (Warning: This deletes ALL data instantly and may not be rolled back)
TRUNCATE TABLE Applicants;
SELECT * FROM Applicants;
-- Observation: All Applicants data removed, table still exists.

-- 6. Drop Applicants table
DROP TABLE Applicants;
SELECT * FROM Applicants;

-- Observation: Applicants table removed completely.
-- Any SELECT on Applicants now results in error "table does not exist".

--------------------------------------------------------
-- Part 3: Batch Script & Transactions (SQL Server syntax)

-- Recreate Applicants table and sample data after DROP
CREATE TABLE Applicants (
    ApplicantID INT PRIMARY KEY,
    FullName VARCHAR(100),
    Email VARCHAR(100),
    Source VARCHAR(20),
    AppliedDate DATE
);

INSERT INTO Applicants VALUES
(101, 'Hassan Al Lawati', 'hassan.l@example.com', 'Website', '2025-05-02'),
(102, 'Layla Al Riyami', 'layla.r@example.com', 'Referral', '2025-05-05'),
(103, 'Aisha Al Farsi', 'aisha.f@example.com', 'Website', '2025-04-28');

-- Transaction block with error handling to insert two Applicants,
-- second insert has duplicate ID causing rollback.

BEGIN TRY
    BEGIN TRANSACTION;

    INSERT INTO Applicants VALUES (104, 'Zahra Al Amri', 'zahra.a@example.com', 'Referral', '2025-05-10');

    -- This will cause primary key violation
    INSERT INTO Applicants VALUES (104, 'Error User', 'error@example.com', 'Website', '2025-05-11');

    COMMIT;
END TRY
BEGIN CATCH
    ROLLBACK;
    PRINT 'Transaction rolled back due to error: ' + ERROR_MESSAGE();
END CATCH;


SELECT * FROM Applicants;
--------------------------------------------------------
-- Part 4: ACID Properties (comments for your notes)

-- Atomicity:
-- All operations in a transaction succeed or none do.
-- Example: Money transfer must debit and credit successfully together.

-- Consistency:
-- Database moves from one valid state to another, preserving constraints.
-- Example: Bank accounts balance remains consistent after transactions.

-- Isolation:
-- Transactions run independently without interference.
-- Example: Two users booking the last seat won't both succeed.

-- Durability:
-- Once committed, changes persist permanently even after crashes.
-- Example: Confirmed orders remain saved after power failure.
