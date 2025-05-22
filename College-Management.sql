Use [College-Management-System];


-- 1. Create DEPARTMENT
CREATE TABLE DEPARTMENT (
    Department_id INT PRIMARY KEY,
    D_name VARCHAR(100) NOT NULL
);

-- 2. Create HOSTEL
CREATE TABLE HOSTEL (
    Hostel_ID INT PRIMARY KEY,
    Hostel_name VARCHAR(100),
    City VARCHAR(50),
    State VARCHAR(50),
    Address VARCHAR(200),
    Pin_code CHAR(6),
    No_of_seats INT
);

-- 3. Create STUDENT
CREATE TABLE STUDENT (
    S_ID INT PRIMARY KEY,
    F_Name VARCHAR(50),
    L_Name VARCHAR(50),
    Phone_no VARCHAR(15),
    DOB DATE,
    AGE INT,
    Hostel_ID INT,
    Department_id INT,
    FOREIGN KEY (Hostel_ID) REFERENCES HOSTEL(Hostel_ID),
    FOREIGN KEY (Department_id) REFERENCES DEPARTMENT(Department_id)
);

-- 4. Create FACULTY
CREATE TABLE FACULTY (
    F_id INT PRIMARY KEY,
    Name VARCHAR(100),
    Mobile_no VARCHAR(15),
    Department VARCHAR(100),
    Salary DECIMAL(10,2)
);

-- 5. Create COURSE
CREATE TABLE COURSE (
    Course_ID INT PRIMARY KEY,
    Course_name VARCHAR(100),
    Duration INT
);

-- 6. Create SUBJECT
CREATE TABLE SUBJECT (
    Subject_id INT PRIMARY KEY,
    Subject_name VARCHAR(100)
);

-- 7. Create EXAMS
CREATE TABLE EXAMS (
    Exam_code INT PRIMARY KEY,
    Date DATE,
    Time TIME,
    Room VARCHAR(20)
);

-- 8. Create ENROLL (M-M between STUDENT and COURSE)
CREATE TABLE ENROLL (
    S_ID INT,
    Course_ID INT,
    PRIMARY KEY (S_ID, Course_ID),
    FOREIGN KEY (S_ID) REFERENCES STUDENT(S_ID),
    FOREIGN KEY (Course_ID) REFERENCES COURSE(Course_ID)
);

-- 9. Create HANDLES (M-M between FACULTY and SUBJECT)
CREATE TABLE HANDLES (
    F_id INT,
    Subject_id INT,
    PRIMARY KEY (F_id, Subject_id),
    FOREIGN KEY (F_id) REFERENCES FACULTY(F_id),
    FOREIGN KEY (Subject_id) REFERENCES SUBJECT(Subject_id)
);

-- 10. Create TEACHES (M-M between FACULTY and STUDENT)
CREATE TABLE TEACHES (
    F_id INT,
    S_ID INT,
    PRIMARY KEY (F_id, S_ID),
    FOREIGN KEY (F_id) REFERENCES FACULTY(F_id),
    FOREIGN KEY (S_ID) REFERENCES STUDENT(S_ID)
);

-- 11. Create TAKE_SUBJECT (M-M between STUDENT and SUBJECT)
CREATE TABLE TAKE_SUBJECT (
    S_ID INT,
    Subject_id INT,
    PRIMARY KEY (S_ID, Subject_id),
    FOREIGN KEY (S_ID) REFERENCES STUDENT(S_ID),
    FOREIGN KEY (Subject_id) REFERENCES SUBJECT(Subject_id)
);

-- 12. Create TAKE_EXAMS (M-M between STUDENT and EXAMS)
CREATE TABLE TAKE_EXAMS (
    S_ID INT,
    Exam_code INT,
    PRIMARY KEY (S_ID, Exam_code),
    FOREIGN KEY (S_ID) REFERENCES STUDENT(S_ID),
    FOREIGN KEY (Exam_code) REFERENCES EXAMS(Exam_code)
);


---- Backup the database to a safe path

BACKUP DATABASE CompanyDB
TO DISK = 'C:\Users\codel\OneDrive\Desktop\DATA.BASE\DataBase\College-Management-System_Backup1.bak'
WITH FORMAT,
NAME = 'Full Backup of [College-Management-System]';