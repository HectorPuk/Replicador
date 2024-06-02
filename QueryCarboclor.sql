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
select 1 "Orden", 'Subtotal #1' "Titulo" from dummy
union all
select 2 , 'Subtotal #2' from dummy;

select * from :TABLACUENTA;
select * from :TABLATITULO;

CUENTAYTITULO = SELECT :TABLACUENTA."Orden", :TABLACUENTA."Account",:TABLATITULO."Titulo" from :TABLACUENTA join :TABLATITULO on :TABLACUENTA."Orden" = :TABLATITULO."Orden";

select * from :CUENTAYTITULO;

Q9 = select 
"Account",
"AcctName",
case when OCR1."PrcCode" = 'PDR1' then SUM("Credit"-"Debit") else 0 end "PDR1", 
case when OCR1."PrcCode" = 'GOP' then SUM("Credit"-"Debit") else 0 end "GOP", 
case when OCR1."PrcCode" = 'GAD' then SUM("Credit"-"Debit") else 0 end "GAD"
from 
JDT1 join OOCR on JDT1."ProfitCode" = OOCR."OcrCode" 
	join OCR1 on OCR1."OcrCode" = OOCR."OcrCode"
	join OPRC on OPRC."PrcCode" = OCR1."PrcCode"
	join OACT on OACT."AcctCode" = JDT1."Account"
	
--	where "Account" in ('4.4.010.10.102','4.4.010.10.103', '4.4.010.10.104') 
	where "Account" in (select "Account" from :CUENTAYTITULO) 
	Group by "Account", "AcctName", OCR1."PrcCode"
	order by "Account";
select "Account", "AcctName", SUM("PDR1") "Gastos De Produccion", SUM("GOP") "Gastos de Operaciones", SUM("GAD") "Gastos Administracion", SUM("PDR1")+SUM("GOP")+SUM("GAD") "Total por Cuenta" 
from :Q9 where "Account" in(select "Account" from :CUENTAYTITULO where "Orden" = 1) group by "Account", "AcctName" 
union all 
select top 1 (select top 1 "Titulo" from :CUENTAYTITULO where "Orden" = 1), '', SUM("PDR1") , SUM("GOP") , SUM("GAD") , SUM("PDR1")+SUM("GOP")+SUM("GAD") from :Q9 where "Account" in(select "Account" from :CUENTAYTITULO where "Orden" = 1)
union all
select "Account", "AcctName", SUM("PDR1") "Gastos De Produccion", SUM("GOP") "Gastos de Operaciones", SUM("GAD") "Gastos Administracion", SUM("PDR1")+SUM("GOP")+SUM("GAD") "Total por Cuenta" 
from :Q9 where "Account" in(select "Account" from :CUENTAYTITULO where "Orden" = 2) group by "Account", "AcctName" 
union all 
select top 1 (select top 1 "Titulo" from :CUENTAYTITULO where "Orden" = 2), '', SUM("PDR1") , SUM("GOP") , SUM("GAD") , SUM("PDR1")+SUM("GOP")+SUM("GAD") from :Q9 where "Account" in(select "Account" from :CUENTAYTITULO where "Orden" = 1);	

	
	
end;
