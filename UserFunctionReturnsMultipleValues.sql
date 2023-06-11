ALTER function SUMACOMPLEJA("DOCENTRY" INT)
RETURNS FECHA1 DATE, FECHA2 DATE, FECHA3 DATE, NUMERITO INTEGER
LANGUAGE SQLSCRIPT
AS
begin
-- HP 7/5/2023 Process ATP User Function
fecha1:= add_days(CURRENT_DATE, :DocEntry);
fecha2:= add_days(CURRENT_DATE, +10);
fecha3:= add_days(CURRENT_DATE, -20);
Numerito:= 22;
end;
select SUMACOMPLEJA(2).NUMERITO, SUMACOMPLEJA(2).FECHA1, SUMACOMPLEJA(2).FECHA2, SUMACOMPLEJA(2).FECHA3 from dummy;

USANDO ARRAYS

ALTER function SUMASIMPLE("DOCENTRY" INT)
RETURNS FECHA DATE ARRAY
LANGUAGE SQLSCRIPT
AS
begin
-- HP 7/5/2023 Process ATP User Function
fecha[1]:= add_days(CURRENT_DATE, :DocEntry);
fecha[2]:= add_days(CURRENT_DATE, -5);
fecha[3]:= add_days(CURRENT_DATE, -5);
end;

do
begin
declare i date array;
i = SUMASIMPLE(1);
select :i[2] from dummy;
select SUMASIMPLE(1) from dummy;
tab=unnest(:i);
select * from :tab;
end;

USANDO TABLES !!

ALTER FUNCTION VeryComplexSum (val INT)
 RETURNS TABLE (a INT, b INT) LANGUAGE SQLSCRIPT AS
 BEGIN
     RETURN SELECT TOP 100 "DocEntry" as a , :val + "DocEntry" AS  b FROM OINV;
 END;
 select (select top 1 b from VeryComplexSum(1)) from dummy;
 
