--4

DELIMITER //
CREATE PROCEDURE AVG_MARKS()
BEGIN
    DECLARE C_A INTEGER;
    DECLARE C_B INTEGER;
    DECLARE C_C INTEGER;
    DECLARE C_SUM INTEGER;
    DECLARE C_AVG INTEGER;
    DECLARE C_USN VARCHAR(10);
    DECLARE C_SUBCODE VARCHAR(8);
    DECLARE C_SSID VARCHAR(5);

    DECLARE C_IAMARKS CURSOR FOR
    SELECT GREATEST(TEST1,TEST2) AS A, GREATEST(TEST1,TEST3) AS B, GREATEST(TEST3,TEST2) AS C, USN, SUBCODE, SSID
    FROM IAMARKS
    WHERE FINALIA IS NULL
    FOR UPDATE;

    OPEN C_IAMARKS;
    LOOP
        FETCH C_IAMARKS INTO C_A, C_B, C_C, C_USN, C_SUBCODE, C_SSID;

        IF (C_A != C_B) THEN
            SET C_SUM=C_A+C_B;
        ELSE
            SET C_SUM=C_A+C_C;
        END IF;

        SET C_AVG=C_SUM/2;

        UPDATE IAMARKS SET FINALIA = C_AVG 
        WHERE USN = C_USN AND SUBCODE = C_SUBCODE AND SSID = C_SSID;

    END LOOP;
    CLOSE C_IAMARKS;
END;
//


  
DELIMITER ;

-- Call the stored procedure
CALL AVG_MARKS();

-- Retrieve updated records
SELECT *
FROM IAMARKS;


--5

DELIMITER //

CREATE PROCEDURE categorize_marks()
BEGIN
    DECLARE v_USN VARCHAR(20);
    DECLARE v_FinalIA INT;
    DECLARE v_CAT VARCHAR(50);
    
    DECLARE done INT DEFAULT FALSE;
    
    DECLARE cur CURSOR FOR
        SELECT USN, FinalIA
        FROM IAMARKS;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN cur;
    
    read_loop: LOOP
        FETCH cur INTO v_USN, v_FinalIA;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        CASE
            WHEN v_FinalIA BETWEEN 17 AND 20 THEN SET v_CAT := 'Outstanding';
            WHEN v_FinalIA BETWEEN 12 AND 16 THEN SET v_CAT := 'Average';
            WHEN v_FinalIA < 12 THEN SET v_CAT := 'Below Average';
            ELSE SET v_CAT := 'Not Categorized';
        END CASE;
        
        SELECT CONCAT('USN: ', v_USN, ', FinalIA: ', v_FinalIA, ', Category: ', v_CAT);
    END LOOP;
    
    CLOSE cur;
END;
//

DELIMITER ;


CALL categorize_marks();
