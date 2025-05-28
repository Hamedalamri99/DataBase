Use [ AggregationPractice];


CREATE TABLE Instructors ( 
    InstructorID INT PRIMARY KEY, 
    FullName VARCHAR(100), 
    Email VARCHAR(100), 
    JoinDate DATE 
); 
CREATE TABLE Categories ( 
    CategoryID INT PRIMARY KEY, 
    CategoryName VARCHAR(50) 
); 
CREATE TABLE Courses ( 
    CourseID INT PRIMARY KEY, 
    Title VARCHAR(100), 
    InstructorID INT, 
    CategoryID INT, 
    Price DECIMAL(6,2), 
    PublishDate DATE, 
	FOREIGN KEY (InstructorID) REFERENCES Instructors(InstructorID), 
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID) 
);


CREATE TABLE Students ( 
    StudentID INT PRIMARY KEY, 
    FullName VARCHAR(100), 
    Email VARCHAR(100), 
    JoinDate DATE 
); 
 
CREATE TABLE Enrollments ( 
    EnrollmentID INT PRIMARY KEY, 
    StudentID INT, 
    CourseID INT, 
    EnrollDate DATE, 
    CompletionPercent INT, 
	Rating INT CHECK (Rating BETWEEN 1 AND 5), 
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID), 
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID) 
);


-- Instructors 
INSERT INTO Instructors VALUES 
(1, 'Sarah Ahmed', 'sarah@learnhub.com', '2023-01-10'), 
(2, 'Mohammed Al-Busaidi', 'mo@learnhub.com', '2023-05-21'); 
-- Categories 
INSERT INTO Categories VALUES 
(1, 'Web Development'), 
(2, 'Data Science'), 
(3, 'Business'); 
-- Courses 
INSERT INTO Courses VALUES 
(101, 'HTML & CSS Basics', 1, 1, 29.99, '2023-02-01'), 
(102, 'Python for Data Analysis', 2, 2, 49.99, '2023-03-15'), 
(103, 'Excel for Business', 2, 3, 19.99, '2023-04-10'), 
(104, 'JavaScript Advanced', 1, 1, 39.99, '2023-05-01'); 
-- Students 
INSERT INTO Students VALUES 
(201, 'Ali Salim', 'ali@student.com', '2023-04-01'), 
(202, 'Layla Nasser', 'layla@student.com', '2023-04-05'), 
(203, 'Ahmed Said', 'ahmed@student.com', '2023-04-10'); 
-- Enrollments 
INSERT INTO Enrollments VALUES 
(1, 201, 101, '2023-04-10', 100, 5), 
(2, 202, 102, '2023-04-15', 80, 4), 

(3, 203, 101, '2023-04-20', 90, 4), 
(4, 201, 102, '2023-04-22', 50, 3), 
(5, 202, 103, '2023-04-25', 70, 4), 
(6, 203, 104, '2023-04-28', 30, 2), 
(7, 201, 104, '2023-05-01', 60, 3);

-----------------------Real App Use Cases--------------------------------
--Total number of order 
SELECT COUNT(*) AS TotalEnrollments
FROM Enrollments;

--The Average rating

SELECT AVG(Rating) AS AverageRating
FROM Enrollments;

--Course completion
SELECT 
    c.Title,
    AVG(e.CompletionPercent) AS AverageCompletion
FROM Enrollments e
JOIN Courses c ON e.CourseID = c.CourseID
GROUP BY c.Title;

--Total Revenue per Course
SELECT 
    c.Title,
    COUNT(e.EnrollmentID) AS TotalEnrollments,
    c.Price,
    COUNT(e.EnrollmentID) * c.Price AS TotalRevenue
FROM Courses c
LEFT JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY c.Title, c.Price;

---------------------------------- Beginner Level --------------------------

-- the total number of student 
SELECT COUNT(*) AS TotalStudents FROM Students;
--total number of enrollments
SELECT COUNT(*) AS TotalEnrollments FROM Enrollments;
--The average rating of each course
SELECT c.Title, AVG(e.Rating) AS AvgRating
FROM Courses c
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY c.Title;
--Total number of courses
SELECT i.FullName, COUNT(c.CourseID) AS CourseCount
FROM Instructors i
LEFT JOIN Courses c ON i.InstructorID = c.InstructorID
GROUP BY i.FullName;
--Number of courses 
SELECT cat.CategoryName, COUNT(c.CourseID) AS CourseCount
FROM Categories cat
LEFT JOIN Courses c ON cat.CategoryID = c.CategoryID
GROUP BY cat.CategoryName;
--Average course price
SELECT cat.CategoryName, AVG(c.Price) AS AvgPrice
FROM Categories cat
JOIN Courses c ON cat.CategoryID = c.CategoryID
GROUP BY cat.CategoryName;
--Maximum course price
SELECT MAX(Price) AS MaxCoursePrice FROM Courses;
--Min, Max, and Avg rating per course
SELECT c.Title,
       MIN(e.Rating) AS MinRating,
       MAX(e.Rating) AS MaxRating,
       AVG(e.Rating) AS AvgRating
FROM Courses c
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY c.Title;
--Count how many students gave rating = 5
SELECT COUNT(DISTINCT StudentID) AS StudentsRated5
FROM Enrollments
WHERE Rating = 5;

-------------Intermediate Level--------------------
--Average completion
SELECT c.Title, AVG(e.CompletionPercent) AS AvgCompletion
FROM Courses c
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY c.Title;
--Students enrolled in more than 1 course
SELECT StudentID, COUNT(DISTINCT CourseID) AS CourseCount
FROM Enrollments
GROUP BY StudentID
HAVING COUNT(DISTINCT CourseID) > 1;
--Revenue per course
SELECT c.Title,
       COUNT(e.EnrollmentID) * c.Price AS TotalRevenue
FROM Courses c
LEFT JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY c.Title, c.Price;
--Instructor name + distinct students
SELECT i.FullName, COUNT(DISTINCT e.StudentID) AS UniqueStudents
FROM Instructors i
JOIN Courses c ON i.InstructorID = c.InstructorID
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY i.FullName;
--Average enrollments per category
SELECT cat.CategoryName,
       AVG(courseEnrollCount) AS AvgEnrollmentsPerCourse
FROM (
    SELECT c.CourseID, c.CategoryID, COUNT(e.EnrollmentID) AS courseEnrollCount
    FROM Courses c
    LEFT JOIN Enrollments e ON c.CourseID = e.CourseID
    GROUP BY c.CourseID, c.CategoryID
) AS sub
JOIN Categories cat ON sub.CategoryID = cat.CategoryID
GROUP BY cat.CategoryName;
--Average course rating by instructor
SELECT i.FullName, AVG(e.Rating) AS AvgRating
FROM Instructors i
JOIN Courses c ON i.InstructorID = c.InstructorID
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY i.FullName;
--Top 3 courses by enrollments
SELECT TOP 3 c.Title, COUNT(e.EnrollmentID) AS EnrollmentsCount
FROM Courses c
LEFT JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY c.Title
ORDER BY EnrollmentsCount DESC;
--Average days to complete 100%
SELECT c.Title,
       AVG(DATEDIFF(DAY, e.EnrollDate, GETDATE())) AS AvgDaysToComplete
FROM Enrollments e
JOIN Courses c ON e.CourseID = c.CourseID
WHERE e.CompletionPercent = 100
GROUP BY c.Title;
--students who completed
SELECT c.Title,
       100.0 * SUM(CASE WHEN e.CompletionPercent = 100 THEN 1 ELSE 0 END) / COUNT(e.StudentID) AS CompletionPercent
FROM Courses c
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY c.Title;
--Courses published per year
SELECT YEAR(PublishDate) AS PublishYear, COUNT(CourseID) AS CoursesPublished
FROM Courses
GROUP BY YEAR(PublishDate);

--------------------Advanced Level---------------------------
--Student with most completed courses
SELECT TOP 1 c.Title, AVG(e.CompletionPercent) AS AvgCompletion
FROM Courses c
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY c.Title
ORDER BY AvgCompletion ASC;
--Instructor earnings from enrollments
SELECT i.FullName,
       SUM(c.Price) AS TotalEarnings
FROM Instructors i
JOIN Courses c ON i.InstructorID = c.InstructorID
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY i.FullName;
--Category avg rating (≥ 4)
SELECT cat.CategoryName, AVG(e.Rating) AS AvgRating
FROM Categories cat
JOIN Courses c ON cat.CategoryID = c.CategoryID
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY cat.CategoryName
HAVING AVG(e.Rating) >= 4;
--Students rated below 3 more than once
SELECT s.FullName, COUNT(*) AS LowRatingCount
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
WHERE e.Rating < 3
GROUP BY s.FullName
HAVING COUNT(*) > 1;
--Course with lowest average completion
SELECT TOP 1 c.Title, AVG(e.CompletionPercent) AS AvgCompletion
FROM Courses c
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY c.Title
ORDER BY AvgCompletion ASC;
--Students enrolled in all courses by instructor 1
SELECT s.StudentID, s.FullName
FROM Students s
WHERE NOT EXISTS (
    SELECT c.CourseID
    FROM Courses c
    WHERE c.InstructorID = 1
    AND NOT EXISTS (
        SELECT 1 FROM Enrollments e
        WHERE e.StudentID = s.StudentID AND e.CourseID = c.CourseID
    )
);
--Duplicate ratings check
SELECT StudentID, CourseID, Rating, COUNT(*) AS RatingCount
FROM Enrollments
GROUP BY StudentID, CourseID, Rating
HAVING COUNT(*) > 1;
--Category with highest avg rating
SELECT TOP 1 cat.CategoryName, AVG(e.Rating) AS AvgRating
FROM Categories cat
JOIN Courses c ON cat.CategoryID = c.CategoryID
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY cat.CategoryName
ORDER BY AvgRating DESC;




