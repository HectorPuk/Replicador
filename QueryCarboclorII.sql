set schema SBODEMOAR;
do
begin

TABLACUENTA = 
select 1 "Orden", '4.4.010.10.102' "Account" from dummy
union all 
select 1, '4.4.010.10.103' from dummy
union all 
select 2, '4.4.010.10.104' from dummy;

TABLATITULO =
select 1 "Orden", 'Sueldos y Jornales Clase A' "Titulo" from dummy
union all
select 2 , 'Sueldos Clase B Prima' from dummy;

select * from :TABLACUENTA;
select * from :TABLATITULO;

CUENTAYTITULO = SELECT :TABLACUENTA."Orden", :TABLACUENTA."Account",:TABLATITULO."Titulo" from :TABLACUENTA join :TABLATITULO on :TABLACUENTA."Orden" = :TABLATITULO."Orden";

select * from :CUENTAYTITULO;

Q10 = select 
"Account",
"AcctName",
case when JDT1."ProfitCode" is not null then -SUM("Credit"-"Debit") else 0 end "Logistica", 
case when JDT1."OcrCode2" is not null then -SUM("Credit"-"Debit") else 0 end "Operacion", 
case when JDT1."OcrCode3" is not null then -SUM("Credit"-"Debit") else 0 end "Administracion"
from 
JDT1 
	join OACT on OACT."AcctCode" = JDT1."Account"
	
	where "Account" in (select "Account" from :CUENTAYTITULO) 
	Group by "Account", "AcctName", JDT1."ProfitCode", JDT1."OcrCode2", JDT1."OcrCode3"
	order by "Account";

(select "Account" "Cuenta", "AcctName" "Descripcion", Sum("Logistica") "Logistica", Sum("Operacion") "Operacion", Sum("Administracion") "Administracion", Sum("Logistica") + Sum("Operacion") + Sum("Administracion") "Total Horizontal" from :Q10 
where "Account" in(select "Account" from :CUENTAYTITULO where "Orden" = 1) group by "Account", "AcctName" order by "Account" )
union all 
select top 1 '', (select top 1 "Titulo" from :CUENTAYTITULO where "Orden" = 1), SUM("Logistica") , SUM("Operacion") , SUM("Administracion") , (SUM("Logistica")+ SUM("Operacion")+ SUM("Administracion")) from :Q10 where "Account" in(select "Account" from :CUENTAYTITULO where "Orden" = 1)
;	
end;
