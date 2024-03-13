Aim: Demonstrate the concepts of JOIN operations.

Program: Consider the schema for Movie Database:
ACTOR(Act_id, Act_Name, Act_Gender)
DIRECTOR(Dir_id, Dir_Name, Dir_Phone)
MOVIES(Mov_id, Mov_Title, Mov_Year, Mov_Lang, Dir_id)
MOVIE_CAST(Act_id, Mov_id, Role)
RATING(Mov_id, Rev_Stars)
Write SQL queries to
1. List the titles of all movies directed by ‘Hitchcock’.
2. Find the movie names where one or more actors acted in two or more movies.
3. List all actors who acted in a movie before 2000 and also in a movie after 2015(use JOIN
operation).
4. Find the title of movies and number of stars for each movie that has at least one rating and find
the highest number of stars that movie received. Sort the result by
movie title.
5. Update rating of all movies directed by ‘Steven Spielberg’ to 5.

--creation of DATABASE

CREATE DATABASE MOVIE;

--using the DATABASE

USE MOVIE;

-- Create ACTOR table
CREATE TABLE ACTOR (
    Act_id INT PRIMARY KEY,
    Act_Name VARCHAR(255),
    Act_Gender VARCHAR(10)
);

-- Create DIRECTOR table
CREATE TABLE DIRECTOR (
    Dir_id INT PRIMARY KEY,
    Dir_Name VARCHAR(255),
    Dir_Phone VARCHAR(20)
);

-- Create MOVIES table
CREATE TABLE MOVIES (
    Mov_id INT PRIMARY KEY,
    Mov_Title VARCHAR(255),
    Mov_Year INT,
    Mov_Lang VARCHAR(20),
    Dir_id INT,
    FOREIGN KEY (Dir_id) REFERENCES DIRECTOR(Dir_id)
);

-- Create MOVIE_CAST table
CREATE TABLE MOVIE_CAST (
    Act_id INT,
    Mov_id INT,
    Role VARCHAR(50),
    PRIMARY KEY (Act_id, Mov_id),
    FOREIGN KEY (Act_id) REFERENCES ACTOR(Act_id),
    FOREIGN KEY (Mov_id) REFERENCES MOVIES(Mov_id)
);

-- Create RATING table
CREATE TABLE RATING (
    Mov_id INT PRIMARY KEY,
    Rev_Stars INT,
    FOREIGN KEY (Mov_id) REFERENCES MOVIES(Mov_id)
);

-- Insert data into ACTOR table
INSERT INTO ACTOR (Act_id, Act_Name, Act_Gender) VALUES
(1, 'Tom Hanks', 'Male'),
(2, 'Julia Roberts', 'Female'),
(3, 'Brad Pitt', 'Male'),
(4, 'Meryl Streep', 'Female'),
(5, 'Leonardo DiCaprio', 'Male');

-- Insert data into DIRECTOR table
INSERT INTO DIRECTOR (Dir_id, Dir_Name, Dir_Phone) VALUES
(1, 'Steven Spielberg', '123-456-7890'),
(2, 'Alfred Hitchcock', '987-654-3210'),
(3, 'Quentin Tarantino', '111-222-3333'),
(4, 'Christopher Nolan', '555-777-8888'),
(5, 'Greta Gerwig', '999-111-2222');

-- Insert data into MOVIES table
INSERT INTO MOVIES (Mov_id, Mov_Title, Mov_Year, Mov_Lang, Dir_id) VALUES
(1, 'Saving Private Ryan', 1998, 'English', 1),
(2, 'Pretty Woman', 2017, 'English', 2),
(3, 'Fight Club', 2012, 'English', 3),
(4, 'Inception', 2010, 'English', 4),
(5, 'Little Women', 2019, 'English', 5);

-- Insert data into MOVIE_CAST table
INSERT INTO MOVIE_CAST (Act_id, Mov_id, Role) VALUES
(1, 1, 'Captain Miller'),
(2, 1, 'Private Ryan'),
(2, 2, 'Vivian Ward'),
(3, 3, 'Tyler Durden'),
(4, 4, 'Dominic Cobb'),
(5, 4, 'Josephine March'),
(1, 5, 'Professor James E. McMillan'),
(2, 5, 'Laurie Laurence');

-- Insert data into RATING table
INSERT INTO RATING (Mov_id, Rev_Stars) VALUES
(1, 4),
(2, 5),
(3, 4),
(4, 5),
(5, 4);

--query 1

SELECT Mov_Title
FROM MOVIES
JOIN DIRECTOR ON MOVIES.Dir_id = DIRECTOR.Dir_id
WHERE Dir_Name = 'Alfred Hitchcock';

--query 2

SELECT Mov_Title
FROM MOVIES
JOIN MOVIE_CAST ON MOVIES.Mov_id = MOVIE_CAST.Mov_id
GROUP BY Mov_Title
HAVING COUNT(DISTINCT MOVIE_CAST.Act_id) >= 2;

--query 3

SELECT DISTINCT A.Act_Name
FROM ACTOR A
JOIN MOVIE_CAST MC1 ON A.Act_id = MC1.Act_id
JOIN MOVIES M1 ON MC1.Mov_id = M1.Mov_id
JOIN MOVIE_CAST MC2 ON A.Act_id = MC2.Act_id
JOIN MOVIES M2 ON MC2.Mov_id = M2.Mov_id
WHERE M1.Mov_Year < 2000 AND M2.Mov_Year > 2015;


--query 4

SELECT M.Mov_Title, R.Rev_Stars
FROM MOVIES M
JOIN RATING R ON M.Mov_id = R.Mov_id
ORDER BY M.Mov_Title;


--query 5

UPDATE RATING
SET Rev_Stars = 5
WHERE Mov_id IN (SELECT Mov_id FROM MOVIES WHERE Dir_id = (SELECT Dir_id FROM DIRECTOR WHERE Dir_Name = 'Steven Spielberg'));

SELECT * FROM RATING;