-- ============================
-- HospitalDB Full Setup and Backup Strategy
-- ============================
-- Description:
-- Full backup every Sunday at 2:00 AM
-- Differential backup every Monday–Saturday at 10:00 PM
-- Transaction Log backup every hour (24x7)
-- Folder structure: C:\Users\codel\OneDrive\Desktop\DATA.BASE\DataBase\[Type]\
-- File Naming: HospitalDB_[Type]_YYYYMMDD[_HHMM].ext

-- ==================================
-- STEP 0: Create Database and Tables
-- ==================================
CREATE DATABASE HospitalDB;
USE HospitalDB;

CREATE TABLE Patients (
    PatientID INT PRIMARY KEY,
    FullName NVARCHAR(100),
    Gender VARCHAR(10),
    DOB DATE,
    Phone NVARCHAR(20)
);

CREATE TABLE Doctors (
    DoctorID INT PRIMARY KEY,
    FullName NVARCHAR(100),
    Specialty VARCHAR(50),
    Phone NVARCHAR(20)
);

CREATE TABLE Appointments (
    AppointmentID INT PRIMARY KEY,
    PatientID INT FOREIGN KEY REFERENCES Patients(PatientID),
    DoctorID INT FOREIGN KEY REFERENCES Doctors(DoctorID),
    AppointmentDate DATETIME,
    Status VARCHAR(20)
);

CREATE TABLE MedicalRecords (
    RecordID INT PRIMARY KEY,
    PatientID INT FOREIGN KEY REFERENCES Patients(PatientID),
    Diagnosis NVARCHAR(200),
    Treatment NVARCHAR(200),
    RecordDate DATE
);

-- ==================================
-- STEP 1: Insert Sample Data
-- ==================================
INSERT INTO Patients VALUES
(1, 'Ahmed Yassin', 'Male', '1985-04-12', '0501234567'),
(2, 'Layla Kareem', 'Female', '1992-08-30', '0559876543'),
(3, 'Noura Al-Sabah', 'Female', '2000-01-20', '0561122334');

INSERT INTO Doctors VALUES
(1, 'Dr. Salim Hasan', 'Cardiology', '0507654321'),
(2, 'Dr. Aisha Rahman', 'Pediatrics', '0554433221'),
(3, 'Dr. Tarek Mahmoud', 'Neurology', '0567788990');

INSERT INTO Appointments VALUES
(1, 1, 1, '2025-05-27 09:30:00', 'Completed'),
(2, 2, 2, '2025-05-28 14:00:00', 'Scheduled'),
(3, 3, 3, '2025-05-28 11:00:00', 'Scheduled');

INSERT INTO MedicalRecords VALUES
(1, 1, 'High blood pressure', 'Prescribed medication', '2025-05-27'),
(2, 2, 'Fever and cold', 'Rest and fluids', '2025-05-26'),
(3, 3, 'Migraine', 'Pain relievers and stress management', '2025-05-25');

-- ==================================
-- STEP 2: Backup Configuration
-- ==================================
USE master;
ALTER DATABASE HospitalDB SET RECOVERY FULL;

-- === Full Backup (Run any time to save full backup automatically) ===
BACKUP DATABASE HospitalDB
TO DISK = 'C:\Users\codel\OneDrive\Desktop\DATA.BASE\DataBase\BackupTest\FullHospitalDB_Full_'
    

-- Differential Backup (simulate weekday)
BACKUP DATABASE HospitalDB
TO DISK = 'C:\Users\codel\OneDrive\Desktop\DATA.BASE\DataBase\BackupTest\HospitalDBDiff_20240527_0100.bak'
WITH DIFFERENTIAL;

-- Transaction Log Backup (simulate hourly)
BACKUP LOG HospitalDB
TO DISK = 'C:\Users\codel\OneDrive\Desktop\DATA.BASE\DataBase\BackupTest\HospitalDBLog_20240527_1400.trn';


-- Strategy Summary:
-- Full Backup: Every Sunday at 1 AM
-- Differential Backup: Every night at 1 AM (Mon–Sat)
-- Transaction Log Backup: Every hour, 24/7
-- File Naming Convention:
-- Format: C:\Backups\HospitalDB\{BackupType}_YYYYMMDD_HHMM.bak