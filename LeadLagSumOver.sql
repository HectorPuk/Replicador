
DO 
BEGIN 

--Query completo para detectar si le aplica retencion
--WTD4 contiene las tablas para las retenciones progresivas
--WTD2 tiene las escalas progresivas "SlScProgr" es el campo que dice Y / N si es progresiva
--RG 830 Retencion de Ganancias puede tener escala progresiva
--La WTD3 tiene 3 tipos de DetailType  A Aplicable, E Que porcentaje se exceptua, S Tasa Especial
--select * from CRD1;
--select  RETEN."U_B1SYS_JurisFrom", RETEN."U_B1SYS_JurisTo", RETEN.*  from OWTD RETEN;
--declare SAMPLE as INT;
--OJO NO PODES HACER DECLARE DESPUES DE UNA SENTENCIA EJECUTABLE. SOLO SE CREA AL PRINCIPIO. INVESTIGA!!!!!
--OJO2 If you want to access the value of the variable, then use :var in your code. If you want to assign a value to the variable, then use var in your code. 
--SAP recommends that you use only the = operator in defining scalar variables. (The := operator is still available, however.) 
--https://help.sap.com/viewer/de2486ee947e43e684d39702027f8a94/2.0.00/en-US/66b38a60ab3b475f925c224038511c51.html
--Pointer to cursor https://help.sap.com/viewer/de2486ee947e43e684d39702027f8a94/2.0.00/en-US/ed5b84901c864872aa8b000605d91b62.html
-- BaseType de la OWTD pueden ser 4 Letras. N es Neto - G es Bruto - o supongo gravable - V es IVA - H es Bruto Menos IVA (no se me queda claro esto vs Neto)
--Un Array puede ser pasado como parametro, pero debe hacerse un UNNEST. Esto devulve algo que se llama Table Type tipo xx = UNNEST(ARRAY(1,2) y luego selec* from :x OJO con los dos puntos.

DECLARE CUSTOMER VARCHAR(50) = 'C50000-V3';
DECLARE DOCRANGE INTEGER ARRAY = ARRAY(439,395);
DECLARE DATEBEGIN DATE = CURRENT_DATE;
DECLARE DATEEND DATE = CURRENT_DATE;
DECLARE SAMPLE INT = 1;
DECLARE SAMPLE2 INT = 1;
DECLARE CURSOR TablaDeUsuarios FOR SELECT USERID "Cuenta" FROM OUSR;


DOCRANGETABLE = UNNEST(:DOCRANGE);

FOR CursorRow as TablaDeUsuarios
	DO
	BEGIN
	SAMPLE2 = TablaDeUsuarios::rowcount;
	END;
END FOR;	
zz = (

--Tene en cuenta que los campos no pueden estar duplicados. Por ejemplo, estaba retornando T0."Rate" y T1."Rate" y eso me cancelaba Duplicate attribute name: Rate: line 36 col 1 (at pos 1914)

SELECT
	 T0."AbsEntry",
	 T0."WTCode",
	 T0."WTName",
     T0."U_B1SYS_WhtType",
     T0."BaseMin",
     T0."BaseType",
	 T2."CardCode",
	 T0."PrctBsAmnt",
	 T1."Rate",
	 --T0."Rate",
                T1."DetailType", 
	 (case when T1."Rate" > 0 
			and T1."DetailType" = 'S' 
			then T1."Rate" 
			else T0."Rate" 
			end) "RateAplicable",
	 (case when T1."Rate" > 0 
			and T1."DetailType" = 'E' 
			then T1."Rate" 
			else 0 
			end) "MontoExceptuado",
	 T0."U_B1SYS_JurisFrom",
	 T0."U_B1SYS_JurisTo" 
		FROM "OWTD" T0 
		INNER JOIN "WTD3" T1 ON T0."AbsEntry" = T1."AbsEntry" 
		INNER JOIN "OCRD" T2 ON T2."LicTradNum" = T1."KeyPart1" 
		AND T2."U_B1SYS_FiscIdType" = T1."KeyPart2" 

);

-- LEAD LAG

if 1 = 1 then  

miejemplo2 = select 1 "A", 10 "DocNum" ,  10 "Retencion" from dummy
Union all
select 1 "A",20 "DocNum" , 20  from dummy
Union all
select 1 "A",21 "DocNum" , 30  from dummy
union all 
select 1 "A",31 "DocNum" , 100  from dummy
Union all
select 1 "A",41 "DocNum" , 200  from dummy
Union all
select 1 "A",55 "DocNum" , 10.90  from dummy
union all 
select 1 "A",60 "DocNum" , 1000.50 from dummy
Union all
select 1 "A",61 "DocNum" , 20.22  from dummy
Union all
select 1 "A",62 "DocNum" , 3000.33 from dummy;

select lag("Retencion",1,0) over (partition by "A" order by "DocNum") + "Retencion" "Total", * from :miejemplo2;

-- El Over no lo tengo 100% agarrado pero ejecuta una agregation function como SUM sin particionar, el order le idica en que sentido ordenar.
select sum("Retencion") over (order by "DocNum"),  * from :miejemplo2;

select sum("Retencion") over (order by "A"),  * from :miejemplo2;

miejemplo3 = select 1 "A", 200 "B" , 10 "DocNum" ,  10 "Retencion" from dummy
Union all
select 1 "A", 190, 20 "DocNum" , 20  from dummy
Union all
select 1 "A", 180, 21 "DocNum" , 30  from dummy
union all 
select 1 "A", 170, 31 "DocNum" , 100  from dummy
Union all
select 1 "A", 160, 41 "DocNum" , 200  from dummy
Union all
select 1 "A", 150, 55 "DocNum" , 10.90  from dummy
union all 
select 1 "A", 140, 60 "DocNum" , 1000.50 from dummy
Union all
select 1 "A", 130, 61 "DocNum" , 20.22  from dummy
Union all
select 1 "A", 120, 62 "DocNum" , 3000.33 from dummy;


select sum("Retencion") over (order by "B"),  * from :miejemplo3;



end if;




-- ROLLUPS ejemplos....


if 1 = 2 then  

miejemplo = select 10 "DocNum" , 'R1' "WTCode" , 'Ret IVA' "WTName",  10 "Retencion" from dummy
Union all
select 10 "DocNum" , 'R2' , 'Ret IIBB BA', 20  from dummy
Union all
select 10 "DocNum" , 'R3' , 'Ret IIBB CABA', 30  from dummy
union all 
select 11 "DocNum" , 'R1', 'Ret IVA', 100  from dummy
Union all
select 11 "DocNum" , 'R2', 'Ret IIBB BA', 200  from dummy
Union all
select 11 "DocNum" , 'R3' , 'Ret IIBB CABA', 0  from dummy
union all 
select 12 "DocNum" , 'R1', 'Ret IVA', 1000 from dummy
Union all
select 12 "DocNum" , 'R2', 'Ret IIBB BA', 0  from dummy
Union all
select 12 "DocNum" , 'R3', 'Ret IIBB CABA', 3000 from dummy;


--select "DocNum", "WTCode", "WTName", sum("Retencion") from :miejemplo group by rollup("WTName","WTCode","DocNum");

select 
"DocNum", 
"WTCode", 
--"WTName", 
sum("Retencion") from :miejemplo group by "DocNum", rollup("WTCode");

-- Gouping set agrupa por mas de un campo Te da el total por factura y total por retencion.

select "DocNum", "WTCode", sum("Retencion") from :miejemplo group by grouping sets ("DocNum","WTCode");

-- Opcion de grouping set interesante, pero no le encuentro uso todavia.

select "DocNum", "WTCode", sum("Retencion") from :miejemplo group by grouping sets ("DocNum","WTCode",("DocNum","WTCode"));

--- CUBE interesante pero no encuentro uso todavia.

select "DocNum", "WTCode", sum("Retencion") from :miejemplo group by cube ("DocNum","WTCode");

-- tampoco uso al Grouping_id pero seguro que le voy a encontrar uso.

select "DocNum", "WTCode", sum("Retencion"), grouping_id("DocNum") from :miejemplo group by cube ("DocNum","WTCode");


select "DocNum", "WTCode", sum("Retencion") from :miejemplo group by grouping sets ("DocNum","WTCode");

select "DocNum", "WTCode", sum("Retencion") from :miejemplo group by grouping sets with balance ("DocNum","WTCode");

select "WTCode", sum("Retencion") from :miejemplo group by grouping sets limit 1 with balance ("WTCode");

select "WTCode", sum("Retencion") from :miejemplo group by grouping sets limit 1 offset 1 with balance ("WTCode");

select "WTCode", sum("Retencion") from :miejemplo group by grouping sets with balance ("WTCode");

select 'EXPERIMENTO', '', '', '',  "WTCode", sum("Retencion") from :miejemplo group by grouping sets with total ("WTCode");

select "DocNum", "WTCode", sum("Retencion") from :miejemplo group by grouping sets with subtotal with balance ("DocNum","WTCode");

select "DocNum", "WTCode", sum("Retencion") from :miejemplo group by grouping sets with subtotal with balance with total ("DocNum","WTCode");

select "DocNum", "WTCode", "Retencion" from :miejemplo group by grouping sets with subtotal with balance with total ("DocNum","WTCode","Retencion");

-- FIN ROLLUPS

end if;

select count(*) into SAMPLE from ORDR;

ElGranQuery = select *, 
"TotalEnPesos-IVA-PERC-AlDia" * "RateAplicable" / 100 "Ret.Calc.A.Hoy",
"TotaEnPesos-IVA-PERC" * "RateAplicable" / 100 "Ret.Calc.Fecha.Factura"

from 
(
select
	 RETEN."WTCode",
	 RETEN."WTName",
	 RETEN."U_B1SYS_WhtType",
	 RETEN."PrctBsAmnt",
	 RETEN."RateAplicable",
                 RETEN."BaseMin",
                   (case when RETEN."BaseType" = 'N' then 'Neto de impuestos (Al menos Sin IVA)'  when RETEN."BaseType" = 'G' then 'Bruto' when RETEN."BaseType" = 'V' then 'IVA' when RETEN."BaseType" = 'H' then 'Bruto - IVA'    else  RETEN."BaseType" end) "BaseTypeDesc",
	 RETEN."MontoExceptuado",
	 OINV."DocCur",
	 OINV."DocTotalFC",
	 OINV."DocRate",
	 OINV."DocNum",
	 OINV."DocEntry",
	 (case when OINV."DocCur" != 'ARS' then  (OINV."DocTotalFC" - OINV."VatSumFC" - OINV."WTSumFC") * (select "Rate" from ORTT where "Currency" = 'USD' and "RateDate" = DATEBEGIN) else (OINV."DocTotal" - OINV."VatSum" - OINV."WTSum") end ) "TotalEnPesos-IVA-PERC-AlDia",
	 (case when OINV."DocCur" != 'ARS' then  (OINV."DocTotalFC" - OINV."VatSumFC" - OINV."WTSumFC") * OINV."DocRate" else (OINV."DocTotal" - OINV."VatSum" - OINV."WTSum") end) "TotaEnPesos-IVA-PERC",
	 (case when OINV."DocCur" != 'ARS' then  (OINV."DocTotalFC" - OINV."VatSumFC") * (select "Rate" from ORTT where "Currency" = 'USD' and "RateDate" = DATEBEGIN) else (OINV."DocTotal" - OINV."VatSum") end ) "TotalEnPesos-IVA-AlDia",
	 (case when OINV."DocCur" != 'ARS' then  (OINV."DocTotalFC" - OINV."VatSumFC") * OINV."DocRate" else (OINV."DocTotal"  - OINV."VatSum") end) "TotalEnPesos-IVA",
	 (case when OINV."DocCur" != 'ARS' then  (OINV."DocTotalFC") * (select "Rate" from ORTT where "Currency" = 'USD' and "RateDate" = DATEBEGIN) else (OINV."DocTotal") end ) "TotalEnPesos-AlDia",
	 (case when OINV."DocCur" != 'ARS' then  (OINV."DocTotalFC") * OINV."DocRate" else (OINV."DocTotal") end) "TotalEnPesos"
	 
--	 OINV."ShipToCode",
--	 CRD1."State" "StateDestino",
--	 RETEN."U_B1SYS_JurisFrom",
--	 RETEN."U_B1SYS_JurisTo" 
from (
select
	 "WTCode",
                 "WTName",
                 (case when "U_B1SYS_WhtType" = 'G' then 'IIBB'  when "U_B1SYS_WhtType" = 'N' then 'Ganancias' when "U_B1SYS_WhtType" = 'V' then 'IVA' when "U_B1SYS_WhtType" = 'S' then 'Seguridad Social'  when "U_B1SYS_WhtType" = 'I' then 'Especifico de Industria' else "U_B1SYS_WhtType" end) "U_B1SYS_WhtType",
                 "CardCode",
--	 Max("CardCode") "CardCode",
                Max("BaseMin") "BaseMin",
                Max("BaseType") "BaseType",
	 Max("PrctBsAmnt") "PrctBsAmnt",
	 Max("RateAplicable") "RateAplicable",
	 Max("MontoExceptuado") "MontoExceptuado",
	 Max("U_B1SYS_JurisFrom") "U_B1SYS_JurisFrom",
	 Max("U_B1SYS_JurisTo") "U_B1SYS_JurisTo" 
	from (
SELECT
	 T0."AbsEntry",
	 T0."WTCode",
	 T0."WTName",
                T0."U_B1SYS_WhtType",
                T0."BaseMin",
                T0."BaseType",
	 T2."CardCode",
	 T0."PrctBsAmnt",
	T0."Rate",
	 T1."Rate",
                T1."DetailType", 
	 (case when T1."Rate" > 0 
			and T1."DetailType" = 'S' 
			then T1."Rate" 
			else T0."Rate" 
			end) "RateAplicable",
	 (case when T1."Rate" > 0 
			and T1."DetailType" = 'E' 
			then T1."Rate" 
			else 0 
			end) "MontoExceptuado",
	 T0."U_B1SYS_JurisFrom",
	 T0."U_B1SYS_JurisTo" 
		FROM "OWTD" T0 
		INNER JOIN "WTD3" T1 ON T0."AbsEntry" = T1."AbsEntry" 
		INNER JOIN "OCRD" T2 ON T2."LicTradNum" = T1."KeyPart1" 
		AND T2."U_B1SYS_FiscIdType" = T1."KeyPart2" 
		WHERE T2."CardCode" = CUSTOMER

		AND T0."Inactive" <> 'Y' -- Solo traigo las retenciones que sean activas.
        -- AND T1."DetailType" = 'A' A Aplicable, E Que porcentaje se exceptua, S Tasa Especial que viene en general del padron
		-- AND (T1."DateFrom" <= to_date('20211201','YYYYMMDD') AND (T1."DateTo" >= to_date('20211231','YYYYMMDD')	OR T1."DateTo" IS NULL )) --Evaluo Fecha de validez. 
		AND (T1."DateFrom" <= :DATEBEGIN AND (T1."DateTo" >= :DATEBEGIN OR T1."DateTo" IS NULL )) --Evaluo Fecha de validez. 
        -- AND T0."U_B1SYS_Relevance" = 'B' -- Letra 'B' Si solo aplica a SN o letra 'I' SN y Articulo
		AND T0."U_B1SYS_B1Company" <> 'N' -- Como es pago recibido no cuenta.	AND T0."U_B1SYS_B1Company" <> 'Y' -- SI Y implica que la compañia (Casa Magnani) debe retener.
		AND T0."Category" = 'P' --I si Percepcion en Factura/Invoice P en Payment retencion en pago. 
		-- AND T0."SlScProgr" = 'N' --Excluyo escala progresiva porque entiendo que el unico es ganancias y necesito calcularlo sobre el total del pago.
		ORDER BY T0."AbsEntry",
	 T1."DateFrom"
) group by "WTCode","WTName", "U_B1SYS_WhtType","CardCode" Order by "WTCode"
) RETEN join OINV on RETEN."CardCode" = OINV."CardCode"

where OINV."DocNum" in (select * from :DOCRANGETABLE)
-- JOIN CRD1 on RETEN."CardCode" = CRD1."CardCode" 
--and OPCH."ShipToCode" = CRD1."Address" 
order by RETEN."WTCode"

); 

 
Select null "Referencia", * from :ElGranQuery
union all
select null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null from dummy
union all
(select 'Subtotal Retencion: ' || "WTCode",null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,
SUM("Ret.Calc.A.Hoy") "Ret.Calc.A.Hoy",sum("Ret.Calc.Fecha.Factura") "Ret.Calc.Fecha.Factura" from :ElGranQuery group by "WTCode")
union all
select null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null from dummy
union all
(select 'Subtotal DocNum: ' || cast("DocNum" as VARCHAR) ,null, null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,
SUM("Ret.Calc.A.Hoy") "Ret.Calc.A.Hoy",sum("Ret.Calc.Fecha.Factura") "Ret.Calc.Fecha.Factura" from :ElGranQuery group by "DocNum")
union all
select null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null from dummy
union all
(select 'Total' ,null, null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,
SUM("Ret.Calc.A.Hoy") "Ret.Calc.A.Hoy", sum("Ret.Calc.Fecha.Factura") "Ret.Calc.Fecha.Factura" from :ElGranQuery);

if 1 = 2 then  


select "DocNum", SUM("Ret.Calc.A.Hoy"),sum("Ret.Calc.Fecha.Factura") from :ElGranQuery group by "DocNum";
select SUM("Ret.Calc.A.Hoy"),sum("Ret.Calc.Fecha.Factura") from :ElGranQuery;

end if;  
END;
