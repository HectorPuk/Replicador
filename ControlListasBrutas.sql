select 
ITM1."ItemCode",
ITM1."Price" "Precio Neto",
OSTC."Name",
OSTC."Rate",
ITM1."Price" * (1 + OSTC."Rate" / 100) "Precio Bruto",
round(ITM1."Price" * (1 + OSTC."Rate" / 100),2,ROUND_HALF_UP),
ITMBRUTO."Price", 
ITM1."Price" * (1 + OSTC."Rate" / 100) - ITMBRUTO."Price",
round(ITM1."Price" * (1 + OSTC."Rate" / 100),2,ROUND_HALF_UP) - ITMBRUTO."Price",
OITM."validFor"



--count(*)
 from ITM1 join OITM on OITM."ItemCode" = ITM1."ItemCode" and ITM1."PriceList" = 3
join OSTC on OSTC."Code" = OITM."TaxCodeAR" 
join ITM1 ITMBRUTO on ITM1."ItemCode" = ITMBRUTO."ItemCode" and ITMBRUTO."PriceList" = 12
where 
--ITM1."PriceList" = 3 and 
"validFor" = 'Y' 
and 
round(ITM1."Price" * (1 + OSTC."Rate" / 100),2,ROUND_HALF_UP) - ITMBRUTO."Price" != 0

--and DAYS_BETWEEN(OITM."UpdateDate",current_date) < 20;-- order by OSTC."Name" desc, ITM1."Price" desc;

--select * from ODRF order by "DocEntry" desc
;
