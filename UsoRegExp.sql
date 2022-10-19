--Con REGEXPR tenes 4 funciones. LOCATE (devuelve posicion), SUBSTR devuelve la string, OCCURENCES cuenta las ocurrencias y REPLACE cambia algo en la string
-- Aqui uso group expresion encerrada entre parentesis y le digo que del grupo 1 encuentre la primer, segunda o n-esima ocurrencia
select 'Group 1 Occurrence 1', substr_regexpr('<CardCode>(.+?)<\/CardCode>' in (select top 10 "CardCode" from OINV for xml)  OCCURRENCE 1 GROUP 1) from dummy;
select 'Group 1 Occurrence 2', substr_regexpr('<CardCode>(.+?)<\/CardCode>' in (select top 10 "CardCode" from OINV for xml) OCCURRENCE 2 GROUP 1 ) from dummy;
--Locate me devuelve la posicion.
SELECT LOCATE_REGEXPR(START '([[:digit:]]{4})([[:digit:]]{2})([[:digit:]]{2})' IN '20140401' GROUP 3) "locate_regexpr" FROM DUMMY;
-- Occurrences me devuelve la cantidad de repeticiones.
SELECT OCCURRENCES_REGEXPR('([[:digit:]])' IN 'a1b2') "occurrences_regexpr" FROM DUMMY;
select 'Number of Occurrences', OCCURRENCES_REGEXPR('<CardCode>(.+?)<\/CardCode>' in (select top 10 "CardCode" from OINV for xml)) from dummy;
--Replace en el caso de abajo remplaza el - por / en la fecha
SELECT REPLACE_REGEXPR('([[:digit:]]{4})-([[:digit:]]{2})-([[:digit:]]{2})' IN '2014-04-01' 
WITH '\3/\2/\1' OCCURRENCE ALL) "replace_regexpr" FROM DUMMY;


set schema SBODEMOAR;
--delete from "SB1OBJECTLOG";
select * from "SB1OBJECTLOG" order by "Sequence" desc;
select locate_regexpr('\t' in "ListOfKeyColsTabDel"), 
replace(substr_regexpr('\w*\t' in "ListOfKeyColsTabDel" OCCURRENCE 1),'	',''), 
replace(substr_regexpr('\w*\t' in "ListOfKeyColsTabDel" OCCURRENCE 2),'	',''), 
replace(substr_regexpr('\w*\t' in "ListOfKeyColsTabDel" OCCURRENCE 3),'	',''), 
replace(substr_regexpr('\t(\w+)$' in "ListOfKeyColsTabDel"),'	','') 
from "SB1OBJECTLOG" order by "Sequence" desc;
select * from OWHT;
select * from OWTD;
select count(*)  from OCRD where "CardCode" =  'COCA';
select * from OCRB;
select * from OCMH;

