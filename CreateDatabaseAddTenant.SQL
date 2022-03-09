CREATE DATABASE NDB SYSTEM USER PASSWORD Secreta01$;
-- Asi creas un tenant
-- Luego debes conectarte a ese tenant.

CREATE SCHEMA TEST;
CREATE COLUMN TABLE TEST.TABLE01(FIELD01 VARCHAR(20));
CREATE ROW TABLE TEST.TABLE02(FIELD02 VARCHAR(20));
insert into TEST.TABLE01 values('Alfa');
insert into TEST.TABLE01 values ('Bravo');
insert into TEST.TABLE01 values ('Charly');
insert into TEST.TABLE02 values ('Delta');
insert into TEST.TABLE02 values ('Echo');
insert into TEST.TABLE02 values ('Foxtrot');
