select ECM3."AbsEntry", base64_decode(ECM3."LogData"), ECM3."LogNum" from ECM3 join (select "AbsEntry", Max("LogNum") -1 "LogNum" from ecm3 group by "AbsEntry") ECM3BIS 
on ECM3."AbsEntry" = ECM3BIS."AbsEntry" and ECM3."LogNum" = ECM3BIS."LogNum" 
order by "AbsEntry" desc;
select * from ecm3 order by "AbsEntry" desc;
