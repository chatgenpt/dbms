Aim: Discuss the various concepts on constraints and update operations.

Consider the following schema for Order Database:
SALESMAN (SALESMAN_ID, NAME, CITY, COMISSION) 
CUSTOMER(CUSTOMER_ID,CUST_NAME,CITY,GRADE,SALESMAN_ID) 
ORDERS(ORD_NO,PURCHASE_AMT,ORD_DATE,CUSTOMER_ID,SALESMAN_ID)
Write SQL queries to
1. Count the customers with grades above Bangalore’saverage.
2. Find the name and numbers of all salesman who had more than onecustomer.
3. List all the salesman and indicate those who have and don’t have customers in their cities (Use UNION operation.)
4. Create a view that finds the salesman who has the customer with the highest order of a day.
5. Demonstrate the DELETE operation by removing salesman with id 1000. All his orders must also bedeleted.

--database creation

CREATE DATABASE orders;

--use the database

USE orders;

--salesman table

CREATE TABLE salesman (
    salesman_id INT(5), CONSTRAINT salesman_salid PRIMARY KEY (salesman_id),
    name VARCHAR(10) NOT NULL,
    city VARCHAR(15) NOT NULL,
    commission INT(5)
);

--customer table

CREATE TABLE customer (
    customer_id INT(5), CONSTRAINT customer_custid_pk PRIMARY KEY (customer_id),
    cust_name VARCHAR(10) NOT NULL,
    city VARCHAR(10) NOT NULL,
    grade INT NOT NULL,
    salesman_id INT(5),CONSTRAINT customer_saleid_fkk FOREIGN KEY (salesman_id) REFERENCES salesman(salesman_id) ON DELETE CASCADE
);

--orders table

CREATE TABLE orders (
    ord_no INT(5), CONSTRAINT orders_ordno_pk PRIMARY KEY (ord_no),
    purchase_amt INT NOT NULL,
    ord_date DATE NOT NULL,
    customer_id INT(5), CONSTRAINT orders_custid_fk FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE CASCADE,
    salesman_id INT(5), CONSTRAINT orders_saleid_fk FOREIGN KEY (salesman_id) REFERENCES salesman(salesman_id) ON DELETE CASCADE   
);

--salesman

INSERT INTO salesman (salesman_id, name, city, commission)
VALUES 
    (1001, 'Vikram', 'Delhi', 15),
    (1002, 'Amitabh', 'Mumbai', 10),
    (1003, 'Sarika', 'Bangalore', 12), 
    (1004, 'Rajiv', 'Chennai', 11),
    (1005, 'Jyoti', 'Kolkata', 9);

--customer

INSERT INTO customer (customer_id, cust_name, city, grade, salesman_id)
VALUES 
    (201, 'Radha', 'Delhi', 80, 1001),
    (202, 'Harish', 'Mumbai', 85, 1002),
    (203, 'Tanvi', 'Bangalore', 78, 1003),  
    (204, 'Arjun', 'Chennai', 75, 1004),
    (205, 'Meera', 'Kolkata', 88, 1005),
    (206, 'Ram', 'Delhi', 90, 1001),  
    (207, 'Simran', 'Bangalore', 85, 1003);

--orders

INSERT INTO orders (ord_no, purchase_amt, ord_date, customer_id, salesman_id)
VALUES 
    (11, 600, '2023-01-01', 201, 1001),
    (12, 900, '2023-01-02', 202, 1002),
    (13, 400, '2023-01-03', 203, 1003),
    (14, 550, '2023-01-04', 204, 1004),
    (15, 750, '2023-01-05', 205, 1005),
    (16, 800, '2023-01-05', 206, 1001),  
    (17, 950, '2023-01-03', 207, 1003);

--query1

SELECT COUNT(*) AS COUNTAVG
FROM customer
WHERE grade > (
    SELECT AVG(grade)
    FROM customer
    WHERE city = 'Bangalore'
);

--query2

SELECT name, COUNT(customer_id)
FROM salesman s, customer c
WHERE s.salesman_id = c.salesman_id
GROUP BY name
HAVING COUNT(customer_id) > 1;

--query3

SELECT name
FROM salesman s, customer c
WHERE s.salesman_id = c.salesman_id AND s.city = c.city
UNION
SELECT name
FROM salesman
WHERE salesman_id NOT IN (SELECT s.salesman_id
                          FROM salesman s, customer c
                          WHERE s.salesman_id = c.salesman_id AND s.city = c.city);

--query4

CREATE VIEW MaxOrderSalesman AS
SELECT s.name AS Salesman_Name, c.customer_id, MAX(o.purchase_amt) AS Max_Order
FROM orders o
JOIN customer c ON o.customer_id = c.customer_id
JOIN salesman s ON c.salesman_id = s.salesman_id
GROUP BY s.name, c.customer_id;

SELECT * FROM MaxOrderSalesman;

--query5
    
DELETE FROM salesman WHERE salesman_id = 1001;

SELECT * FROM salesman;
