set schema AR_VKM_PROD_1;
select * from OUSR;
do
begin
declare data  varchar(50000);
declare datadif  varchar(50000);
declare data2 varchar(200);
declare data1 varchar(200);
declare Index1 Integer;

data = '';
datadif = '';

for Index1 in 1..2214 DO
select unicode(substr("ALLOWENCES",Index1,1)) into data1 from AR_VKM_PROD_1.ousr where USER_CODE in('smolina');
select unicode(substr("ALLOWENCES",Index1,1)) into data2 from AR_VKM_TRANSELEC_PROD_2.ousr where USER_CODE in('fduchini');
data = data || 'smolina' || data1 || 'fduchini' || data2 || char(13);
if data1 != data2
	then
	datadif = datadif || 'linea:' || Index1 || ' smolina ' || data1 || ' fduchini ' || data2 || char(13);
end if;	
end for;
--select USER_CODE,unicode(substr("ALLOWENCES",1,1)) from SBODEMOAR.ousr where USER_CODE in('Catalina');

--select unicode(substr("ALLOWENCES",1,1)) into data2 from SBODEMOAR.ousr where USER_CODE in('Catalina');
--data1 = data1 || data2;
--select 'm' into data2 from SBODEMOAR.ousr where USER_CODE in('Catalina');
--data1 = data1 || ' ' || data2;

select data, datadif from dummy;
select USER_CODE,cast(bintostr(cast("ALLOWENCES" as binary)) as varchar), bintostr(cast("ALLOWENCES" as binary)),cast("ALLOWENCES" as binary) from AR_VKM_PROD_1.ousr where USER_CODE in('smolina');
--select "ALLOWENCES" into data from SBODEMOAR.ousr where USER_CODE in('Catalina');
end;
--select USER_CODE,unicode(substr("ALLOWENCES",1,1)) from SBODEMOAR.ousr where USER_CODE in('Catalina');
--select length("ALLOWENCES") from SBODEMOAR.ousr where USER_CODE in('Catalina');
