-- Zadanie 3.1 
SELECT COUNT(DISTINCT emp_no)FROM employees.dept_emp
WHERE to_date>CURRENT_DATE;

-- distinct emp_no tylko unikalne wartości pracowników, 
-- Jeśli jakiś numer pracownika (emp_no) powtarza się kilka razy, zostanie policzony tylko raz.
-- dept_emp tabela gdzie pracownicy przypisani są do działow wraz z datami

-- Zadanie 3.2 
SELECT COUNT(DISTINCT title)FROM employees.titles;

-- Zadanie 3.3
-- AVG średnia STD odchylenie standardowe 

SELECT AVG(salary), STD(salary)
FROM employees.salaries
WHERE to_date>= CURRENT_DATE -- oznacza, że pensja pracownika jest aktywna do dziś lub dalej (obecna lub przyszła).
AND from_date<= CURRENT_DATE; -- oznacza, że pensja została przydzielona pracownikowi wcześniej lub właśnie dziś.

