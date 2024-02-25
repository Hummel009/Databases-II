-- 1.	Показать список книг, у которых более одного автора. --

SELECT book.b_name
FROM books book
JOIN m2m_books_authors book_author ON book.b_id = book_author.b_id
GROUP BY book.b_id
HAVING COUNT(book_author.a_id) > 1
;

-- 5.	Показать список книг, которые когда-либо были взяты читателями. --

SELECT book.b_name
FROM books book
WHERE EXISTS (
    SELECT 1
    FROM subscriptions subscription
    WHERE book.b_id = subscription.sb_book
)
;

-- 6.	Показать список книг, которые никто из читателей никогда не брал. --

SELECT book.b_name
FROM books book
WHERE NOT EXISTS (
    SELECT 1
    FROM subscriptions subscription
    WHERE book.b_id = subscription.sb_book
)
;

-- 15.	Показать всех авторов и количество книг (не экземпляров книг, а «книг как изданий») по каждому автору. --

SELECT author.a_name, COUNT(*) AS book_count
FROM authors author
JOIN m2m_books_authors book_author ON author.a_id = book_author.a_id
JOIN books book ON book_author.b_id = book.b_id
GROUP BY author.a_name
;

-- 23.	Показать читателя, последним взявшего в библиотеке книгу. --

SELECT subscriber.s_name
FROM subscribers subscriber
JOIN subscriptions subscription ON subscriber.s_id = subscription.sb_subscriber
WHERE subscription.sb_start = (SELECT MAX(sb_start) FROM subscriptions)
;