-- 1.	Показать всю информацию об авторах
SELECT * 
FROM library.authors
;

-- 2.	Показать всю информацию о жанрах.
SELECT * 
FROM library.genres
;

-- 5.	Показать, сколько всего читателей зарегистрировано в библиотеке
SELECT COUNT(*) AS total_readers
FROM subscribers
;

-- 13.	Показать идентификаторы всех «самых читающих читателей», взявших в библиотеке больше всего книг.
SELECT sb_subscriber AS top_reader, COUNT(sb_book) AS total_books
FROM subscriptions
GROUP BY sb_subscriber
ORDER BY total_books DESC
;

-- 14.	Показать идентификатор «читателя-рекордсмена», взявшего в библиотеке больше книг, чем любой другой читатель.
SELECT sb_subscriber AS top_reader, COUNT(sb_book) AS total_books
FROM subscriptions
GROUP BY sb_subscriber
ORDER BY total_books DESC
LIMIT 1
;