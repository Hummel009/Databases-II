-- 2.	Создать кэширующее представление, позволяющее получать список всех книг и их жанров (две колонки: первая – название книги, вторая – жанры книги, перечисленные через запятую). --

CREATE VIEW books_genres_view AS
SELECT
  books.b_name AS book_title,
  GROUP_CONCAT(genres.g_name ORDER BY genres.g_name SEPARATOR ', ') AS book_genres
FROM
  books
JOIN
  m2m_books_genres ON books.b_id = m2m_books_genres.b_id
JOIN
  genres ON m2m_books_genres.g_id = genres.g_id
GROUP BY
  books.b_id
;

-- 3.	Создать кэширующее представление, позволяющее получать список всех авторов и их книг (две колонки: первая – имя автора, вторая – написанные автором книги, перечисленные через запятую). --

CREATE VIEW authors_books_view AS
SELECT
  authors.a_name AS author_name,
  GROUP_CONCAT(books.b_name ORDER BY books.b_name SEPARATOR ', ') AS author_books
FROM
  authors
JOIN
  m2m_books_authors ON authors.a_id = m2m_books_authors.a_id
JOIN
  books ON m2m_books_authors.b_id = books.b_id
GROUP BY
  authors.a_id
;

-- 15.	Создать триггер, допускающий регистрацию в библиотеке только таких авторов, имя которых не содержит никаких символов кроме букв, цифр, знаков - (минус), ' (апостроф) и пробелов (не допускается два и более идущих подряд пробела). --

DELIMITER !!

CREATE TRIGGER validate_authors
BEFORE INSERT
ON authors
FOR EACH ROW
BEGIN
    DECLARE invalid_count INT;
    
    SET invalid_count = (
        SELECT COUNT(*)
        FROM authors
        WHERE NEW.a_id <> a_id
          AND NEW.a_name REGEXP '[^a-zA-Z0-9\\-\' ]'
    );
    
    IF NEW.a_name REGEXP '  ' THEN
        SET invalid_count = invalid_count + 1;
    END IF;
    
    IF invalid_count > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Недопустимое имя автора';
    END IF;
END

!!

DELIMITER ;

-- 16.	Создать триггер, корректирующий название книги таким образом, чтобы оно удовлетворяло следующим условиям: --
-- a.	не допускается наличие пробелов в начале и конце названия; --
-- b.	не допускается наличие повторяющихся пробелов; --
-- c.	первая буква в названии всегда должна быть заглавной. --

DELIMITER !!

CREATE TRIGGER correct_book_title1
BEFORE INSERT ON books
FOR EACH ROW
BEGIN
    DECLARE corrected_title VARCHAR(255);
    
    -- Удаление пробелов в начале и конце названия
    SET corrected_title = TRIM(NEW.b_name);
    
    -- Замена повторяющихся пробелов на одиночные пробелы
    WHILE corrected_title REGEXP '  ' DO
        SET corrected_title = REPLACE(corrected_title, '  ', ' ');
    END WHILE;
    
    -- Первая буква в названии всегда должна быть заглавной
    SET corrected_title = CONCAT(UPPER(SUBSTRING(corrected_title, 1, 1)), SUBSTRING(corrected_title, 2));
    
    -- Обновление значения названия книги
    SET NEW.b_name = corrected_title;
END
!!

CREATE TRIGGER correct_book_title2
BEFORE UPDATE ON books
FOR EACH ROW
BEGIN
    DECLARE corrected_title VARCHAR(255);
    
    -- Удаление пробелов в начале и конце названия
    SET corrected_title = TRIM(NEW.b_name);
    
    -- Замена повторяющихся пробелов на одиночные пробелы
    WHILE corrected_title REGEXP '  ' DO
        SET corrected_title = REPLACE(corrected_title, '  ', ' ');
    END WHILE;
    
    -- Первая буква в названии всегда должна быть заглавной
    SET corrected_title = CONCAT(UPPER(SUBSTRING(corrected_title, 1, 1)), SUBSTRING(corrected_title, 2));
    
    -- Обновление значения названия книги
    SET NEW.b_name = corrected_title;
END
!!

DELIMITER ;

-- 17.	Создать триггер, меняющий дату выдачи книги на текущую, если указанная в INSERT- или UPDATE-запросе дата выдачи книги меньше текущей на полгода и более. --

DELIMITER !!

CREATE TRIGGER update_issue_date
BEFORE INSERT ON subscriptions
FOR EACH ROW
BEGIN
    IF NEW.sb_start IS NOT NULL AND NEW.sb_start < DATE_SUB(CURDATE(), INTERVAL 6 MONTH) THEN
        SET NEW.sb_start = CURDATE();
    END IF;
END;
!!

CREATE TRIGGER update_issue_date
BEFORE UPDATE ON subscriptions
FOR EACH ROW
BEGIN
    IF NEW.sb_start IS NOT NULL AND NEW.sb_start < DATE_SUB(CURDATE(), INTERVAL 6 MONTH) THEN
        SET NEW.sb_start = CURDATE();
    END IF;
END;
!!

DELIMITER ;