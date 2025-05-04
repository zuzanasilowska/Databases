-- Zadanie 4.7

SELECT customer_id,
    CONCAT( -- sklejam tekstowo sredni czas 
        FLOOR( -- obliczam sredni czas trwania w minutach, a potem konwertuje na inne jednostki
            AVG(TIMESTAMPDIFF(MINUTE, rental_date, return_date)) / (60 * 24 * 365)
        ),
        ' lat ',
        FLOOR( -- floor zaokrągla liczbe w dół 
            (
                AVG(TIMESTAMPDIFF(MINUTE, rental_date, return_date)) % (60 * 24 * 365)
            ) / (60 * 24 * 30)
        ),
        ' miesięcy ',
        FLOOR(
            (
                AVG(TIMESTAMPDIFF(MINUTE, rental_date, return_date)) % (60 * 24 * 30)
            ) / (60 * 24)
        ),
        ' dni ',
        FLOOR(
            (
                AVG(TIMESTAMPDIFF(MINUTE, rental_date, return_date)) % (60 * 24)
            ) / 60
        ),
        ' godzin ',
        FLOOR(
            AVG(TIMESTAMPDIFF(MINUTE, rental_date, return_date)) % 60
        ),
        ' minut'
    ) AS sredni_czas_wypozyczenia
FROM rental
GROUP BY customer_id
ORDER BY AVG(TIMESTAMPDIFF(MINUTE, rental_date, return_date)) DESC
LIMIT 1;

-- Zadanie 4.8

SELECT customer_id,
    CONCAT( 
        FLOOR(SUM(TIMESTAMPDIFF(MINUTE, rental_date, return_date)) 
        / (60 * 24 * 365)), ' lat ',
        FLOOR((SUM(TIMESTAMPDIFF(MINUTE, rental_date, return_date)) % (60 * 24 * 365)) 
        / (60 * 24 * 30)), ' miesięcy ',
        FLOOR((SUM(TIMESTAMPDIFF(MINUTE, rental_date, return_date)) % (60 * 24 * 30)) 
        / (60 * 24)), ' dni ',
        FLOOR((SUM(TIMESTAMPDIFF(MINUTE, rental_date, return_date)) % (60 * 24)) / 60), ' godzin ',
        FLOOR(SUM(TIMESTAMPDIFF(MINUTE, rental_date, return_date)) % 60),' minut'
    ) AS laczny_czas_wypozyczenia
FROM rental
GROUP BY customer_id
ORDER BY SUM(TIMESTAMPDIFF(MINUTE, rental_date, return_date)) DESC
LIMIT 1;

-- Zadanie 5.1 
SELECT OrderID, SUM(Quantity), SUM(UnitPrice*Quantity) AS kwota
FROM northwind.`Order Details`
GROUP BY OrderID ORDER BY kwota DESC
LIMIT 1;

-- Zadanie 5.2 

SELECT COUNT(*) 
FROM (SELECT CustomerID, COUNT(OrderID) FROM northwind.Orders 
GROUP BY CustomerID
HAVING COUNT(OrderID)>20) AS s;

-- Zadanie 5.3

SELECT 
CONCAT(
        ROUND(
            (COUNT(CASE WHEN Discontinued = 1 THEN 1 END) * 100.0) / COUNT(*), 
            0
        ), 
        '%'
    ) AS percentage_not_in_sale
FROM Products;

-- Zadanie 5.4 

SELECT 
Country,
ROUND((SUM(CASE WHEN RIGHT(ContactName, 1) = 'a' THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 3) AS percentage_ending_with_a
FROM Customers
GROUP BY Country
ORDER BY percentage_ending_with_a DESC, Country ASC
LIMIT 5;
