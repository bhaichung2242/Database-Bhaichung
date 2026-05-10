-- =====================================================
-- 1. OBJECT TYPES
-- =====================================================

CREATE OR REPLACE TYPE location_type AS OBJECT(
    road VARCHAR2(25),
    town VARCHAR2(25),
    nation VARCHAR2(20)
);
/

CREATE OR REPLACE TYPE organization_type AS OBJECT(
    org_name VARCHAR2(25),
    budget NUMBER(10,2),
    location location_type
);
/

CREATE OR REPLACE TYPE staff_obj AS OBJECT(
    staff_id NUMBER,
    staff_name VARCHAR2(30),
    salary NUMBER,
    join_date DATE
);
/

-- =====================================================
-- 2. TABLE WITH OBJECT COLUMN
-- =====================================================

CREATE TABLE branches (
    branch_id NUMBER(6),
    location location_type
);

INSERT INTO branches VALUES (
    1, location_type('Baker Street', 'London', 'UK')
);

INSERT INTO branches VALUES (
    2, location_type('MG Road', 'Bangalore', 'India')
);

-- =====================================================
-- 3. COMPLEX OBJECT TABLE
-- =====================================================

CREATE TABLE organizations (
    org_id NUMBER,
    org_info organization_type
);

INSERT INTO organizations VALUES (
    200,
    organization_type(
        'Global Tech',
        75000.00,
        location_type('Silicon Ave', 'California', 'USA')
    )
);

-- =====================================================
-- 4. OBJECT TABLE
-- =====================================================

CREATE TABLE staff_members OF staff_obj;

INSERT INTO staff_members VALUES (staff_obj(201, 'Michael Lee', 45000, DATE '2021-02-10'));
INSERT INTO staff_members VALUES (staff_obj(202, 'Sara Khan', 52000, DATE '2020-07-18'));
INSERT INTO staff_members VALUES (staff_obj(203, 'David Kim', 48000, DATE '2022-09-25'));

-- =====================================================
-- 5. VARRAY TYPES
-- =====================================================

CREATE OR REPLACE TYPE mobile_varray AS VARRAY(3) OF VARCHAR2(15);
/

CREATE OR REPLACE TYPE mail_varray AS VARRAY(5) OF VARCHAR2(50);
/

CREATE OR REPLACE TYPE label_varray AS VARRAY(10) OF VARCHAR2(30);
/

CREATE TABLE clients (
    client_id NUMBER PRIMARY KEY,
    full_name VARCHAR2(50),
    mobiles mobile_varray,
    mails mail_varray,
    labels label_varray
);

INSERT INTO clients VALUES (
    1,
    'Robert Brown',
    mobile_varray('9001001', '9001002'),
    mail_varray('robert@mail.com', 'rb@office.com'),
    label_varray('Premium', 'Active')
);

-- =====================================================
-- 6. VARRAY OF OBJECTS
-- =====================================================

CREATE OR REPLACE TYPE place_obj AS OBJECT(
    road VARCHAR2(25),
    town VARCHAR2(25)
);
/

CREATE OR REPLACE TYPE place_varray AS VARRAY(5) OF place_obj;
/

CREATE TABLE estates (
    estate_id NUMBER,
    owner VARCHAR2(50),
    places place_varray
);

INSERT INTO estates VALUES (
    1,
    'Chris Evans',
    place_varray(
        place_obj('Hill Road', 'Mumbai'),
        place_obj('Lake View', 'Zurich')
    )
);

-- =====================================================
-- 7. NESTED TABLE
-- =====================================================

CREATE OR REPLACE TYPE product_obj AS OBJECT(
    item_id NUMBER,
    item_name VARCHAR2(50),
    qty NUMBER,
    cost NUMBER(10,2)
);
/

CREATE OR REPLACE TYPE product_table_type AS TABLE OF product_obj;
/

CREATE TABLE purchases (
    purchase_id NUMBER PRIMARY KEY,
    buyer_name VARCHAR2(50),
    purchase_date DATE,
    products product_table_type
)
NESTED TABLE products STORE AS product_storage;

INSERT INTO purchases VALUES (
    5001,
    'Daniel Craig',
    DATE '2025-03-12',
    product_table_type(
        product_obj(301, 'Tablet', 1, 450),
        product_obj(302, 'Charger', 2, 20)
    )
);

-- Insert into nested table
INSERT INTO TABLE(
    SELECT products FROM purchases WHERE purchase_id = 5001
)
VALUES (product_obj(303, 'Headphones', 1, 80));

-- =====================================================
-- 8. VARRAY OF OBJECTS
-- =====================================================

CREATE OR REPLACE TYPE place_full_obj AS OBJECT(
    road VARCHAR2(25),
    town VARCHAR2(25),
    nation VARCHAR2(20)
);
/

CREATE OR REPLACE TYPE place_table_type AS TABLE OF place_full_obj;
/

CREATE TABLE users (
    user_id NUMBER PRIMARY KEY,
    name VARCHAR2(50),
    places place_table_type
)
NESTED TABLE places STORE AS user_places;

INSERT INTO users VALUES (
    1,
    'Tom Hardy',
    place_table_type(
        place_full_obj('King St', 'Sydney', 'Australia'),
        place_full_obj('Queen Rd', 'Toronto', 'Canada')
    )
);

INSERT INTO users VALUES (
    4,
    'Bhaichung',
    place_table_type(
        place_full_obj('kdb', 'Sankhuwasabha', 'Nepal'),
        place_full_obj('drn', 'Sunsari', 'Nepal')
    )
);

-- =====================================================
-- 9. REF & DEREF (IMPORTANT EXTRA CONCEPT)
-- =====================================================

CREATE TABLE staff_table OF staff_obj;

CREATE TABLE staff_ref_table (
    ref_staff REF staff_obj
);

INSERT INTO staff_ref_table
SELECT REF(s)
FROM staff_table s
WHERE s.staff_id = 201;

-- =====================================================
-- 10. SELECT QUERIES
-- =====================================================

-- Object column
SELECT b.location.town
FROM branches b;

-- Nested object
SELECT o.org_info.location.nation
FROM organizations o;

-- VARRAY
SELECT c.client_id, m.COLUMN_VALUE
FROM clients c, TABLE(c.mobiles) m;

-- VARRAY of objects
SELECT e.estate_id, p.road, p.town
FROM estates e, TABLE(e.places) p;

-- Nested table
SELECT p.purchase_id, pr.item_name
FROM purchases p, TABLE(p.products) pr;

-- Nested object table
SELECT u.user_id, l.road, l.town, l.nation
FROM users u, TABLE(u.places) l;

-- REF query
SELECT DEREF(r.ref_staff).staff_name
FROM staff_ref_table r;

-- =====================================================
-- 11. UPDATE & DELETE
-- =====================================================

UPDATE branches
SET location = location_type('New Road', 'Delhi', 'India')
WHERE branch_id = 1;

DELETE FROM staff_members
WHERE staff_id = 203;

DELETE FROM TABLE(
    SELECT products FROM purchases WHERE purchase_id = 5001
)
WHERE item_id = 302;


-- UNION---
SELECT purchase_id FROM purchases
UNION
SELECT user_id FROM users;