-- Aqui uso group expresion encerrada entre parentesis y le digo que del grupo 1 encuentre la primer, segunda o n-esima ocurrencia
select 'Group 1 Occurrence 1', substr_regexpr('<CardCode>(.+?)<\/CardCode>' in (select top 10 "CardCode" from OINV for xml)  OCCURRENCE 1 GROUP 1) from dummy;
select 'Group 1 Occurrence 2', substr_regexpr('<CardCode>(.+?)<\/CardCode>' in (select top 10 "CardCode" from OINV for xml) OCCURRENCE 2 GROUP 1 ) from dummy;


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

