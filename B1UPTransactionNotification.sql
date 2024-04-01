set schema sbodemoar;
CREATE OR REPLACE PROCEDURE SBO_SP_TransactionNotification
(
	in object_type nvarchar(30), 				-- SBO Object Type
	in transaction_type nchar(1),			-- [A]dd, [U]pdate, [D]elete, [C]ancel, C[L]ose
	in num_of_cols_in_key int,
	in list_of_key_cols_tab_del nvarchar(255),
	in list_of_cols_val_tab_del nvarchar(255)
)
LANGUAGE SQLSCRIPT
AS
-- Return values
error  int;							-- Result (0 for no error)
boyumseconds int;       			-- Para calcular la diferencia en segundos si paso demasiado tiempo no puede venir de Boyum.
NumberOfDifferences int;       		-- Conteo de Diferencias entre imagen previa y actual.
XMLData nclob;						-- Guardo los datos para comparar si cambiaron algo.
error_message nvarchar (200); 		-- Error string to be displayed
begin
/*
--Debug Objetos SAP
--una orden de venta crea :object_type = ('10000013', '17')
if :object_type not in ('10000013', '17') then
	error := :object_type;
	
	error_message := N'Debe estar configurado Boyum UP para crear o modificar este documento' || :list_of_cols_val_tab_del;
	select :error, :error_message FROM dummy;
	return;
end if;
--Debug Objetos SAP
*/


IF (:object_type = '112') THEN 
	BEGIN AUTONOMOUS TRANSACTION
		DECLARE CONTINUE HANDLER FOR SQL_ERROR_CODE 1299 BEGIN END;
		SELECT XMLRESULT into XMLData from (select DRF1."DocEntry", DRF1."LineNum", DRF1."ItemCode" from ODRF JOIN DRF1 on ODRF."DocEntry" = DRF1."DocEntry" where ODRF."DocEntry" = :list_of_cols_val_tab_del for XML);
	END;
	BEGIN
		DECLARE CONTINUE HANDLER FOR SQL_ERROR_CODE 259 BEGIN END;
		DROP TABLE #TMP;
		CREATE LOCAL TEMPORARY TABLE #TMP ("XMLData" nclob);
		INSERT INTO #TMP VALUES(:XMLData);
	END;
END IF;

If (:object_type = '112') and (:transaction_type = 'A' or :transaction_type = 'U') Then
	select ABS(COALESCE(SECONDS_BETWEEN(TO_TIMESTAMP(TO_NVARCHAR("U_BoyumTimeStamp")), CURRENT_TIMESTAMP),120)) into boyumseconds from ODRF where "DocEntry" = :list_of_cols_val_tab_del;
	if (:boyumseconds > 10) then
		error := :object_type;
		error_message := N'Boyum UP parece no estar habilitado. Para crear o modificar este documento borrador B1UP debe estar habilitado';
		select :error, :error_message FROM dummy;
		return;
	End if;
	
	If (:transaction_type = 'U') then
		PREVIMAGE = SELECT * FROM XMLTABLE('/resultset/row' PASSING #TMP."XMLData" COLUMNS "DocEntry" INT PATH 'DocEntry', "LineNum" INT PATH 'LineNum', "ItemCode" NVARCHAR(50) PATH 'ItemCode'); 
		select count(*) into NumberOfDifferences from DRF1 join :PREVIMAGE on DRF1."DocEntry" = :PREVIMAGE."DocEntry" and DRF1."LineNum" = :PREVIMAGE."LineNum" 
			where DRF1."ItemCode" <> :PREVIMAGE."ItemCode";
		if NumberOfDifferences != 0 then
			error := 1000;	
			error_message := N'Esta tratando de cambiar campos no permitidos';
			select :error, :error_message FROM dummy;
			return;
		end if;	
	End If;

End If;

error := 0;
error_message := N'';
select :error, :error_message FROM dummy;

end;
