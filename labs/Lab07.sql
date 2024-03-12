-- 1. Создать хранимую процедуру, которая: --
--    a. добавляет каждой книге два случайных жанра; --
--    b. отменяет совершённые действия, если в процессе работы хотя бы одна операция вставки завершилась ошибкой в силу дублирования значения первичного ключа таблицы «m2m_books_genres» (т.е. у такой книги уже был такой жанр). --

DELIMITER !!
CREATE PROCEDURE add_genres()
BEGIN
    DECLARE done BOOLEAN DEFAULT FALSE;
    DECLARE book_id INT DEFAULT 0;
    DECLARE book_ids CURSOR FOR
        SELECT b_id FROM books;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    DECLARE EXIT HANDLER FOR 1062 ROLLBACK;

    START TRANSACTION;
    OPEN book_ids;
    while_loop: LOOP
        FETCH book_ids INTO book_id;
        IF done THEN
            LEAVE while_loop;
        END IF;

        INSERT INTO m2m_books_genres (b_id, g_id)
        SELECT book_id, g_id
        FROM genres
        ORDER BY RAND()
        LIMIT 2;

    END LOOP while_loop;
    CLOSE book_ids;
    COMMIT;

END;
!!

DELIMITER ;

-- 2. Создать хранимую процедуру, которая: --
--    a. увеличивает значение поля «b_quantity» для всех книг в два раза; --
--    b. отменяет совершённое действие, если по итогу выполнения операции среднее количество экземпляров книг превысит значение 50. --

DELIMITER !!
CREATE PROCEDURE add_books()
BEGIN
    START TRANSACTION;

    UPDATE books
    SET b_quantity = b_quantity * 2;

    IF (SELECT AVG(b_quantity) FROM books) > 50 THEN
        ROLLBACK;
    END IF;

    COMMIT;
END;
!!

DELIMITER ;

-- 3. Написать запросы, которые, будучи выполненными параллельно, обеспечивали бы следующий эффект: --
--    a. первый запрос должен считать количество выданных на руки и возвращённых в библиотеку книг и не зависеть от запросов на обновление таблицы «subscriptions» (не ждать их завершения); --
--    b. второй запрос должен инвертировать значения поля «sb_is_active» таблицы subscriptions с «Y» на «N» и наоборот и не зависеть от первого запроса (не ждать его завершения). --

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
START TRANSACTION;
SELECT sb_is_active, COUNT(*) as amount
FROM subscriptions
GROUP BY sb_is_active;
COMMIT;

UPDATE subscriptions
SET sb_is_active = IF(sb_is_active = 'Y', 'N', 'Y');

-- 5. Написать код, в котором запрос, инвертирующий значения поля «sb_is_active» таблицы «subscriptions» с «Y» на «N» и наоборот, будет иметь максимальные шансы на успешное завершение в случае возникновения ситуации взаимной блокировки с другими транзакциями. -- 

DELIMITER !!

CREATE PROCEDURE toggle_active()
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
    START TRANSACTION;
        
    UPDATE `subscriptions`
    SET `sb_is_active` = IF(`sb_is_active` = 'Y', 'N', 'Y');
        
    COMMIT;
END;
!!

DELIMITER ;

-- 8. Создать хранимую процедуру, выполняющую подсчёт количества записей в указанной таблице таким образом, чтобы она возвращала максимально корректные данные, даже если для достижения этого результата придётся пожертвовать производительностью. --

DELIMITER !!

CREATE PROCEDURE nice_count(table_name TEXT)
BEGIN
    SET TRANSACTION
    ISOLATION LEVEL SERIALIZABLE;

    START TRANSACTION;

    SET @query := CONCAT('SELECT COUNT(*) FROM ', table_name);
    PREPARE stmt FROM @query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    COMMIT;
END;
!!

DELIMITER ;