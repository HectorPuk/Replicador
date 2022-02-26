ALTER SEQUENCE ODRF_S RESTART WITH 37124;
select * from ODRF order by "DocEntry" desc;
select top 10 * from cgev order by "EventDate" desc;
select count(*) from cgev;

select count(*), "UserCode" from cgev group by "UserCode" ;
select * from cgev where "UserCode" = 'Daniel';
select count(*), "EventType" from cgev group by "EventType" ;
select count(*), "SourceIP" from cgev group by "SourceIP" ;
select top 10 * from cgev where "SourceIP" like '%10.0.30.106%';
SELECT TABLE_NAME AS "Table"
, round(MEMORY_SIZE_IN_TOTAL/1024/1024, 2) as "MB" 
FROM M_CS_TABLES WHERE SCHEMA_NAME = 'DSLPRODUC2' and TABLE_NAME LIKE 'CG%'
 ORDER BY "MB" DESC;
SELECT TABLE_NAME AS "Table"
, round(MEMORY_SIZE_IN_TOTAL/1024/1024, 2) as "MB" 
FROM M_CS_TABLES WHERE SCHEMA_NAME = 'DSLPRODUC2' 
 ORDER BY "MB" DESC;
SELECT sum(round(MEMORY_SIZE_IN_TOTAL/1024/1024, 2)) as "MB" 
FROM M_CS_TABLES WHERE SCHEMA_NAME = 'DSLPRODUC2' 
 ORDER BY "MB" DESC;
  
