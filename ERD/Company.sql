-- Use the database
USE CompanyDB;

-- 1. Create EMP table (excluding DUNM FK initially to avoid circular reference)
CREATE TABLE EMP (
    SSN CHAR(9) PRIMARY KEY,
    Fname VARCHAR(50) NOT NULL,
    Lname VARCHAR(50) NOT NULL,
    Gender CHAR(1) CHECK (Gender IN ('M', 'F')),
    Super_ID CHAR(9),  -- Self-reference
    BD DATE NOT NULL,
    DUNM INT NOT NULL, -- Will reference DEPT later
    FOREIGN KEY (Super_ID) REFERENCES EMP(SSN)
);

-- 2. Create DEPT table
CREATE TABLE DEPT (
    DUNM INT PRIMARY KEY,
    SSN CHAR(9) NOT NULL,  -- Manager SSN (FK to EMP)
    HIRDATE DATE NOT NULL,
    DN VARCHAR(100) NOT NULL,
    FOREIGN KEY (SSN) REFERENCES EMP(SSN)
);

-- 3. Add the DUNM foreign key to EMP (now DEPT exists)
ALTER TABLE EMP
ADD FOREIGN KEY (DUNM) REFERENCES DEPT(DUNM);

-- 4. Create LOC table (multi-valued attribute of DEPT)
CREATE TABLE LOC (
    DUNM INT NOT NULL,
    LOC VARCHAR(100) NOT NULL,
    PRIMARY KEY (DUNM, LOC),
    FOREIGN KEY (DUNM) REFERENCES DEPT(DUNM)
);

-- 5. Create PROJECT table
CREATE TABLE PROJECT (
    PNUM INT PRIMARY KEY,
    PN VARCHAR(100) NOT NULL,
    LOC VARCHAR(100),
    CITY VARCHAR(100),
    DUNM INT NOT NULL,
    FOREIGN KEY (DUNM) REFERENCES DEPT(DUNM)
);

-- 6. Create WORK table (many-to-many: EMP and PROJECT)
CREATE TABLE WORK (
    SSN CHAR(9),
    PNUM INT,
    HOURS DECIMAL(5,2) CHECK (HOURS >= 0),
    PRIMARY KEY (SSN, PNUM),
    FOREIGN KEY (SSN) REFERENCES EMP(SSN)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (PNUM) REFERENCES PROJECT(PNUM)
);

-- 7. Create DEPENDENT table (weak entity dependent on EMP)
CREATE TABLE DEPENDENT (
    DNUM INT,
    BD DATE NOT NULL,
    GENDER CHAR(1) CHECK (GENDER IN ('M', 'F')),
    SSN CHAR(9) NOT NULL,
    PRIMARY KEY (DNUM, SSN),
    FOREIGN KEY (SSN) REFERENCES EMP(SSN)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- 8. Backup the database to a safe path
-- NOTE: Ensure C:\Backup\ exists and SQL Server has write permission
BACKUP DATABASE CompanyDB
TO DISK = 'C:\Users\codel\OneDrive\Desktop\DATA.BASE\DataBase\Company_Backup1.bak'
WITH FORMAT,
NAME = 'Full Backup of CompanyDB';

-- ============================================================
-- SUMMARY:
-- This script creates the CompanyDB system based on ERD mapping.
-- 
-- 1. EMP: Stores employee info. Includes self-FK (Super_ID) and FK to DEPT.
-- 2. DEPT: Stores departments. Linked to manager (EMP.SSN).
-- 3. LOC: Multi-valued department location.
-- 4. PROJECT: Projects tied to departments.
-- 5. WORK: Associates employees with projects and work hours.
-- 6. DEPENDENT: Dependent details for employees.
-- 
-- Constraints used:
-- - PRIMARY KEYs for entity uniqueness
-- - FOREIGN KEYs for referential integrity
-- - NOT NULL, CHECK for domain rules
-- - ON DELETE/UPDATE CASCADE for relational integrity
-- 
-- A full
