
-- Inserting with MultiDimensional Varrays Example
INSERT INTO sites(site_id,classroom)
VALUES(1,
    classroom_varray_type(
        classroom_type('LH401',50,'LECTURE ROOM'),
        classroom_type('LH402',24,'SEMINAR ROOM'),
        classroom_type('LH403',10,'STAFF OFFICE')));

--Updating a VArray Column
INSERT INTO sites(site_id) VALUES(1);

UPDATE sites SET room = classroom_varray_type(
    classroom_type('LH401',50,'LECTURE ROOM'),
    classroom_type('LH402',24,'SEMINAR ROOM'),
    classroom_type('LH101',10,'STAFF OFFICE'));


--Inserting into Nested Tables
INSERT INTO table_name(column_name, column_name)
VALUES(VALUE,
      table_type_name(
        type_name(VALUE,VALUE,'VALUE'),
        type_name(VALUE,VALUE,'VALUE'),
        type_name(VALUE,VALUE,'VALUE'))
      );