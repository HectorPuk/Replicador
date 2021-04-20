set schema SBODEMOAR;
--  delete from "SB1OBJECTLOG";
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

