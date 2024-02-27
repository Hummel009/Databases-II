-- 1.	Создать хранимую функцию, получающую на вход идентификатор читателя и воз-вращающую список идентификаторов книг, которые он уже прочитал и вернул в библиотеку. --

DELIMITER !!

CREATE FUNCTION get_returned_books(reader_id INT) 
RETURNS TEXT
DETERMINISTIC
BEGIN
    DECLARE book_list TEXT;
    
    SELECT GROUP_CONCAT(sb_book)
    INTO book_list
    FROM subscriptions
    WHERE sb_subscriber = reader_id AND sb_is_active = 'N';

    RETURN book_list;
END
!!

DELIMITER ;

-- 3.	Создать хранимую функцию, получающую на вход идентификатор читателя и возвращающую 1, если у читателя на руках сейчас менее десяти книг, и 0 в противном случае. --

DELIMITER !!

CREATE FUNCTION check_books_limit(reader_id INT) 
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE book_count INT;
    
    SELECT COUNT(*)
    INTO book_count
    FROM subscriptions
    WHERE sb_subscriber = reader_id AND sb_is_active = 'Y';

    RETURN book_count < 10;
END
!!

DELIMITER ;

-- 4.	Создать хранимую функцию, получающую на вход год издания книги и возвращаю-щую 1, если книга издана менее ста лет назад, и 0 в противном случае. --

DELIMITER !!

CREATE FUNCTION check_publish_year(publish_year INT) 
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE is_recent BOOLEAN;
    
    SET is_recent = (YEAR(CURRENT_DATE()) - publish_year) < 100;

    RETURN is_recent;
END
!!

DELIMITER ;

-- 9.	Создать хранимую процедуру, автоматически создающую и наполняющую данными таблицу «arrears», в которой должны быть представлены идентификаторы и имена читателей, у которых до сих пор находится на руках хотя бы одна книга, по которой дата возврата установлена в прошлом относительно текущей даты. --

DELIMITER !!

CREATE PROCEDURE create_arrears_table()
BEGIN
    CREATE TABLE IF NOT EXISTS arrears (
        reader_id INT,
        reader_name VARCHAR(150)
    );

    TRUNCATE TABLE arrears;

    INSERT INTO arrears (reader_id, reader_name)
    SELECT DISTINCT s.sb_subscriber, sub.s_name
    FROM subscriptions s
    INNER JOIN subscribers sub ON s.sb_subscriber = sub.s_id
    WHERE s.sb_is_active = 'Y' AND s.sb_finish < CURDATE();

END
!!

DELIMITER ;

-- 11.	Создать хранимую процедуру, удаляющую все представления, для которых SELECT COUNT(1) FROM представление возвращает значение меньше десяти. --

DELIMITER !!

CREATE PROCEDURE delete_views()
BEGIN
    DECLARE done BOOLEAN DEFAULT FALSE;
    DECLARE view_name VARCHAR(100);
    DECLARE view_count INT;

    DECLARE cur CURSOR FOR 
        SELECT table_name
        FROM information_schema.views;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO view_name;
        IF done THEN
            LEAVE read_loop;
        END IF;

        SET @sql = CONCAT('SELECT COUNT(1) INTO @cnt FROM ', view_name);
        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;

        IF @cnt < 10 THEN
            SET @drop_sql = CONCAT('DROP VIEW ', view_name);
            PREPARE drop_stmt FROM @drop_sql;
            EXECUTE drop_stmt;
            DEALLOCATE PREPARE drop_stmt;
        END IF;
    END LOOP;

    CLOSE cur;
END
!!

DELIMITER ;