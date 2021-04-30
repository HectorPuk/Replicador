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
