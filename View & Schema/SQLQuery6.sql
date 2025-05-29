Use SchemaSQL;
CREATE TABLE Employee ( 
    EmployeeID INT PRIMARY KEY, 
    FullName VARCHAR(100), 
    Position VARCHAR(50), 
    HireDate DATE 
);

CREATE TABLE Trainer ( 
    TrainerID INT PRIMARY KEY, 
    FullName VARCHAR(100), 
    Specialization VARCHAR(100) 
); 
 
CREATE TABLE Attendance ( 
    AttendanceID INT PRIMARY KEY, 
    EmployeeID INT, 
    Date DATE, 
    Status VARCHAR(20) 
); 
CREATE TABLE Course ( 
    CourseID INT PRIMARY KEY, 
    CourseName VARCHAR(100), 
    DurationWeeks INT 
); 
 
CREATE TABLE Batch ( 
    BatchID INT PRIMARY KEY, 
    CourseID INT, 
    StartDate DATE, 
    EndDate DATE 
);
CREATE TABLE Exam ( 
    ExamID INT PRIMARY KEY, 
    CourseID INT, 
    ExamDate DATE 
); 
 
CREATE TABLE Result ( 
    ResultID INT PRIMARY KEY, 
    ExamID INT, 
    EmployeeID INT, 
    Score INT 
); 
CREATE TABLE Client ( 
    ClientID INT PRIMARY KEY, 
    ClientName VARCHAR(100), 
    ContactPerson VARCHAR(100) 
); 
CREATE TABLE Contract ( 
    ContractID INT PRIMARY KEY, 
    ClientID INT, 
    StartDate DATE, 
    EndDate DATE, 
    TotalValue DECIMAL(10,2) 
);
CREATE TABLE Payment ( 
    PaymentID INT PRIMARY KEY, 
    ContractID INT, 
    PaymentDate DATE, 
    Amount DECIMAL(10,2) 
);
--------------Insert Sample Data--------------
INSERT INTO dbo.Employee VALUES (1, 'Ali Al-Harthy', 'Admin', '2022-01-15'); 
INSERT INTO dbo.Trainer VALUES (101, 'Salim Al-Nabhani', 'Databases'); 
INSERT INTO dbo.Attendance VALUES (1001, 1, '2024-12-10', 'Present'); 
------------------------------------------------------------------------------------------------------------------- 
INSERT INTO dbo.Course VALUES (201, 'SQL Fundamentals', 4); 
INSERT INTO dbo.Batch VALUES (301, 201, '2025-01-10', '2025-02-07'); 
INSERT INTO dbo.Exam VALUES (401, 201, '2025-02-10'); 
INSERT INTO dbo.Result VALUES (501, 401, 1, 87); 
------------------------------------------------------------------------------------------------------------------ 
INSERT INTO dbo.Client VALUES (601, 'TechCorp LLC', 'Hassan Said'); 
INSERT INTO dbo.Contract VALUES (701, 601, '2025-01-01', '2025-12-31', 10000.00); 
INSERT INTO dbo.Payment VALUES (801, 701, '2025-02-01', 2000.00);


-----------------------------------------------------------------

-- View data from each table
SELECT * FROM Employee;
SELECT * FROM Trainer;
SELECT * FROM Attendance;
SELECT * FROM Course;
SELECT * FROM Batch;
SELECT * FROM Exam;
SELECT * FROM Result;
SELECT * FROM Client;
SELECT * FROM Contract;
SELECT * FROM Payment;

--------------------- Creat schemas --------------------
-- Schema HR
CREATE SCHEMA HR;
-- Schema Academics
CREATE SCHEMA Academics;
-- Schema Sales
CREATE SCHEMA Sales;


-- Transfer Table to the new SCHEMA 

ALTER SCHEMA HR TRANSFER dbo.Employee;
ALTER SCHEMA HR TRANSFER dbo.Trainer;
ALTER SCHEMA HR TRANSFER dbo.Attendance;

ALTER SCHEMA Academics TRANSFER dbo.Course;
ALTER SCHEMA Academics TRANSFER dbo.Batch;
ALTER SCHEMA Academics TRANSFER dbo.Exam;
ALTER SCHEMA Academics TRANSFER dbo.Result;

ALTER SCHEMA Sales TRANSFER dbo.Client;
ALTER SCHEMA Sales TRANSFER dbo.Contract;
ALTER SCHEMA Sales TRANSFER dbo.Payment;


--SELECT from one table
SELECT * FROM HR.Employee;
SELECT * FROM Academics.Course;
SELECT * FROM Sales.payment;

--Filtered Queries Using WHERE Clause
SELECT *
FROM HR.Employee
WHERE HireDate > '2022-01-01';

SELECT *
FROM Academics.Course
WHERE DurationWeeks = 4;

SELECT *
FROM Sales.Contract
WHERE TotalValue > 5000;


 --OPTIONAL: Create, Insert, and Select from a New Table
 CREATE TABLE Academics.Instructor (
    InstructorID INT PRIMARY KEY,
    FullName VARCHAR(100),
    SubjectSpecialty VARCHAR(100)
);

INSERT INTO Academics.Instructor (InstructorID, FullName, SubjectSpecialty)
VALUES 
(1, 'Fatma Al-Mahrooqi', 'SQL'),
(2, 'Ahmed Al-Farsi', 'Data Analysis');

SELECT * FROM Academics.Instructor;

  