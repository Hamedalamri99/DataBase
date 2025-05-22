Use SelectTask;

CREATE TABLE Users ( 
  UserID INT PRIMARY KEY, 
  FullName VARCHAR(100), 
  JoinDate DATE, 
  SubscriptionType VARCHAR(50) 
); 

CREATE TABLE Movies ( 
  MovieID INT PRIMARY KEY, 
  Title VARCHAR(100), 
  Genre VARCHAR(50), 
  ReleaseYear INT, 
  DurationMinutes INT 
); 

CREATE TABLE WatchHistory ( 
  WatchID INT PRIMARY KEY, 
  UserID INT, 
  MovieID INT, 
  WatchDate DATE, 
  WatchDuration INT
);

-- Users
INSERT INTO Users VALUES  
(1, 'Alice Johnson', '2023-01-15', 'Premium'), 
(2, 'Bob Smith', '2023-03-20', 'Standard'), 
(3, 'Charlie Lee', '2023-02-05', 'Basic'), 
(4, 'Diana Ray', '2023-04-10', 'Premium'), 
(5, 'Ethan Park', '2023-01-25', 'Standard'); 

-- Movies
INSERT INTO Movies VALUES 
(101, 'The Great Heist', 'Action', 2022, 120), 
(102, 'Laugh Out Loud', 'Comedy', 2023, 90), 
(103, 'Deep Dive', 'Documentary', 2021, 75), 
(104, 'Speed Chase', 'Action', 2023, 110), 
(105, 'Tears of Time', 'Drama', 2020, 105); 

-- WatchHistory
INSERT INTO WatchHistory VALUES 
(1001, 1, 101, '2023-05-01', 115), 
(1002, 1, 102, '2023-05-02', 90), 
(1003, 2, 103, '2023-05-03', 75), 
(1004, 3, 104, '2023-05-01', 100), 
(1005, 4, 105, '2023-05-04', 105);

-----------------------------------------------------------------------------------


-- Answer : 1 
SELECT FullName, SubscriptionType FROM Users;

-- Answer : 2
SELECT Title, DurationMinutes FROM Movies;

-- Answer : 3
SELECT * FROM WatchHistory;

-- Answer : 4
SELECT Title, Genre FROM Movies
WHERE ReleaseYear > 2020;

-- Answer : 5
SELECT FullName FROM Users
WHERE JoinDate > '2023-02-28';

-- Answer : 6
SELECT Title FROM Movies
WHERE DurationMinutes > 100;

-- Answer : 7
SELECT * FROM WatchHistory
WHERE UserID = 1;

-- Answer : 8
SELECT FullName FROM Users
ORDER BY JoinDate DESC;

-- Answer : 9
SELECT * FROM Movies
WHERE Genre = 'Action';

-- Answer : 10
SELECT * FROM WatchHistory
WHERE WatchDate = '2023-05-01';

-- Answer : 11
SELECT * FROM Movies
WHERE ReleaseYear = 2023;

-- Answer : 12 
SELECT FullName, SubscriptionType FROM Users
WHERE SubscriptionType <> 'Basic';

-- Answer : 13
SELECT * FROM Users
WHERE FullName LIKE '%a%' COLLATE SQL_Latin1_General_CP1_CI_AS;

-- Answer : 14
SELECT Title FROM Movies
WHERE DurationMinutes = 90;

-- Answer : 15
SELECT * FROM WatchHistory
WHERE WatchDuration > 100;

-- Answer : 16
SELECT FullName FROM Users
WHERE JoinDate BETWEEN '2023-01-01' AND '2023-01-31';

-- Answer : 17
SELECT * FROM Movies
ORDER BY Title ASC;


BACKUP DATABASE CompanyDB
TO DISK = 'C:\Users\codel\OneDrive\Desktop\DATA.BASE\DataBase\SelectTest_Backup1.bak'
WITH FORMAT,
NAME = 'Full Backup of SelectTest';