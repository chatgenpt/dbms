Aim: Introduce concepts of PLSQL and usage on the table.
Program: Consider the schema for College Database:
STUDENT(USN, SName, Address, Phone, Gender) SEMSEC(SSID, Sem, Sec)
CLASS(USN, SSID)
COURSE(Subcode, Title, Sem, Credits)
IAMARKS(USN, Subcode, SSID, Test1, Test2, Test3, FinalIA)
Write SQL queries to
1. List all the student details studying in fourth semester ‘C’ section.
2. Compute the total number of male and female students in each semester and in each section.
3. Create a view of Test1 marks of student USN ‘1BI15CS101’ in all Courses.
4. Calculate the FinalIA (average of best two test marks) and update the corresponding table for all students.
5. Categorize students based on the following criterion: If FinalIA = 17 to 20 then CAT = ‘Outstanding’
If FinalIA = 12 to 16 then CAT = ‘Average’ If FinalIA< 12 then CAT =

CREATE DATABASE COLLEGE;

USE COLLEGE;

CREATE TABLE STUDENT (
    USN VARCHAR(20) PRIMARY KEY,
    SName VARCHAR(50) NOT NULL,
    Address VARCHAR(100),
    Phone VARCHAR(15),
    Gender VARCHAR(10)
);

CREATE TABLE SEMSEC (
    SSID VARCHAR(10) PRIMARY KEY,
    Sem INT,
    Sec VARCHAR(1)
);


CREATE TABLE CLASS (
    USN VARCHAR(20),
    SSID VARCHAR(10),
    PRIMARY KEY (USN, SSID),
    FOREIGN KEY (USN) REFERENCES STUDENT(USN),
    FOREIGN KEY (SSID) REFERENCES SEMSEC(SSID)
);

CREATE TABLE COURSE (
    Subcode VARCHAR(10) PRIMARY KEY,
    Title VARCHAR(50),
    Sem INT,
    Credits INT
);


CREATE TABLE IAMARKS (
    USN VARCHAR(20),
    Subcode VARCHAR(10),
    SSID VARCHAR(10),
    Test1 INT,
    Test2 INT,
    Test3 INT,
    FinalIA INT,
    PRIMARY KEY (USN, Subcode, SSID),
    FOREIGN KEY (USN) REFERENCES STUDENT(USN),
    FOREIGN KEY (Subcode) REFERENCES COURSE(Subcode),
    FOREIGN KEY (SSID) REFERENCES SEMSEC(SSID)
);

-- Insert values into STUDENT table
INSERT INTO STUDENT (USN, SName, Address, Phone, Gender)
VALUES
    ('1BI15CS101', 'John Doe', '123 Main St', '1234567890', 'Male'),
    ('1BI15CS102', 'Jane Smith', '456 Oak St', '9876543210', 'Female'),
    ('1BI15CS103', 'Bob Johnson', '789 Pine St', '5551234567', 'Male'),
    ('1BI15CS104', 'Alice Williams', '321 Maple St', '7778889999', 'Female'),
    ('1BI15CS105', 'Charlie Brown', '555 Elm St', '1112223333', 'Male'),
    ('1BI15CS106', 'Eva Davis', '888 Birch St', '4445556666', 'Female');

-- Insert values into SEMSEC table
INSERT INTO SEMSEC (SSID, Sem, Sec)
VALUES
    ('SS1', 4, 'C'),
    ('SS2', 4, 'D'),
    ('SS3', 3, 'A'),
    ('SS4', 3, 'B'),
    ('SS5', 2, 'A'),
    ('SS6', 2, 'B');

-- Insert values into CLASS table
INSERT INTO CLASS (USN, SSID)
VALUES
    ('1BI15CS101', 'SS1'),
    ('1BI15CS102', 'SS1'),
    ('1BI15CS103', 'SS2'),
    ('1BI15CS104', 'SS3'),
    ('1BI15CS105', 'SS4'),
    ('1BI15CS106', 'SS5');

-- Insert values into COURSE table
INSERT INTO COURSE (Subcode, Title, Sem, Credits)
VALUES
    ('CS101', 'Introduction to Computer Science', 4, 3),
    ('CS102', 'Data Structures', 4, 4),
    ('MA101', 'Mathematics', 3, 3),
    ('PHY101', 'Physics', 3, 4),
    ('ENG101', 'English', 2, 3),
    ('CHEM101', 'Chemistry', 2, 4);

-- Insert values into IAMARKS table
INSERT INTO IAMARKS (USN, Subcode, SSID, Test1, Test2, Test3, FinalIA)
VALUES
    ('1BI15CS101', 'CS101', 'SS1', 18, 19, 20, NULL), -- Outstanding
    ('1BI15CS102', 'CS101', 'SS1', 16, 17, 18, NULL), -- Average
    ('1BI15CS103', 'CS101', 'SS2', 14, 15, 16, NULL), -- Average
    ('1BI15CS104', 'CS102', 'SS3', 17, 18, 19, NULL), -- Outstanding
    ('1BI15CS105', 'PHY101', 'SS4', 15, 16, 17, NULL), -- Average
    ('1BI15CS106', 'ENG101', 'SS5', 12, 13, 14, NULL); -- Below Average

SELECT *
FROM STUDENT
WHERE USN IN (SELECT USN 
              FROM CLASS 
              WHERE SSID IN (SELECT SSID   
                             FROM SEMSEC 
                             WHERE Sem = 4 AND Sec = 'C'));

SELECT Sem, Sec, Gender, COUNT(*) AS StudentCount
FROM STUDENT
JOIN CLASS ON STUDENT.USN = CLASS.USN
JOIN SEMSEC ON CLASS.SSID = SEMSEC.SSID
GROUP BY Sem, Sec, Gender;

CREATE VIEW Test1View AS
SELECT Subcode, Test1
FROM IAMARKS
WHERE USN = '1BI15CS101';
SELECT * FROM Test1View;

UPDATE IAMARKS
SET FinalIA = (Test1 + Test2 + Test3 - LEAST(Test1, Test2, Test3)) / 2
WHERE FinalIA IS NULL;
SELECT * FROM IAMARKS;

SELECT USN, FinalIA,
    CASE
        WHEN FinalIA BETWEEN 17 AND 20 THEN 'Outstanding'
        WHEN FinalIA BETWEEN 12 AND 16 THEN 'Average'
        WHEN FinalIA < 12 THEN 'Below Average'
        ELSE 'Not Categorized'
    END AS CAT
FROM IAMARKS;
