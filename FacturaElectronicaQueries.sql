--Busco Facturas tipo Credito
select "EDocType", "EDocGenTyp", "DocType", "DocSubType", * from OINV 
where 
--"EDocType" = 'C' and
 "EDocGenTyp" != 'N' and
"DocType" = 'S';
select "EDocType", INV1."AcctCode", OINV.* from OINV join INV1 on OINV."DocEntry" = INV1."DocEntry"   
where 
--"EDocType" = 'C' and 
INV1."AcctCode" in( '4.5.010.10.101', '4.6.010.10.101', '4.5.010.10.102', '4.6.010.10.102') and
 --"EDocGenTyp" != 'N' and
"DocType" = 'S'; 
