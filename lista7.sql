-- Zadanie 7.1 
SELECT 
    s.first_name AS imie,
    s.last_name AS nazwisko,
    s.email AS adres_email,
    a.address AS ulica_zamieszkania,
    a.phone AS numer
FROM 
    staff s
JOIN 
    address a ON s.address_id = a.address_id;
-- tu korzystam z dwóch tabel staff i address

-- Zadanie 7.2 
SELECT 
    ci.city AS miasto,
    co.country AS krajj
FROM 
    city ci
JOIN 
    country co ON ci.country_id = co.country_id;
-- a w tym zad korzystam z tabel tez dwóch city i country

-- Zadanie 7.3 

SELECT a.address, ci.city, co.country FROM address a 
LEFT JOIN city ci ON a.city_id = ci.city_id
LEFT JOIN country co USING(country_id)
-- tu korzystam z trzech adress, city, country

-- Zadanie 7.4 

SELECT s.first_name, a.address, ci.city, co.country FROM staff s 
JOIN address a
ON s.address_id = a.address_id
LEFT JOIN city ci ON a.city_id = ci.city_id
LEFT JOIN country co USING(country_id)

-- Zadanie 7.5 

SELECT 
    st.store_id AS placówka_id,
    s.first_name || ' ' || s.last_name AS pracownik,
    COUNT(r.rental_id) AS liczba_wypozyczen
FROM 
    staff s
JOIN 
    store st ON s.store_id = st.store_id
LEFT JOIN 
    rental r ON s.staff_id = r.staff_id
GROUP BY 
    st.store_id, s.staff_id, s.first_name, s.last_name
ORDER BY 
    st.store_id, liczba_wypozyczen DESC;
-- jest dwóch pracowników, każdy przypisany do danej placówki (Mike i Jon )

-- Zadanie 7.6 

SELECT 
    a.first_name AS imie,
    a.last_name AS nazwisko,
    STRING_AGG(f.title, ', ') AS filmy
FROM 
    actor a
JOIN 
    film_actor fa ON a.actor_id = fa.actor_id
JOIN 
    film f ON fa.film_id = f.film_id
GROUP BY 
    a.actor_id, a.first_name, a.last_name
ORDER BY 
    nazwisko, imie;
-- tu wykorzystuje 3 tabele actor, film_actor i film
-- Zadanie 7.7 
SELECT 
    a.first_name AS imie,
    a.last_name AS nazwisko,
    f.title AS tytuł_filmu
FROM 
    actor a
JOIN 
    film_actor fa ON a.actor_id = fa.actor_id
JOIN 
    film f ON fa.film_id = f.film_id
WHERE 
    f.title ILIKE '%BLOOD%'
ORDER BY 
    nazwisko, imie, tytuł_filmu;

-- Zadanie 7.8 

SELECT 
    c.first_name AS imie,
    c.last_name AS nazwisko,
    c.email AS email,
    a.phone AS telefon,
    a.address AS ulica,
    ci.city AS miasto,
    co.country AS kraj,
    s.first_name || ' ' || s.last_name AS manager
FROM 
    customer c
JOIN 
    address a ON c.address_id = a.address_id
JOIN 
    city ci ON a.city_id = ci.city_id
JOIN 
    country co ON ci.country_id = co.country_id
JOIN 
    store st ON c.store_id = st.store_id
JOIN 
    staff s ON st.manager_staff_id = s.staff_id
WHERE 
    c.first_name = 'CAROLYN' AND c.last_name = 'PEREZ';
-- tu korszystam z szesciu tabelek 

-- Zadanie 7.9 

SELECT 
    r.rental_date AS data_wyp,
    f.title AS tytul_filmu,
    r.return_date AS data_zw,
    p.payment_date AS data_pła,
    p.amount AS oplata
FROM 
    customer c
JOIN 
    rental r ON c.customer_id = r.customer_id
JOIN 
    inventory i ON r.inventory_id = i.inventory_id
JOIN 
    film f ON i.film_id = f.film_id
LEFT JOIN 
    payment p ON r.rental_id = p.rental_id
WHERE 
    c.first_name = 'CAROLYN' AND c.last_name = 'PEREZ'
ORDER BY 
    r.rental_date;

-- Zadanie 7.10 

-- Zadanie 7.11 

SELECT 
    top_customer.first_name,
    top_customer.last_name,
    fav_actor.first_name AS aktor_imie,
    fav_actor.last_name AS aktor_nazwisko
FROM (
    -- tutaj klient, który najwiecej wydał 
    SELECT 
        c.customer_id,
        c.first_name,
        c.last_name
    FROM 
        customer c
    JOIN 
        payment p ON c.customer_id = p.customer_id
    GROUP BY 
        c.customer_id, c.first_name, c.last_name
    ORDER BY 
        SUM(p.amount) DESC
    LIMIT 1
) AS top_customer
JOIN (
    -- a tutaj ulubiony aktor tego klienta
    SELECT 
        fa.actor_id,
        a.first_name,
        a.last_name,
        r.customer_id,
        COUNT(*) AS ile_raz_wystapil
    FROM 
        rental r
    JOIN 
        inventory i ON r.inventory_id = i.inventory_id
    JOIN 
        film_actor fa ON i.film_id = fa.film_id
    JOIN 
        actor a ON fa.actor_id = a.actor_id
    GROUP BY 
        r.customer_id, fa.actor_id, a.first_name, a.last_name
) AS fav_actor
ON top_customer.customer_id = fav_actor.customer_id
ORDER BY fav_actor.ile_raz_wystapil DESC
LIMIT 1;

-- Zadanie 7.12 

-- Zadanie 7.13
SELECT 
    a.address_id
FROM 
    address a
LEFT JOIN customer c ON a.address_id = c.address_id
LEFT JOIN staff s ON a.address_id = s.address_id
LEFT JOIN store st ON a.address_id = st.address_id
WHERE 
    c.address_id IS NULL 
    AND s.address_id IS NULL 
    AND st.address_id IS NULL;
