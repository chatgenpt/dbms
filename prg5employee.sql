-- Create tables
CREATE TABLE EMPLOYEE (
    SSN INT PRIMARY KEY,
    Name VARCHAR(255),
    Address VARCHAR(255),
    Sex CHAR(1),
    Salary DECIMAL(10, 2),
    SuperSSN INT,
    DNo INT
);

CREATE TABLE DEPARTMENT (
    DNo INT PRIMARY KEY,
    DName VARCHAR(255),
    MgrSSN INT,
    MgrStartDate DATE
);

CREATE TABLE DLOCATION (
    DNo INT PRIMARY KEY,
    DLoc VARCHAR(255)
);

CREATE TABLE PROJECT (
    PNo INT PRIMARY KEY,
    PName VARCHAR(255),
    PLocation VARCHAR(255),
    DNo INT
);

CREATE TABLE WORKS_ON (
    SSN INT,
    PNo INT,
    Hours INT,
    PRIMARY KEY (SSN, PNo)
);

-- Insert sample data
INSERT INTO EMPLOYEE (SSN, Name, Address, Sex, Salary, SuperSSN, DNo) VALUES 
  (1, 'John Scott', '123 Main St', 'M', 60000.00, NULL, 1),
  (2, 'Alice Johnson', '456 Oak St', 'F', 55000.00, 1, 1),
  (3, 'Michael Scott', '789 Pine St', 'M', 75000.00, NULL, 2),
  (4, 'Pam Beesly', '101 Elm St', 'F', 60000.00, 3, 2),
  (5, 'Jim Halpert', '202 Cedar St', 'M', 70000.00, 3, 2),
  (6, 'Stanley Hudson', '303 Maple St', 'M', 65000.00, 3, 6), -- Added employee in 'Accounts' department
  (7, 'Angela Martin', '404 Pine St', 'F', 62000.00, 6, 6),
  (8, 'Oscar Martinez', '505 Birch St', 'M', 68000.00, 6, 6),
  (9, 'Phyllis Vance', '606 Cedar St', 'F', 63000.00, 6, 6),
  (10, 'Creed Bratton', '707 Redwood St', 'M', 70000.00, 6, 6);

INSERT INTO DEPARTMENT (DNo, DName, MgrSSN, MgrStartDate) VALUES 
  (1, 'IT', 1, '2022-01-01'),
  (2, 'HR', 3, '2022-02-01'),
  (3, 'Marketing', 2, '2022-03-01'),
  (4, 'Finance', 4, '2022-04-01'),
  (5, 'Operations', 5, '2022-05-01'),
  (6, 'Accounts', 1, '2022-06-01'); -- Added 'Accounts' department

INSERT INTO DLOCATION (DNo, DLoc) VALUES 
  (1, 'New York'),
  (2, 'Los Angeles'),
  (3, 'Chicago'),
  (4, 'San Francisco'),
  (5, 'Houston'),
  (6, 'Delhi'); -- Adjusted for 'Accounts' department

INSERT INTO PROJECT (PNo, PName, PLocation, DNo) VALUES 
  (1, 'Software Project', 'New York', 1),
  (2, 'IoT Project', 'California', 1),
  (3, 'Employee Training', 'Los Angeles', 2),
  (4, 'Database Upgrade', 'New York', 1),
  (5, 'Marketing Campaign', 'Chicago', 3),
  (6, 'Accounts Project', 'Delhi', 6); -- Added 'Accounts' project

INSERT INTO WORKS_ON (SSN, PNo, Hours) VALUES 
  (1, 1, 40),
  (2, 2, 30),
  (3, 3, 35),
  (4, 4, 25),
  (5, 5, 20),
  (6, 6, 20), -- Adjusted for 'Accounts' project
  (7, 6, 25),
  (8, 6, 30),
  (9, 6, 15),
  (10, 6, 35);

-- Queries

-- 1. List of project numbers for projects involving 'Scott'
SELECT DISTINCT PNo
FROM WORKS_ON
WHERE SSN IN (SELECT SSN FROM EMPLOYEE WHERE Name LIKE '%Scott%')
   OR SSN IN (SELECT MgrSSN FROM DEPARTMENT WHERE DNo IN (SELECT DNo FROM PROJECT));

-- 2. Salary raise for employees on 'IoT' project
UPDATE EMPLOYEE
SET Salary = Salary * 1.1
WHERE SSN IN (SELECT SSN FROM WORKS_ON WHERE PNo = (SELECT PNo FROM PROJECT WHERE PName = 'IoT'));
SELECT * FROM EMPLOYEE;

-- 3. Sum, max, min, and avg salary for 'Accounts' department
SELECT 
    SUM(Salary) AS TotalSalary,
    MAX(Salary) AS MaxSalary,
    MIN(Salary) AS MinSalary,
    AVG(Salary) AS AvgSalary
FROM EMPLOYEE
WHERE DNo IN (SELECT DNo FROM DEPARTMENT WHERE DName = 'Accounts');

-- 4. Employees working on all projects controlled by department 5
SELECT Name
FROM EMPLOYEE E
WHERE NOT EXISTS (
    SELECT PNo
    FROM PROJECT
    WHERE DNo = 5
    EXCEPT
    SELECT PNo
    FROM WORKS_ON W
    WHERE E.SSN = W.SSN
);

-- 5. Departments with more than 5 employees earning > Rs.6,00,000
SELECT DNo, COUNT(*) AS EmployeeCount
FROM EMPLOYEE
WHERE DNo IN (SELECT DNo FROM EMPLOYEE GROUP BY DNo HAVING COUNT(*) >= 5)
    AND Salary >= 60000.00
GROUP BY DNo;
