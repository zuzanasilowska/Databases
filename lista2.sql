-- Zadanie 2.10 
SELECT 
    store_id AS Placowka,
    COUNT(inventory_id) AS Liczba_dostepnych_sztuk
FROM sakila.inventory
WHERE film_id = (
    SELECT film_id FROM film 
    WHERE description RLIKE '\\b[Dd]og\\b|\\b[Dd]ogs\\b|\\b[Cc]at\\b|\\b[Cc]ats\\b' 
    AND rating = 'G'
    AND special_features NOT LIKE '%Deleted Scenes%'
    ORDER BY length DESC LIMIT 1
)
GROUP BY store_id;

-- Zadanie 2.11
-- najpierw szukam id flimu ktory spelnil wymagania (u mnie wyszło 182)
SELECT film_id, title, length
FROM film 
WHERE description RLIKE '\\b[Dd]og\\b|\\b[Dd]ogs\\b|\\b[Cc]at\\b|\\b[Cc]ats\\b' 
  AND rating = 'G'
  AND special_features NOT LIKE '%Deleted Scenes%'
ORDER BY length DESC
LIMIT 1;

-- teraz szukam klientów, którzy wypożyczyli i sprawdzam czy oddali
SELECT DISTINCT 
    c.first_name AS Imie,
    c.last_name AS Nazwisko,
    CASE 
        WHEN r.return_date IS NULL THEN 'NIE'
        ELSE 'TAK'
    END AS Czy_oddano
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
WHERE i.film_id = 182;

-- Zadanie 2.12 i dodajemy zapytanie czy nadal są aktywnymi klientami
SELECT DISTINCT 
    c.first_name AS Imie,
    c.last_name AS Nazwisko,
    CASE 
        WHEN r.return_date IS NULL THEN 'NIE'
        ELSE 'TAK'
    END AS Czy_oddano,
    CASE
        WHEN c.active = 1 THEN 'TAK'
        ELSE 'NIE'
    END AS Czy_aktywny
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
WHERE i.film_id = 182;

-- Zadanie 2.13 modifikuje, aby znaleźć numery telefonów

SELECT DISTINCT 
    c.first_name AS Imie,
    c.last_name AS Nazwisko,
    a.phone AS Numer_telefonu,
    CASE 
        WHEN r.return_date IS NULL THEN 'NIE'
        ELSE 'TAK'
    END AS Czy_oddano
FROM customer c
JOIN address a ON c.address_id = a.address_id  
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
WHERE i.film_id = 182
  AND c.active = 1;

-- Zadanie 2.14

SELECT a.first_name, a.last_name, COUNT(fa.film_id) AS liczba_filmow
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
WHERE a.first_name = 'PENELOPE'
GROUP BY a.actor_id, a.first_name, a.last_name
ORDER BY liczba_filmow DESC
LIMIT 1;

-- Zadanie 2.15

SELECT s.staff_id, s.first_name, s.last_name, SUM(p.amount) AS total_amount
FROM sakila.staff s
JOIN sakila.payment p ON s.staff_id = p.staff_id
GROUP BY s.staff_id, s.first_name, s.last_name
ORDER BY total_amount DESC;

-- Zadanie 2.16
SELECT staff_id, SUM(amount) AS kwota
FROM payment WHERE payment_date BETWEEN'2005-07-01 00:00:00'AND '2005-08-31 23:59:59'
GROUP BY staff_id ORDER BY kwota DESC;

-- Zadanie 2.17
SELECT COUNT(email) FROM sakila.customer WHERE email NOT LIKE '%@sakilacustomer.org';

-- jeśli jakieś są to jakie to nazwy
SELECT DISTINCT SUBSTRING_INDEX(email, '@', -1) AS domena
FROM sakila.customer
WHERE email NOT LIKE '%@sakilacustomer.org';

-- Zadanie 2.18
SELECT store_id, COUNT(customer_id) FROM customer
WHERE customer_id IN (
    SELECT customer_id FROM customer WHERE active ='1' 
) GROUP BY store_id;

-- Zadanie 2.19
SELECT staff_id, COUNT(rental_id) AS liczba_niezwroconych
FROM rental
WHERE return_date IS NULL AND staff_id IN (1,2)
GROUP BY staff_id;

-- Zadanie 2.20
SELECT MIN(rental_date) FROM rental WHERE return_date IS NULL;

SELECT phone FROM address 
WHERE address_id IN(
    SELECT address_id from customer 
    WHERE customer_id = (
        SELECT customer_id FROM rental 
        WHERE return_date IS NULL ORDER BY rental_date ASC LIMIT 1))