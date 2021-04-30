select
	 ORIN."Rounding",
	 ORIN."RoundDif",
	 RIN1."LineNum",
	 RIN1."PriceBefDi",
	 RIN1."DiscPrcnt",
	 RIN1."PriceBefDi" * (100 - RIN1."DiscPrcnt") / 100 "DescCalculado",
	 (RIN1."PriceBefDi" * (100 - RIN1."DiscPrcnt") / 100) - RIN1."Price" ,
	 RIN1."VatSum",
	 RIN1."VatPrcnt",
	 (RIN1."PriceBefDi" * (100 - RIN1."DiscPrcnt") / 100) * 0.21  "VAT Calcululado x Mi" ,
	 RIN1."Price",	 
	 * 
from ORIN join RIN1 on ORIN."DocEntry" = RIN1."DocEntry" 
where "Rounding" = 'Y' 
order by ORIN."DocEntry" desc,
	 RIN1."LineNum" asc
;

select
--	 ORIN."Rounding",
	 ORIN."RoundDif",
	 ORIN."DocEntry",
	 ORIN."DocNum",
	 --RIN1."LineNum",
	 --RIN1."PriceBefDi",
	 --RIN1."DiscPrcnt",
	 --RIN1."PriceBefDi" * (100 - RIN1."DiscPrcnt") / 100,
	 sum((RIN1."PriceBefDi" * (100 - RIN1."DiscPrcnt") / 100) - RIN1."Price")
	 --RIN1."Price",	 
--	 * 
from ORIN join RIN1 on ORIN."DocEntry" = RIN1."DocEntry" 
where "Rounding" = 'Y' 
group by ORIN."DocEntry", ORIN."DocNum",  ORIN."RoundDif"

order by ORIN."DocEntry" desc
;


select
	ORIN."DocEntry",
	 ORIN."Rounding",
	 ORIN."RoundDif",
	 ORIN."GrosProfit",
	 ORIN."Rounding",
	 ORIN."RoundDif",
	 ORIN."VatSum",
	 ORIN."WTSum",
	 ORIN."DocTotal",

--	 RIN1."LineNum",
--	 RIN1."PriceBefDi",
--	 RIN1."DiscPrcnt",
--	 RIN1."PriceBefDi" * (100 - RIN1."DiscPrcnt") / 100 "DescCalculado",
--	 (RIN1."PriceBefDi" * (100 - RIN1."DiscPrcnt") / 100) - RIN1."Price" ,
	 sum(RIN1."VatSum"),
	 sum(RIN1."VatSum") - ORIN."VatSum",
	 
--	 RIN1."VatPrcnt",
--	 (RIN1."PriceBefDi" * (100 - RIN1."DiscPrcnt") / 100) * 0.21  "VAT Calcululado x Mi" ,
	 sum(RIN1."Price"), 
	 sum(RIN1."Price") - ORIN."GrosProfit"
	 --,	 
	 --* 
from ORIN join RIN1 on ORIN."DocEntry" = RIN1."DocEntry" 
where "Rounding" = 'Y' 
group by  
ORIN."DocEntry",
ORIN."Rounding",
	 ORIN."RoundDif",
	 ORIN."GrosProfit",
	 ORIN."Rounding",
	 ORIN."RoundDif",
	 ORIN."VatSum",
	 ORIN."WTSum",
	 ORIN."DocTotal"
order by ORIN."DocEntry" desc
;


















select
	 ORIN."Rounding",
	 ORIN."RoundDif",
	 ORIN."DocTotal",
	 * 
from ORIN 
where "Rounding" = 'Y' 
order by ORIN."DocEntry" desc
;



select
	 "Rounding",
	 "RoundDif",
	 * 
from OINV join INV1 on OINV."DocEntry" = INV1."DocEntry" 
where "Rounding" = 'Y' 
and "DocSubType" = 'DN' 
order by OINV."DocEntry" desc,
	 INV1."LineNum" asc
;
select
	 "Rounding",
	 "RoundDif",
	 * 
from OINV join INV1 on OINV."DocEntry" = INV1."DocEntry" 
where "Rounding" = 'Y' 
and "DocSubType" != 'DN' 
order by OINV."DocEntry" desc,
	 INV1."LineNum" asc
;
