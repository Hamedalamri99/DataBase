Use ViewDB;

CREATE TABLE Customer ( 
    CustomerID INT PRIMARY KEY, 
    FullName NVARCHAR(100), 
    Email NVARCHAR(100), 
    Phone NVARCHAR(15), 
    SSN CHAR(9) 
); 
 
 
CREATE TABLE Account ( 
    AccountID INT PRIMARY KEY, 
    CustomerID INT FOREIGN KEY REFERENCES Customer(CustomerID), 
    Balance DECIMAL(10, 2), 
    AccountType VARCHAR(50), 
    Status VARCHAR(20) 
); 
 
CREATE TABLE Transactions ( 
    TransactionID INT PRIMARY KEY, 
    AccountID INT FOREIGN KEY REFERENCES Account(AccountID), 
    Amount DECIMAL(10, 2), 
    Type VARCHAR(10), -- Deposit, Withdraw 
    TransactionDate DATETIME 
); 
 
CREATE TABLE Loan ( 
    LoanID INT PRIMARY KEY, 
    CustomerID INT FOREIGN KEY REFERENCES Customer(CustomerID), 
    LoanAmount DECIMAL(12, 2), 
    LoanType VARCHAR(50), 
    Status VARCHAR(20) 
);


INSERT INTO Customer VALUES
(1, 'Alice Johnson', 'alice@example.com', '1234567890', '111223333'),
(2, 'Bob Smith', 'bob@example.com', '9876543210', '222334444'),
(3, 'Charlie Green', 'charlie@example.com', '4567891230', '333445555');

INSERT INTO Account VALUES
(101, 1, 15000.00, 'Savings', 'Active'),
(102, 1, 5000.00, 'Checking', 'Active'),
(103, 2, 8000.00, 'Savings', 'Inactive'),
(104, 3, 12000.00, 'Savings', 'Active');

INSERT INTO Transactions VALUES
(201, 101, 2000.00, 'Deposit', DATEADD(DAY, -10, GETDATE())),
(202, 102, 500.00, 'Withdraw', DATEADD(DAY, -5, GETDATE())),
(203, 103, 300.00, 'Withdraw', DATEADD(DAY, -40, GETDATE())), -- Old transaction
(204, 104, 1500.00, 'Deposit', DATEADD(DAY, -2, GETDATE()));

INSERT INTO Loan VALUES
(301, 1, 100000.00, 'Home Loan', 'Approved'),
(302, 2, 25000.00, 'Car Loan', 'Pending'),
(303, 3, 15000.00, 'Personal Loan', 'Rejected');

------------------------------------------------------------------
--To creat View 
CREATE VIEW vw_CustomerService AS
SELECT 
    c.FullName,
    c.Phone,
    a.Status AS AccountStatus
FROM Customer c
JOIN Account a ON c.CustomerID = a.CustomerID;

--  Sample Query Using the View
SELECT 
    FullName,
    Phone,
    AccountStatus
FROM vw_CustomerService
WHERE AccountStatus = 'Active';

select * From vw_CustomerService

--Finance Department View
CREATE VIEW vw_FinanceAccounts AS
SELECT 
    AccountID,
    Balance,
    AccountType
FROM Account;

Select * From vw_FinanceAccounts

--Loan Officer View
CREATE VIEW vw_LoanOfficer AS
SELECT 
    LoanID,
    CustomerID,
    LoanAmount,
    LoanType,
    Status AS LoanStatus
FROM Loan;

Select * From vw_LoanOfficer


--Transaction Summary View
CREATE VIEW vw_RecentTransactions AS
SELECT 
    AccountID,
    Amount,
    TransactionDate
FROM Transactions
WHERE TransactionDate >= DATEADD(DAY, -30, GETDATE());

Select * From vw_RecentTransactions

