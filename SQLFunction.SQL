--https://help.sap.com/docs/SAP_HANA_PLATFORM/de2486ee947e43e684d39702027f8a94/6f1260eff10a4ba7a159b44848b16ab4.html?q=anonymous%20functions

do
begin
select sum("a") from
sql function
returns table ("a" int, "b" int)
begin
  declare t table(a int, b int);
  return select max("DocEntry") "a", Max("DocNum") "b" from OINV;
end;
end;


create function FAFA 
returns table ("a" int, "b" int) LANGUAGE SQLSCRIPT AS
begin
  declare t table(a int, b int);
  return select max("DocEntry") "a", Max("DocNum") "b" from OINV;
end;

do
begin
select * from FAFA();
end;

CREATE VIEW ATP3 AS select * from FAFA();

select * from ATP3;
