-- Step 1: Create Database and Table, Insert Initial Data
CREATE DATABASE TrainingDB;
USE TrainingDB;

CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    FullName NVARCHAR(100),
    EnrollmentDate DATE
);


INSERT INTO Students VALUES  
(1, 'Sara Ali', '2023-09-01'), 
(2, 'Mohammed Nasser', '2023-10-15');

-- Step 2: Full Backup
BACKUP DATABASE TrainingDB
TO DISK = 'C:\Users\codel\OneDrive\Desktop\DATA.BASE\DataBase\BackupTest\TrainingDB_Full.bak';

-- Step 3: Insert new record (simulate data change)
INSERT INTO Students VALUES (3, 'Fatma Said', '2024-01-10');
GO

-- Step 4: Differential Backup
BACKUP DATABASE TrainingDB 
TO DISK = 'C:\Users\codel\OneDrive\Desktop\DATA.BASE\DataBase\BackupTest\TrainingDB_Diff.bak' 
WITH DIFFERENTIAL;

-- Step 5: Set Recovery Model to FULL (if not already)
ALTER DATABASE TrainingDB SET RECOVERY FULL;

-- Step 6: Transaction Log Backup
BACKUP LOG TrainingDB 
TO DISK = 'C:\Users\codel\OneDrive\Desktop\DATA.BASE\DataBase\BackupTest\TrainingDB_Log.trn';

-- Step 7: Copy-Only Backup
BACKUP DATABASE TrainingDB 
TO DISK = 'C:\Users\codel\OneDrive\Desktop\DATA.BASE\DataBase\BackupTest\TrainingDB_CopyOnly.bak' 
WITH COPY_ONLY;

-- step8: Drop 
DROP DATABASE TrainingDB;

-- STEP 9: RESTORE FULL BACKUP
RESTORE DATABASE TrainingDB  
FROM DISK = 'C:\Users\codel\OneDrive\Desktop\DATA.BASE\DataBase\BackupTest\TrainingDB_Full.bak'  
WITH NORECOVERY;
GO

-- STEP 10: RESTORE DIFFERENTIAL BACKUP
RESTORE DATABASE TrainingDB  
FROM DISK = 'C:\Users\codel\OneDrive\Desktop\DATA.BASE\DataBase\BackupTest\TrainingDB_Diff.bak'  
WITH NORECOVERY;
GO

-- STEP 11: RESTORE TRANSACTION LOG BACKUP
RESTORE LOG TrainingDB  
FROM DISK = 'C:\Users\codel\OneDrive\Desktop\DATA.BASE\DataBase\BackupTest\TrainingDB_Log.trn'  
WITH RECOVERY;
GO

-- STEP 12: VERIFY DATA RESTORED SUCCESSFULLY
USE TrainingDB;
GO

SELECT * FROM Students;
