Use Aggregate;

-- Create the Employee table
CREATE TABLE Employee (
    ID INT,
    Name VARCHAR(100),
    Salary INT,
    Address VARCHAR(100),
    Did INT
);

-- Insert values into Employee table
INSERT INTO Employee VALUES (1, 'Zubair', 5000, 'cairo', 10);
INSERT INTO Employee VALUES (2, 'Shahad', 6000, 'cairo', 20);
INSERT INTO Employee VALUES (3, 'Mohammed', 7000, 'cairo', 30);
INSERT INTO Employee VALUES (4, 'Alanud', 8000, 'alex', 10);
INSERT INTO Employee VALUES (5, 'Saleh', 7000, 'alex', 20);
INSERT INTO Employee VALUES (6, 'Fatma', 8000, 'alex', 30);
INSERT INTO Employee VALUES (7, 'Azza', 9000, 'alex', 20);
INSERT INTO Employee VALUES (8, 'Rashed', 2000, 'alex', 10);
INSERT INTO Employee VALUES (9, 'Ibrahim', 1000, 'alex', 30);
INSERT INTO Employee VALUES (10, 'Amani', 4000, 'cairo', 20);
INSERT INTO Employee VALUES (11, 'Tasnim', 7000, 'cairo', 10);
INSERT INTO Employee VALUES (12, 'Afra', 9000, 'mansoura', 10);
INSERT INTO Employee VALUES (13, 'Budoor', 3000, 'mansoura', 20);
INSERT INTO Employee VALUES (14, NULL, 6000, 'mansoura', 30);
INSERT INTO Employee VALUES (15, NULL, 5000, 'mansoura', 20);

-- the minimum salary
-- 4 or more employees
SELECT MIN(Salary) AS MinSalary, Address 
FROM Employee  
WHERE Did IN (20, 30) 
GROUP BY Address 
HAVING COUNT(ID) >= 4;

-- the total salary per department for employees
-- starts with  'a'
SELECT SUM(Salary) AS TotalSalary, Did  
FROM Employee  
WHERE Address LIKE '_a%' 
GROUP BY Did  
HAVING MAX(Salary) > 2000;
