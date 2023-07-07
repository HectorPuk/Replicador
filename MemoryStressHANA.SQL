do
begin
DECLARE CONTINUE HANDLER FOR SQL_ERROR_CODE 259
BEGIN
END;
DROP TABLE #TMP;
DROP TABLE #TMP2;
ALAMBRE = select "CardCode", XMLRESULT from (select * from OINV for XML), (select top 30 * from OINV);
ALAMBRE2 = select "DocEntry", XMLRESULT from (select * from OINV for XML), (select top 30 * from OINV);
ALAMBRE3 = select "CardName", XMLRESULT from (select * from OINV for XML), (select top 30 * from OINV);
create LOCAL TEMPORARY TABLE #TMP as (select * from :ALAMBRE);
create LOCAL TEMPORARY TABLE #TMP2 as (select * from :ALAMBRE2);
END;
--select * from #TMP;
