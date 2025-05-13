Select *, r."ProcName"
 from "USR5" r
 
-- group by r."ProcName"
Where  r."ProcName" in('SAP Business One.exe', 'DTW.exe') and r."Action" = 'I' and  r."ActionBy" = 'manager'
order by "Date" desc
