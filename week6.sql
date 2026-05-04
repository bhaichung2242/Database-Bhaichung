--Querying Using DOt Notation

--OBJECT COLUMN QUERRY
SELECT alias.column_name.attribute FROM tablename alias;

SELECT s.address.street, s.address.city FROM sites s;

--S.ADDRESS.STREET       S.ADDRESS.CITY 
----------------       --------------
--3 PALACE DE CONCORDE.  PARIS
--1600 PENNSYLVANIA.     WASHINGTON
--22 TRAFALGAR SQUARE    LONDON


--OBJECT TABLE QUERRY SAME AS RETIONAL TABLE



--Querying Tables with REF Columns
SELECT column_name,reference_column_name
FROM table_name;

SELECT instructor_id, address FROM instructors;

--Querying using DEREF
SELECT column_name, DEREF(reference_column)
FROM tablename;

SELECT instructor_id, DEREF(address)
FROM instructors;

--Querying REF Activity
SELECT customer_id, name, c.address.street, c.address.city, c.address.country
FROM customers c;

--Querying Nested Table Only
SELECT VALUE(alias)
FROM THE(
    SELECT column_name
    FROM relational_table
    WHERE column_name = value
)alias;

