--select * from ODRF order by "DocEntry" desc;
do begin

declare a decimal(10,3);
declare b decimal(10,3);
declare c decimal(10,3);
declare d decimal(10,3);

a = 10.11;
b = 10.14;
c = 10.15;
d = 10.19;
select a , round(a, 1, ROUND_UP),round(b, 1, ROUND_UP),round(c, 1, ROUND_UP),round(d, 1, ROUND_UP) from dummy;
select a , round(a, 1, ROUND_DOWN),round(b, 1,ROUND_DOWN),round(c, 1, ROUND_DOWN),round(d, 1, ROUND_DOWN) from dummy;
select a , round(a, 1, ROUND_HALF_DOWN),round(b, 1,ROUND_HALF_DOWN),round(c, 1, ROUND_HALF_DOWN),round(d, 1, ROUND_HALF_DOWN) from dummy;
select a , round(a, 1, ROUND_HALF_UP),round(b, 1,ROUND_HALF_UP),round(c, 1, ROUND_HALF_UP),round(d, 1, ROUND_HALF_UP) from dummy;
select a , round(a, 1, ROUND_HALF_EVEN),round(b, 1,ROUND_HALF_EVEN),round(c, 1, ROUND_HALF_EVEN),round(d, 1, ROUND_HALF_EVEN) from dummy;
select a , round(a, 1, ROUND_FLOOR),round(b, 1,ROUND_FLOOR),round(c, 1, ROUND_FLOOR),round(d, 1, ROUND_FLOOR) from dummy;
select a , round(a, 1, ROUND_CEILING),round(b, 1,ROUND_CEILING),round(c, 1, ROUND_CEILING),round(d, 1, ROUND_CEILING) from dummy;
select -a , round(-a, 1, ROUND_FLOOR),round(-b, 1,ROUND_FLOOR),round(-c, 1, ROUND_FLOOR),round(-d, 1, ROUND_FLOOR) from dummy;
select -a , round(-a, 1, ROUND_CEILING),round(-b, 1,ROUND_CEILING),round(-c, 1, ROUND_CEILING),round(-d, 1, ROUND_CEILING) from dummy;
a = 101.11;
b = 101.14;
c = 101.15;
d = 101.19;
select a , round(a, -1, ROUND_UP),round(b, -1, ROUND_UP),round(c, -1, ROUND_UP),round(d, -1, ROUND_UP) from dummy;
select a , round(a, -1, ROUND_DOWN),round(b, -1,ROUND_DOWN),round(c, -1, ROUND_DOWN),round(d, -1, ROUND_DOWN) from dummy;
select a , round(a, -1, ROUND_HALF_DOWN),round(b, -1,ROUND_HALF_DOWN),round(c, -1, ROUND_HALF_DOWN),round(d, -1, ROUND_HALF_DOWN) from dummy;
select a , round(a, -1, ROUND_HALF_UP),round(b, -1,ROUND_HALF_UP),round(c, -1, ROUND_HALF_UP),round(d, -1, ROUND_HALF_UP) from dummy;
select a , round(a, -1, ROUND_HALF_EVEN),round(b, -1,ROUND_HALF_EVEN),round(c, -1, ROUND_HALF_EVEN),round(d, -1, ROUND_HALF_EVEN) from dummy;
select a , round(a, -1, ROUND_FLOOR),round(b, -1,ROUND_FLOOR),round(c, -1, ROUND_FLOOR),round(d, -1, ROUND_FLOOR) from dummy;
select a , round(a, -1, ROUND_CEILING),round(b, -1,ROUND_CEILING),round(c, -1, ROUND_CEILING),round(d, -1, ROUND_CEILING) from dummy;
select -a , round(-a, -1, ROUND_FLOOR),round(-b, -1,ROUND_FLOOR),round(-c, -1, ROUND_FLOOR),round(-d, -1, ROUND_FLOOR) from dummy;
select -a , round(-a, -1, ROUND_CEILING),round(-b, -1,ROUND_CEILING),round(-c, -1, ROUND_CEILING),round(-d, -1, ROUND_CEILING) from dummy;

end;

declare a decimal(10,3);
declare b decimal(10,3);
declare c decimal(10,3);
declare d decimal(10,3);
declare a2 decimal(10,3);
declare b2 decimal(10,3);
declare c2 decimal(10,3);
declare d2 decimal(10,3);

a = 10.11;
b = 10.14;
c = 10.15;
d = 10.19;
a2 = 101.11;
b2 = 101.14;
c2 = 101.15;
d2 = 101.19;
select 'ROUND_UP', a "a", b "b", c "c", d "c", round(a, 1, ROUND_UP) "ROUND a",round(b, 1, ROUND_UP) "ROUND b",round(c, 1, ROUND_UP) "ROUND c",round(d, 1, ROUND_UP) "ROUND d" from dummy
 union all 
select 'ROUND_DOWN', a , b, c, d, round(a, 1, ROUND_DOWN),round(b, 1,ROUND_DOWN),round(c, 1, ROUND_DOWN),round(d, 1, ROUND_DOWN) from dummy
 union all 
select 'ROUND_HALF_DOWN', a , b, c, d, round(a, 1, ROUND_HALF_DOWN),round(b, 1,ROUND_HALF_DOWN),round(c, 1, ROUND_HALF_DOWN),round(d, 1, ROUND_HALF_DOWN) from dummy 
 union all 
select 'ROUND_HALF_UP', a , b, c, d, round(a, 1, ROUND_HALF_UP),round(b, 1,ROUND_HALF_UP),round(c, 1, ROUND_HALF_UP),round(d, 1, ROUND_HALF_UP) from dummy 
 union all 
select 'ROUND_HALF_EVEN', a , b, c, d, round(a, 1, ROUND_HALF_EVEN),round(b, 1,ROUND_HALF_EVEN),round(c, 1, ROUND_HALF_EVEN),round(d, 1, ROUND_HALF_EVEN) from dummy 
 union all 
select 'ROUND_FLOOR', a , b, c, d, round(a, 1, ROUND_FLOOR),round(b, 1,ROUND_FLOOR),round(c, 1, ROUND_FLOOR),round(d, 1, ROUND_FLOOR) from dummy 
 union all 
select 'ROUND_CEILING', a , b, c, d, round(a, 1, ROUND_CEILING),round(b, 1,ROUND_CEILING),round(c, 1, ROUND_CEILING),round(d, 1, ROUND_CEILING) from dummy 
 union all 
select 'ROUND_FLOOR Negativo', -a , -b, -c, -d, round(-a, 1, ROUND_FLOOR),round(-b, 1,ROUND_FLOOR),round(-c, 1, ROUND_FLOOR),round(-d, 1, ROUND_FLOOR) from dummy 
 union all 
select 'ROUND_CEILING Negativo',-a , -b, -c, -d, round(-a, 1, ROUND_CEILING),round(-b, 1,ROUND_CEILING),round(-c, 1, ROUND_CEILING),round(-d, 1, ROUND_CEILING) from dummy 
 union all 


select 'ROUND_UP',a2 , b2, c2, d2, round(a2, -1, ROUND_UP),round(b2, -1, ROUND_UP),round(c2, -1, ROUND_UP),round(d2, -1, ROUND_UP) from dummy 
 union all 
select 'ROUND_DOWN',a2 , b2, c2, d2, round(a2, -1, ROUND_DOWN),round(b2, -1,ROUND_DOWN),round(c2, -1, ROUND_DOWN),round(d2, -1, ROUND_DOWN) from dummy 
 union all 
select 'ROUND_HALF_DOWN',a2 , b2, c2, d2, round(a2, -1, ROUND_HALF_DOWN),round(b2, -1,ROUND_HALF_DOWN),round(c2, -1, ROUND_HALF_DOWN),round(d2, -1, ROUND_HALF_DOWN) from dummy 
 union all 
select 'ROUND_HALF_UP',a2 , b2, c2, d2, round(a2, -1, ROUND_HALF_UP),round(b2, -1,ROUND_HALF_UP),round(c2, -1, ROUND_HALF_UP),round(d2, -1, ROUND_HALF_UP) from dummy 
 union all 
select 'ROUND_HALF_EVEN', a2 , b2, c2, d2, round(a2, -1, ROUND_HALF_EVEN),round(b2, -1,ROUND_HALF_EVEN),round(c2, -1, ROUND_HALF_EVEN),round(d2, -1, ROUND_HALF_EVEN) from dummy 
 union all 
select 'ROUND_FLOOR', a2 , b2, c2, d2, round(a2, -1, ROUND_FLOOR),round(b2, -1,ROUND_FLOOR),round(c2, -1, ROUND_FLOOR),round(d2, -1, ROUND_FLOOR) from dummy 
 union all 
select 'ROUND_CEILING',a2 , b2, c2, d2, round(a2, -1, ROUND_CEILING),round(b2, -1,ROUND_CEILING),round(c2, -1, ROUND_CEILING),round(d2, -1, ROUND_CEILING) from dummy 
 union all 
select 'ROUND_FLOOR Negativo', -a2 , -b2, -c2, -d2, round(-a2, -1, ROUND_FLOOR),round(-b2, -1,ROUND_FLOOR),round(-c2, -1, ROUND_FLOOR),round(-d2, -1, ROUND_FLOOR) from dummy 
 union all 
select 'ROUND_CEILING Negativo', -a2 , -b2, -c2, -d2, round(-a2, -1, ROUND_CEILING),round(-b2, -1,ROUND_CEILING),round(-c2, -1, ROUND_CEILING),round(-d2, -1, ROUND_CEILING) from dummy;

