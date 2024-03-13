Aim: Demonstrating creation of tables, applying the view concepts on the tables.

Consider the following schema for a Library Database:
BOOK (BOOK_ID, TITLE, PUBLISHER_NAME,PUB_YEAR) BOOKAUTHORS (BOOK_ID, AUTHOR_NAME) PUBLISHER (NAME, ADDRESS,PHONE)
BOOK_COPIES (BOOK_ID, PROGRAMME _ID,NO_OF_COPIES)
BOOK_LENDING (BOOK_ID, PROGRAMME _ID, CARD_NO, DATE_OUT, DUE_DATE) LIBRARY_PROGRAMME (PROGRAMME_ID, PROGRAMME_NAME, ADDRESS)
Write SQL queries to
1. Retrieve details of all books in the library – id, title, name of publisher, authors, number of copies in each branch,etc.
2. Get the particulars of borrowers who have borrowed more than 3 books, but from Jan 2017 to Jun2017.
3. Delete a book in BOOK table. Update the contents of other tables to reflect thisdata manipulationoperation.
4. Partition the BOOK table based on year of publication. Demonstrate its working with a simple query.
Create a view of all books and its number of copies that are currently available in the Library.

-- Create the database
CREATE DATABASE LibraryDatabase;
USE LibraryDatabase;

-- Create the PUBLISHER table
CREATE TABLE PUBLISHER (
    NAME VARCHAR(100) PRIMARY KEY,
    ADDRESS VARCHAR(255) NOT NULL,
    PHONE VARCHAR(15) NOT NULL
);

-- Create the BOOK table
CREATE TABLE BOOK (
    BOOK_ID INT PRIMARY KEY,
    TITLE VARCHAR(255) NOT NULL,
    PUBLISHER_NAME VARCHAR(100),
    PUB_YEAR INT,
    FOREIGN KEY (PUBLISHER_NAME) REFERENCES PUBLISHER(NAME) ON DELETE CASCADE
);

-- Create the BOOKAUTHORS table
CREATE TABLE BOOKAUTHORS (
    BOOK_ID INT,
    AUTHOR_NAME VARCHAR(100) NOT NULL,
    PRIMARY KEY (BOOK_ID, AUTHOR_NAME),
    FOREIGN KEY (BOOK_ID) REFERENCES BOOK(BOOK_ID) ON DELETE CASCADE
);

-- Create the LIBRARY_PROGRAMME table
CREATE TABLE LIBRARY_PROGRAMME (
    PROGRAMME_ID INT PRIMARY KEY,
    PROGRAMME_NAME VARCHAR(100) NOT NULL,
    ADDRESS VARCHAR(255) NOT NULL
);

-- Create the BOOK_COPIES table
CREATE TABLE BOOK_COPIES (
    BOOK_ID INT,
    PROGRAMME_ID INT,
    NO_OF_COPIES INT NOT NULL,
    PRIMARY KEY (BOOK_ID, PROGRAMME_ID),
    FOREIGN KEY (BOOK_ID) REFERENCES BOOK(BOOK_ID) ON DELETE CASCADE,
    FOREIGN KEY (PROGRAMME_ID) REFERENCES LIBRARY_PROGRAMME(PROGRAMME_ID) ON DELETE CASCADE
);

-- Create the BOOK_LENDING table
CREATE TABLE BOOK_LENDING (
    BOOK_ID INT,
    PROGRAMME_ID INT,
    CARD_NO INT NOT NULL,
    DATE_OUT DATE NOT NULL,
    DUE_DATE DATE NOT NULL,
    PRIMARY KEY (BOOK_ID, PROGRAMME_ID, CARD_NO),
    FOREIGN KEY (BOOK_ID) REFERENCES BOOK(BOOK_ID) ON DELETE CASCADE,
    FOREIGN KEY (PROGRAMME_ID) REFERENCES LIBRARY_PROGRAMME(PROGRAMME_ID) ON DELETE CASCADE
);

INSERT INTO PUBLISHER (Name, Address, Phone) VALUES
('Penguin Books', '123 Penguin Street, London', '12345678'),
('HarperCollins', '456 HarperCollins Avenue, New York', '2077000'),
('Little, Brown and Company', '789 Brown Lane, Boston', '2270730'),
('Charles Scribner''s Sons', '101 Scribner Street, New York', '5550123'),
('Thomas Egerton', '876 Egerton Road, London', '87654321');

INSERT INTO BOOK (Book_id, Title, Publisher_Name, Pub_Year) VALUES
('1', '1984', 'Penguin Books', '1949'),
('2', 'To Kill a Mockingbird', 'HarperCollins', '1960'),
('3', 'The Catcher in the Rye', 'Little, Brown and Company', '1951'),
('4', 'The Great Gatsby', 'Charles Scribner''s Sons', '1925'),
('5', 'Pride and Prejudice', 'Thomas Egerton', '1813');

INSERT INTO BOOKAUTHORS (Book_id, Author_Name) VALUES
('1', 'George Orwell'),
('2', 'Harper Lee'),
('3', 'J.D. Salinger'),
('4', 'F. Scott Fitzgerald'),
('5', 'Jane Austen');

INSERT INTO LIBRARY_PROGRAMME (Programme_id, Programme_Name, Address) VALUES
('101', 'Main Library', '123 Library Street, City'),
('102', 'Downtown Library', '456 Downtown Avenue, City'),
('103', 'Central Library', '789 Central Road, City'),
('104', 'Westside Library', '101 Westside Lane, City'),
('105', 'Eastside Library', '876 Eastside Boulevard, City');

INSERT INTO BOOK_COPIES (Book_id, Programme_id, No_of_Copies) VALUES
('1', '101', 10),
('2', '102', 8),
('3', '103', 12),
('4', '104', 5),
('5', '105', 15);

INSERT INTO BOOK_LENDING (Book_id, Programme_id, Card_No, Date_Out, Due_Date) VALUES
('1', '101', '001', '2017-01-01', '2017-01-15'),
('2', '101', '001', '2017-01-16', '2017-01-30'),
('3', '101', '001', '2017-02-01', '2017-02-15'),
('4', '101', '001', '2017-02-16', '2017-02-28'),
('1', '101', '002', '2017-02-01', '2017-02-15'),
('2', '101', '002', '2017-02-16', '2017-02-28'),
('1', '102', '003', '2017-01-01', '2017-01-15'),
('2', '102', '003', '2017-01-16', '2017-01-30'),
('3', '102', '003', '2017-02-01', '2017-02-15'),
('4', '102', '003', '2017-02-16', '2017-02-28'),
('1', '102', '004', '2017-02-01', '2017-02-15'),
('2', '102', '004', '2017-02-16', '2017-02-28'),
('5', '103', '005', '2017-01-16', '2017-01-30');

--QUERIES

--1
SELECT B.Book_id, B.Title, B.Publisher_Name, BA.Author_Name, BC.No_of_Copies, P.Programme_Name
FROM BOOK B, BOOKAUTHORS BA, BOOK_COPIES BC, LIBRARY_PROGRAMME P
WHERE B.Book_id = BA.Book_id
  AND B.Book_id = BC.Book_id
  AND BC.Programme_id = P.Programme_id;
--2
SELECT BL.Card_No, COUNT(*) AS Books_Borrowed
FROM BOOK_LENDING BL
WHERE BL.Date_Out BETWEEN '2017-01-01' AND '2017-06-30'
GROUP BY BL.Card_No
HAVING COUNT(*) > 3;

--3
DELETE FROM BOOK WHERE Book_id = '1';
SELECT * FROM BOOK;

--4
CREATE TABLE BOOK_PARTITIONED (
    Book_id INT,
    Title VARCHAR(255),
    Publisher_Name VARCHAR(255),
    Pub_Year INT
)
PARTITION BY RANGE (Pub_Year) (
    PARTITION p1 VALUES LESS THAN (1951), 
    PARTITION p2 VALUES LESS THAN (1981)  
);

INSERT INTO BOOK_PARTITIONED (Book_id, Title, Publisher_Name, Pub_Year)
SELECT Book_id, Title, Publisher_Name, Pub_Year
FROM BOOK
WHERE Pub_Year < 1980; -- Adjust the condition based on your desired range

SELECT * FROM BOOK_PARTITIONED PARTITION (p1);


--5
CREATE VIEW AVAILABLE_BOOKS AS
SELECT b.Book_id, b.Title, b.Publisher_Name, b.Pub_Year, 
       MIN(b_copies.No_of_Copies) - COUNT(bl.Book_id) AS Copies_Left
FROM BOOK b
LEFT JOIN BOOK_COPIES b_copies ON b.Book_id = b_copies.Book_id
LEFT JOIN BOOK_LENDING bl ON b.Book_id = bl.Book_id
GROUP BY b.Book_id, b.Title, b.Publisher_Name, b.Pub_Year
;

SELECT * FROM AVAILABLE_BOOKS;