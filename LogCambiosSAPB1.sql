do
begin
declare limite integer; 
select count(*) into limite from AITM where "ItemCode" = 'Phone';
limite = limite - 1;
select  * from AITM where "ItemCode" = 'Phone' limit 1 offset :limite;
end;
select  * from AITM;
