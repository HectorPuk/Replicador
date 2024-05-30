do
begin

Q1 = select 
"Account", 
"ProfitCode", 
case when OCR1."PrcCode" = '0001' then 'KP1' else null end "KP1", 
case when OCR1."PrcCode" = '0002' then 'KP2' else null end "KP2", 
case when OCR1."PrcCode" = '0003' then 'KP3' else null end "KP3", 
OCR1."PrcCode",
OPRC."PrcName",
"Credit",
"Debit"
from 
JDT1 join OOCR on JDT1."ProfitCode" = OOCR."OcrCode" 
	join OCR1 on OCR1."OcrCode" = OOCR."OcrCode"
	join OPRC on OPRC."PrcCode" = OCR1."PrcCode"
	where "Account" = '4.4.010.10.013';

Q2 = select
(select top 1 "Account" from :Q1) "Account",
(Select sum("Credit" - "Debit") from :Q1 where "PrcCode" = ('0001')) "D1",
(Select sum("Credit" - "Debit") from :Q1 where "PrcCode" = ('0002')) "D2",
(Select sum("Credit" - "Debit") from :Q1 where "PrcCode" = ('0003')) "D3"
from dummy;

select "Account", "D1","D2","D3","D1"+"D2"+"D3" "SUMA" from :Q2;

select "Postable", * from OACT;
end;