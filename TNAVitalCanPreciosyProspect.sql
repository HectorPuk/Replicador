ALTER PROCEDURE SBO_SP_TRANSACTIONNOTIFICATION
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
error int;	-- Result (0 for no error)
error_message nvarchar(200); -- Error string to be displayed
cnt int;					-- VKM
i int;						-- VKM
stop nvarchar(1);			-- VKM
VKMCnnCode nvarchar(100);	-- VKM
VKMObjStatus nvarchar(3);	-- VKM
VKM_SND_LOG nvarchar(1);	-- VKM
ObjectKey nvarchar(255);	-- VKM
ObjectType nvarchar(30);	-- VKM
BaseEntry_Rel int;			-- VKM
BaseType_Rel nvarchar(30);	-- VKM
VKMCnnCode_Rel nvarchar(100);	-- VKM
VKM_SND_LOG_Rel nvarchar (1);	-- VKM
cntRel int;					-- VKM
list_of_VKMCnnCode_Rel nvarchar(255);	-- VKM
list_of_VKM_SND_LOG_Rel nvarchar(255);	-- VKM
Modo nchar(1);				-- VKM

VKM_NOV_ART nvarchar (1); 		-- VKMPARM
VKM_NOV_ENT nvarchar (1); 		-- VKMPARM
VKM_Expedicion nvarchar (20);	-- VKMPARM 
VKM_Envia_Entrega nvarchar (1);	-- VKMPARM
VKM_ObjDestino nvarchar (3);	-- VKMPARM


begin

error := 0;
error_message := N'Ok';


--INICIO: CONTROL DE PRECIOS Y TIPO DE CLIENTE AL CREAR OV
-- REQUERIMIENTO1: Si la OV tiene una linea con precio antes de descuento = 0 no dejar crear OV.
-- REQUERIMIENTO2: Si el tipo de SN es Lead no dejar crear OV.

If  :object_type = '17' AND  transaction_type = 'A' then

/* Comentado pues solo corresponde si el XML existe en U_Deta2
	SELECT count(*) into cnt FROM "RDR1" WHERE "DocEntry" = :list_of_cols_val_tab_del and "U_Deta2" is null ;
	
	if cnt > 0 then

		error := 1;
		error_message := N'Falla lineas sin dato de precio';
		select :error, :error_message FROM dummy;
		return;

	end if;
*/	 
	SELECT count(*) into cnt FROM "RDR1" WHERE "DocEntry" = :list_of_cols_val_tab_del and "PriceBefDi" = 0 and "TreeType" in ('S','N') ;

	if cnt > 0 then

		error := 1;
		error_message := N'Verifique que todas las lineas tengan el precio distinto de 0';
		select :error, :error_message FROM dummy;
		return;

	end if;

	select count(*) into cnt from ORDR join OCRD on ORDR."CardCode" = OCRD."CardCode" WHERE ORDR."DocEntry" = :list_of_cols_val_tab_del and OCRD."CardType" = 'L';

	if cnt > 0 then

		error := 1;
		error_message := N'No puede crear Orden de Venta para un prospecto que no es cliente';
		select :error, :error_message FROM dummy;
		return;

	end if;

end if;

If  :object_type = '112' AND  transaction_type = 'A' then

	SELECT count(*) into cnt FROM DRF1 join ODRF on DRF1."DocEntry" = ODRF."DocEntry" WHERE ODRF."ObjType" = 17 and ODRF."DocEntry" = :list_of_cols_val_tab_del and "PriceBefDi" = 0 and "TreeType" in ('S','N') ;

	if cnt > 0 then

		error := 1;
		error_message := N'Trata grabar un borrador o de mandar a un proceso de autorización una Orden de Venta con al menos una linea con precio 0';
		select :error, :error_message FROM dummy;
		return;

	end if;

	select count(*) into cnt from ODRF join OCRD on ODRF."CardCode" = OCRD."CardCode" WHERE ODRF."ObjType" = 17 and ODRF."DocEntry" = :list_of_cols_val_tab_del and OCRD."CardType" = 'L';

	if cnt > 0 then

		error := 1;
		error_message := N'Trata de grabar un borrador o de mandar a un proceso de autorización una Orden de Venta para un prospecto que NO es cliente aun';
		select :error, :error_message FROM dummy;
		return;

	end if;

end if;


--FIN: CONTROL DE PRECIOS Y TIPO DE CLIENTE AL CREAR OV


-- VKM -- INICIO --
stop := N'N';					-- VKM
VKM_SND_LOG := N'Y';			-- VKM
ObjectKey := :list_of_cols_val_tab_del;				-- VKM
ObjectType := :object_type;		-- VKM
BaseEntry_Rel := 0;				-- VKM
BaseType_Rel := N'';			-- VKM
VKMCnnCode_Rel := N'';			-- VKM
VKM_SND_LOG_Rel := N'Y';		-- VKM
cntRel := 0;					-- VKM
list_of_VKMCnnCode_Rel := N'';	-- VKM
list_of_VKM_SND_LOG_Rel := N'';	-- VKM
Modo := :transaction_type;		-- VKM

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
## Version 20 ##
## Changelog ## Mas Info PV-1506 ##
## UPD # 05/02/2019 # Se ajusta a 255 el long de la variable ObjectKey.
## UPD # 19/11/2019 # Se corrige configuracion de la clase de expedicion // "TrnspCode" = :VKM_Expedicion --> "TrnspCode" <> :VKM_Expedicion.
## UPD # 21/01/2019 # Se agrega la captura de articulos combo.
## UPD # 14/02/2020 # Se Cambia el control de ordenes de compra // Ya no presta atencion al flag de "Envio a VKM" (Pasan siempre).
## UPD # 19/02/2020 # Para mantener el funcionamiento de otras versiones solo las SALIDAS verifican el campo de "Envio a VKM".
## UPD # 19/02/2020 # Se Agrega el bloqueo en Notas de credito de Clientes // Si tiene Factura de reserva vinculada en estado BLQ no permite crearla.
## UPD # 03/03/2020 # Se Verifican documentos que ingresan en proceso de autorizacion. (Ordenes de compra, Sol de devolucion prov, sol de traslado, sol de devolucion clientes, factura de reserva y ordenes de venta)
## UPD # 20/03/2020 # Se hace respetar el Flag de envio a VKM en facturas de deudores.
## UPD # 20/03/2020 # Se verifica si una Factura de deudores opera con TMS y no WMS. Ademas si se genera relacionada a una entrega.
## UPD # 25/03/2020 # EB # Las Nota de Credito estan pasando siempre que no sean basadas en Factura.
## v14 # 09/04/2020 # EB # Las Nota de Credito basadas en Factura, enviaba las Factura a las VKMCNN siempre. Ahora solo si imputa a una Factura que anteriormente era "enviable"
## 						   Las factura se controlaban dos veces si el deposito opera con WMS cuando es de Reserva.
## v15 # 20/04/2020 # EB # Cambio de lugar en donde recupera parametros de WMS, para que solo lo haga si son documentos que nos interesan a VKM.
## 						   Los draft de Autorizacion solo nos importan las altas porque para ejecutar las modificaciones ya tiene que haber pasado por el alta.
## v16 # 23/04/2020 # EB # El Draft de Autorizacion cancela el documento si el documento original ya habia pasado a la VKMCNN.
## 						   Cuando se modifica un documento ya no me importa si el deposito es de VKM, debo verificar si no esta bloqueado por las dudas.
## 						   Los documentos relacionados pueden ser muchos.
## v17 # 29/04/2020 # EB # Se Agrega el bloqueo en Notas de credito de Proveedores // Si tiene Factura de reserva vinculada en estado BLQ no permite crearla.
## v18 # 13/07/2020 # EB # Se amplio el tipo de dato de las variables VKMCnnCode y VKMCnnCode_Rel de 50 a 100 y ObjectType de 20 a 30.
## v19 # 23/07/2020 # AC # Se quito la restricción de eliminar articulos sin movimientos.
## v20 # 11/01/2021 # EB # Control del Kits en Salidas. Control de modificacion de Kits
## v21 # 15/07/2021 # EB # Error, permite cerrar Documentos aunque este pendiente en el Asignador.

SACAR signo apostrofe y signos de pregunta ya que no compila en SAP el TN
*/ 
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- VKM//WMS//TMS
-- BusinessPartners = 2
-- Items = 4
-- Product Tree	= 66
-- Invoices = 13
-- A/R Credit Memo = 14
-- DeliveryNotes = 15
-- Returns = 16		UPD: 28/10
-- Orders = 17
-- PurchaseInvoices = 18
-- A/P Credit Memo	= 19
-- GoodsReceiptPO = 20
-- PurchaseReturns = 21		UPD: 28/10
-- PurchaseOrders = 22
-- Warehouses = 64
-- InventoryTransfer = 67
-- Drafts Auth = 122
-- GoodsReturnRequest = 234000032
-- Returns Request = 234000031
-- InventoryTransferRequest = 1250000001


-- Solo si son Objetos de importancia para VKM
If :error = 0 AND (:object_type = '2' OR :object_type = '4' or :object_type = '13' or :object_type = '14' OR :object_Type = '15' OR :object_type = '16' OR :object_type = '17' 
					OR :object_type = '18' OR :object_type = '19' OR :object_type = '20' OR :object_type = '21' OR :object_type = '22' OR :object_type = '64' OR :object_type = '66' 
					OR :object_type = '67' OR :object_type = '122' OR :object_type = '234000031' OR :object_type = '234000032' OR :object_type = '1250000001') Then
					
	-- Recupero parametros // Start
	SELECT COUNT(*) INTO cnt FROM "@VKMPARM" WHERE "U_VKM_ParamId" = 'Articulos';
	If cnt > 0 Then
		SELECT "U_VKM_ParmVal" INTO VKM_NOV_ART FROM "@VKMPARM" WHERE "U_VKM_ParamId" = 'Articulos';
	End If;	

	SELECT COUNT(*) INTO cnt FROM "@VKMPARM" WHERE "U_VKM_ParamId" = 'Entidades';
	If cnt > 0 Then
		SELECT "U_VKM_ParmVal" INTO VKM_NOV_ENT FROM "@VKMPARM" WHERE "U_VKM_ParamId" = 'Entidades';
	End If;	

	SELECT COUNT(*) INTO cnt FROM "@VKMPARM" WHERE "U_VKM_ParamId" = 'Expedicion';
	If cnt > 0 Then
		SELECT "U_VKM_ParmVal" INTO VKM_Expedicion FROM "@VKMPARM" WHERE "U_VKM_ParamId" = 'Expedicion';
	End If;	

	SELECT COUNT(*) INTO cnt FROM "@VKMPARM" WHERE "U_VKM_ParamId" = 'Envia Entrega';
	If cnt > 0 Then
		SELECT "U_VKM_ParmVal" INTO VKM_Envia_Entrega FROM "@VKMPARM" WHERE "U_VKM_ParamId" = 'Envia Entrega';
	End If;	
	-- Recupero parametros // End
		
	-- BusinessPartners y no es un delete y Ademas generen novedad 
	IF :object_type = '2' AND :Modo <> 'D' AND :VKM_NOV_ENT = 'Y' Then	
		-- NO es Prospecto
		SELECT count(*) into cnt FROM "OCRD" WHERE "CardCode" = :list_of_cols_val_tab_del and "CardType" <> 'L';
		if :cnt = 0 then
			stop := 'Y';
		end if;
	-- Items  no es un delete y Ademas generen novedad 
	ELSEIF :object_type = '4' AND :Modo <> 'D' AND :VKM_NOV_ART = 'Y' Then
		-- Inventariables o Combo de Venta 
		SELECT count(*) INTO cnt FROM "OITM" WHERE "ItemCode" = :list_of_cols_val_tab_del AND "InvntItem" = 'Y';
		if :cnt = 0 Then
			SELECT count(*) INTO cnt FROM "OITM" WHERE "ItemCode" = :list_of_cols_val_tab_del AND "TreeType" = 'S' and (SELECT count(*) FROM "ITT1" inner join "OITM" ON "ItemCode" = "Code" WHERE "Father" = :list_of_cols_val_tab_del and "InvntItem" = 'Y') > 0 ;
			if :cnt = 0 Then
				stop := 'Y';
			End If;
		End If;
	-- Product Tree y Ademas generen novedad 
	ELSEIF :object_type = '66' AND :VKM_NOV_ART = 'Y' Then	
		-- Hijos Inventariables 
		SELECT count(*) INTO cnt FROM "ITT1" inner join "OITM" ON "ItemCode" = "Code" WHERE "Father" = :list_of_cols_val_tab_del and "InvntItem" = 'Y';
		If :cnt = 0 Then
			stop := 'Y';
		Else
			ObjectType := '4';
			Modo := 'U';
		End If;
	-- Invoices
	ELSEIF :object_type = '13' then
		-- Es factura de reserva 
		SELECT count(*) into cnt FROM "OINV" WHERE "DocEntry" = :list_of_cols_val_tab_del and "UpdInvnt" <> 'I' ; 
		if :cnt = 0 then 
			-- NO es factura de reserva
			-- Tiene alguna linea con deposito Solo TMS
			SELECT COUNT(*) INTO cnt FROM "INV1" INNER JOIN "OWHS" ON "INV1"."WhsCode" = "OWHS"."WhsCode" WHERE "DocEntry" = :list_of_cols_val_tab_del AND "U_VKM_TMS" = 'Y' AND "U_VKM_WMS" = 'N';
			If :cnt = 0 Then
				if :Modo = 'A' Then
					stop := 'Y';
				Else
					Modo := 'C';
					VKM_SND_LOG := 'N';
				end if;
			Else
				-- Envia o Busca a domicilio o tiene parametro de de enviar todo
				SELECT COUNT(*) INTO cnt FROM "OINV" WHERE "DocEntry" = :list_of_cols_val_tab_del AND ("TrnspCode" <> :VKM_Expedicion OR :VKM_Envia_Entrega = 'Y');
				If :cnt = 0 Then
					if :Modo = 'A' Then
						stop := 'Y';
					Else
						Modo := 'C';
						VKM_SND_LOG := 'N';
					end if ;
				Else
					VKM_ObjDestino := 'TMS';
					-- Recupera envia Documento a VKM porque pudo haber cambiado
					SELECT "U_VKM_SND_LOG" into VKM_SND_LOG FROM "OINV" WHERE "DocEntry" = :list_of_cols_val_tab_del;
					-- Busco con cuantas Entregas esta relacionado el documento original 
					SELECT count(*) into cntRel FROM (SELECT distinct "BaseEntry" , "BaseType" FROM "INV1" WHERE "DocEntry" = :list_of_cols_val_tab_del and "BaseType" = '15') ; 
					if :cntRel > 0 then
						BaseType_Rel := '15';
						i := 0;
						WHILE :i < :cntRel DO
							--Busco la Entrega relacionada 
							SELECT distinct COALESCE ("BaseEntry","BaseEntry",0) into BaseEntry_Rel FROM "INV1" WHERE "DocEntry" = :list_of_cols_val_tab_del limit 1 offset :i;
							-- Recupera envia Documento a VKM para saber si el documento relacionado fue a VKM
							SELECT COUNT(*) INTO cnt FROM "DLN1" INNER JOIN "OWHS" ON "DLN1"."WhsCode" = "OWHS"."WhsCode" WHERE "DocEntry" = :BaseEntry_Rel AND "U_VKM_TMS" = 'Y' AND "U_VKM_WMS" = 'N'; 
							if :cnt > 0 then
								SELECT COUNT(*) INTO cnt FROM "ODLN" WHERE "DocEntry" = :BaseEntry_Rel AND ("TrnspCode" <> :VKM_Expedicion OR :VKM_Envia_Entrega = 'Y'); 
								if :cnt > 0 then
									SELECT "U_VKM_SND_LOG" into VKM_SND_LOG_Rel FROM "OINV" WHERE "DocEntry" = :BaseEntry_Rel;
									if :VKM_SND_LOG_Rel = 'Y' then
										-- Si el relacionado fue a VKM arma codigo
										VKMCnnCode_Rel := :BaseType_Rel||LPAD(:BaseEntry_Rel,11,'0');				
										If :list_of_VKMCnnCode_Rel = '' then
											list_of_VKMCnnCode_Rel := :VKMCnnCode_Rel;
											list_of_VKM_SND_LOG_Rel := :VKM_SND_LOG_Rel;
										ELSE
											list_of_VKMCnnCode_Rel = :list_of_VKMCnnCode_Rel||';'||:VKMCnnCode_Rel;
											list_of_VKM_SND_LOG_Rel = :list_of_VKM_SND_LOG_Rel||';'||:VKM_SND_LOG_Rel;
										End if;
									End if;
								End If;	
							End If;
							i = :i + 1;
						END WHILE;
					End If;
				End If;	
			End If;
		ELSE
			-- SI es factura de reserva
			-- Tiene alguna linea con depositos WMS 
			SELECT count(*) into cnt from "INV1" inner join "OWHS" ON "INV1"."WhsCode" = "OWHS"."WhsCode" where "DocEntry" = :list_of_cols_val_tab_del and "U_VKM_WMS" = 'Y';
			if :cnt = 0 then
				-- Tiene alguna linea con depositos TMS 
				SELECT COUNT(*) INTO cnt FROM "INV1" INNER JOIN "OWHS" ON "INV1"."WhsCode" = "OWHS"."WhsCode" WHERE "DocEntry" = :list_of_cols_val_tab_del AND "U_VKM_TMS" = 'Y';	
				if :cnt = 0 then
					if :Modo = 'A' Then
						stop := 'Y';
					Else
						Modo := 'C';
						VKM_SND_LOG := 'N';
					end if ;
				Else
					VKM_ObjDestino := 'TMS';
					-- Recupera envia Documento a VKM porque pudo haber cambiado
					SELECT "U_VKM_SND_LOG" into VKM_SND_LOG FROM "OINV" WHERE "DocEntry" = :list_of_cols_val_tab_del;
				End IF;
			ELSE
				VKM_ObjDestino := 'WMS'; 		-- Si tiene linea con WMS predomina WMS
				-- Recupera envia Documento a VKM porque pudo haber cambiado
				SELECT "U_VKM_SND_LOG" into VKM_SND_LOG FROM "OINV" WHERE "DocEntry" = :list_of_cols_val_tab_del;
				-- Es factura de cancelacion
				SELECT count(*) into cnt FROM "OINV" WHERE "DocEntry" = :list_of_cols_val_tab_del and "CANCELED" = 'C';  
				if :cnt > 0 then
					-- Busco Documento Cancelado
					SELECT TOP 1 COALESCE ("BaseEntry","BaseEntry",0) , COALESCE ("BaseType","BaseType",0) into ObjectKey, ObjectType  FROM "INV1" WHERE "DocEntry" = :list_of_cols_val_tab_del;
					Modo := 'C';
				end if;
				
				-- Busco con cuantas Ordenes de Venta esta relacionado el documento original o el Cancelado
				SELECT count(*) into cntRel FROM (SELECT distinct "BaseEntry" , "BaseType" FROM "INV1" WHERE "DocEntry" = :ObjectKey and "BaseType" = '17') ; 
				if :cntRel > 0 then
					BaseType_Rel := '17';
					i := 0;
					WHILE :i < :cntRel DO
						--Busco la Orden de Venta relacionada 
						SELECT distinct COALESCE ("BaseEntry","BaseEntry",0) into BaseEntry_Rel FROM "INV1" WHERE "DocEntry" = :ObjectKey limit 1 offset :i;
						-- Recupera si el documento relacionado fue a VKM
						-- Recupera envia Documento a VKM para saber si el documento relacionado fue a VKM
						SELECT count(*) into cnt from "RDR1" inner join "OWHS" on "RDR1"."WhsCode" = "OWHS"."WhsCode" where "DocEntry" = :BaseEntry_Rel and "U_VKM_WMS" = 'Y';	
						if :cnt = 0 then
							SELECT COUNT(*) INTO cnt FROM "RDR1" INNER JOIN "OWHS" ON "RDR1"."WhsCode" = "OWHS"."WhsCode" WHERE "DocEntry" = :BaseEntry_Rel AND "U_VKM_TMS" = 'Y';	
							if :cnt = 0 then
								VKM_SND_LOG_Rel := 'N';
							else
								SELECT COUNT(*) INTO cnt FROM "ORDR" WHERE "DocEntry" = :BaseEntry_Rel AND ("TrnspCode" <> :VKM_Expedicion OR :VKM_Envia_Entrega = 'Y');
								if :cnt = 0 then
									VKM_SND_LOG_Rel := 'N';
								else
									SELECT "U_VKM_SND_LOG" INTO VKM_SND_LOG_Rel FROM "ORDR" WHERE "DocEntry" = :BaseEntry_Rel;
								End IF;
							End IF;
						ELSE
							SELECT "U_VKM_SND_LOG" into VKM_SND_LOG_Rel FROM "ORDR" WHERE "DocEntry" = :BaseEntry_Rel;
						End If;
						if :VKM_SND_LOG_Rel = 'Y' then
							-- Si el relacionado fue a VKM arma codigo
							VKMCnnCode_Rel := :BaseType_Rel||LPAD(:BaseEntry_Rel,11,'0');				
							If :list_of_VKMCnnCode_Rel = '' then
								list_of_VKMCnnCode_Rel := :VKMCnnCode_Rel;
								list_of_VKM_SND_LOG_Rel := :VKM_SND_LOG_Rel;
							ELSE
								list_of_VKMCnnCode_Rel := :list_of_VKMCnnCode_Rel||';'||:VKMCnnCode_Rel;
								list_of_VKM_SND_LOG_Rel := :list_of_VKM_SND_LOG_Rel||';'||:VKM_SND_LOG_Rel;
							End if;
						End if;
						i = :i + 1;
					END WHILE;
				End If;
			End If;
		End if;
	-- A/R Credit Memo
	ELSEIF :object_type = '14' Then
		-- Busco con cuantas Facturas esta relacionado el documento original 
		SELECT count(*) into cntRel FROM (SELECT distinct "BaseEntry" , "BaseType" FROM "RIN1" WHERE "DocEntry" = :list_of_cols_val_tab_del and "BaseType" = '13') ; 
		if :cntRel > 0 then
			VKM_SND_LOG := 'N'; -- Las NC no se guardan nunca en VKMCNN.
			BaseType_Rel := '13';
			i := 0;
			WHILE :i < :cntRel DO
				--Busco la Entrega relacionada 
				SELECT distinct COALESCE ("BaseEntry","BaseEntry",0) into BaseEntry_Rel FROM "RIN1" WHERE "DocEntry" = :list_of_cols_val_tab_del limit 1 offset :i;
				-- Veo si la Factura había pasado antes
				-- Es factura de reserva 
				SELECT count(*) into cnt FROM "OINV" WHERE "DocEntry" = :BaseEntry_Rel and "UpdInvnt" <> 'I' ; 
				if :cnt = 0 then
					-- NO es factura de reserva
					-- Tiene alguna linea con deposito Solo TMS
					SELECT count(*) into cnt FROM "INV1" INNER JOIN "OWHS" ON "INV1"."WhsCode" = "OWHS"."WhsCode" WHERE "DocEntry" = :BaseEntry_Rel AND "U_VKM_TMS" = 'Y' AND "U_VKM_WMS" = 'N'; 
					if :cnt = 0 then
						VKM_SND_LOG_Rel := 'N'; -- Las FC no habia ido Nunca en VKMCNN.
					ELSE
						-- Envia o Busca a domicilio o tiene parametro de de enviar todo
						SELECT count(*) into cnt FROM "OINV" WHERE "DocEntry" = :BaseEntry_Rel AND ("TrnspCode" <> :VKM_Expedicion OR :VKM_Envia_Entrega = 'Y'); 
						if :cnt = 0 then
							VKM_SND_LOG_Rel := 'N'; -- Las FC no habia ido Nunca en VKMCNN.
						ELSE
							VKM_ObjDestino := 'TMS';
							-- Recupera envia Documento a VKM para saber si el documento relacionado fue a VKM
							SELECT "U_VKM_SND_LOG" into VKM_SND_LOG_Rel FROM "ORDR" WHERE "DocEntry" = :BaseEntry_Rel ;	
						End if;
					End if;
				ELSE
					-- SI es factura de reserva
					-- Tiene alguna linea con depositos WMS 
					SELECT count(*) into cnt from "INV1" inner join "OWHS" on "INV1"."WhsCode" = "OWHS"."WhsCode" where "DocEntry" = :BaseEntry_Rel and "U_VKM_WMS" = 'Y';	
					if :cnt = 0 then
						-- Tiene alguna linea con depositos TMS 
						SELECT count(*) into cnt FROM "INV1" INNER JOIN "OWHS" ON "INV1"."WhsCode" = "OWHS"."WhsCode" WHERE "DocEntry" = :BaseEntry_Rel AND "U_VKM_TMS" = 'Y'; 
						if :cnt = 0 then
							VKM_SND_LOG_Rel := 'N'; -- Las FC no habia ido Nunca en VKMCNN.
						ELSE
							VKM_ObjDestino := 'TMS';
							-- Recupera envia Documento a VKM para saber si el documento relacionado fue a VKM
							SELECT "U_VKM_SND_LOG" into VKM_SND_LOG_Rel FROM "OINV" WHERE "DocEntry" = :BaseEntry_Rel ;
						End if;
					ELSE
						VKM_ObjDestino := 'WMS';
						-- Recupera envia Documento a VKM para saber si el documento relacionado fue a VKM
						SELECT "U_VKM_SND_LOG" into VKM_SND_LOG_Rel FROM "OINV" WHERE "DocEntry" = :BaseEntry_Rel ;
					End if;
				End if;
				if :VKM_SND_LOG_Rel = 'Y' then
					-- Si el relacionado fue a VKM arma codigo
					VKMCnnCode_Rel := :BaseType_Rel||LPAD(:BaseEntry_Rel,11,'0');				
					If :list_of_VKMCnnCode_Rel = '' then
						list_of_VKMCnnCode_Rel := :VKMCnnCode_Rel;
						list_of_VKM_SND_LOG_Rel := :VKM_SND_LOG_Rel;
					ELSE
						list_of_VKMCnnCode_Rel := :list_of_VKMCnnCode_Rel||';'||:VKMCnnCode_Rel;
						list_of_VKM_SND_LOG_Rel := :list_of_VKM_SND_LOG_Rel||';'||:VKM_SND_LOG_Rel;
					End if;	
				End if;
				i = :i + 1;
			END WHILE;
		Else
			stop := 'Y';
		End if;
	-- DeliveryNotes
	ELSEIF :object_Type = '15' Then 
		-- Tiene alguna linea con deposito Solo TMS
		SELECT COUNT(*) INTO cnt FROM "DLN1" INNER JOIN "OWHS" ON "DLN1"."WhsCode" = "OWHS"."WhsCode" WHERE "DocEntry" = :list_of_cols_val_tab_del AND "U_VKM_TMS" = 'Y' AND "U_VKM_WMS" = 'N'; 
		If :cnt = 0 Then
			if :Modo = 'A' Then
				stop := 'Y';
			Else
				Modo := 'C';
				VKM_SND_LOG := 'N';
			end if ;
		Else
			-- Envia o Busca a domicilio o tiene parametro de de enviar todo
			SELECT COUNT(*) INTO cnt FROM "ODLN" WHERE "DocEntry" = :list_of_cols_val_tab_del AND ("TrnspCode" <> :VKM_Expedicion OR :VKM_Envia_Entrega = 'Y'); 
			If :cnt = 0 Then
				if :Modo = 'A' Then
					stop := 'Y';
				Else
					Modo := 'C';
					VKM_SND_LOG := 'N';
				end if ;
			Else
				VKM_ObjDestino := 'TMS';
				-- Recupera envia Documento a VKM porque pudo haber cambiado
				SELECT "U_VKM_SND_LOG" into VKM_SND_LOG FROM "ODLN" WHERE "DocEntry" = :list_of_cols_val_tab_del;
			End If;	
		End If;
	-- Returns
	ELSEIF :object_type = '16' Then 
		-- Tiene alguna linea con deposito Solo TMS
		SELECT COUNT(*) INTO cnt FROM "RDN1" INNER JOIN "OWHS" ON "RDN1"."WhsCode" = "OWHS"."WhsCode" WHERE "DocEntry" = :list_of_cols_val_tab_del AND "U_VKM_TMS" = 'Y' AND "U_VKM_WMS" = 'N'; 
		If :cnt = 0 Then
			if :Modo = 'A' Then
				stop := 'Y';
			Else
				Modo := 'C';
				VKM_SND_LOG := 'N';
			end if ;
		Else
			-- Envia o Busca a domicilio o tiene parametro de de enviar todo
			SELECT COUNT(*) INTO cnt FROM "ORDN" WHERE "DocEntry" = :list_of_cols_val_tab_del AND ("TrnspCode" <> :VKM_Expedicion OR :VKM_Envia_Entrega = 'Y'); 
			If :cnt = 0 Then
				if :Modo = 'A' Then
					stop := 'Y';
				Else
					Modo := 'C';
					VKM_SND_LOG := 'N';
				end if ;
			Else
				VKM_ObjDestino := 'TMS';
			End If;	
		End If;
	-- Orders
	ELSEIF :object_type = '17' then	
		-- Tiene alguna linea con depositos WMS 
		SELECT count(*) into cnt from "RDR1" inner join "OWHS" on "RDR1"."WhsCode" = "OWHS"."WhsCode" where "DocEntry" = :list_of_cols_val_tab_del and "U_VKM_WMS" = 'Y';	--Tiene alguna linea con depositos WMS
		if :cnt = 0 then
			-- Tiene alguna linea con deposito TMS
			SELECT COUNT(*) INTO cnt FROM "RDR1" INNER JOIN "OWHS" ON "RDR1"."WhsCode" = "OWHS"."WhsCode" WHERE "DocEntry" = :list_of_cols_val_tab_del AND "U_VKM_TMS" = 'Y';	--Tiene alguna linea con depositos TMS
			if :cnt = 0 then
				if :Modo = 'A' Then
					stop := 'Y';
				Else
					Modo := 'C';
					VKM_SND_LOG := 'N';
				end if ;
			Else
				-- Envia o Busca a domicilio o tiene parametro de de enviar todo
				SELECT COUNT(*) INTO cnt FROM "ORDR" WHERE "DocEntry" = :list_of_cols_val_tab_del AND ("TrnspCode" <> :VKM_Expedicion OR :VKM_Envia_Entrega = 'Y');
				If :cnt = 0 Then
					if :Modo = 'A' Then
						stop := 'Y';
					Else
						Modo := 'C';
						VKM_SND_LOG := 'N';
					end if ;
				Else
					VKM_ObjDestino := 'TMS'; 
					-- Recupera envia Documento a VKM porque pudo haber cambiado
					SELECT "U_VKM_SND_LOG" INTO VKM_SND_LOG FROM "ORDR" WHERE "DocEntry" = :list_of_cols_val_tab_del;
				End IF;
			End IF;
		ELSE
			VKM_ObjDestino := 'WMS'; 
			-- Recupera envia Documento a VKM porque pudo haber cambiado
			SELECT "U_VKM_SND_LOG" into VKM_SND_LOG FROM "ORDR" WHERE "DocEntry" = :list_of_cols_val_tab_del;
		End If;
	-- PurchaseInvoices
	ELSEIF :object_type = '18' then	
		-- Es factura de reserva 
		SELECT count(*) into cnt FROM "OPCH" WHERE "DocEntry" = :list_of_cols_val_tab_del and "UpdInvnt" <> 'I' ; 
		if :cnt = 0 then
			-- NO es factura de reserva
			-- Tiene alguna linea con deposito Solo TMS
			SELECT COUNT(*) INTO cnt FROM "PCH1" INNER JOIN "OWHS" ON "PCH1"."WhsCode" = "OWHS"."WhsCode" WHERE "DocEntry" = :list_of_cols_val_tab_del AND "U_VKM_TMS" = 'Y' AND "U_VKM_WMS" = 'N'; 
			If :cnt = 0 Then
				if :Modo = 'A' Then
					stop := 'Y';
				Else
					Modo := 'C';
					VKM_SND_LOG := 'N';
				end if ;
			Else
				-- Envia o Busca a domicilio o tiene parametro de de enviar todo
				SELECT COUNT(*) INTO cnt FROM "OPCH" WHERE "DocEntry" = :list_of_cols_val_tab_del AND ("TrnspCode" <> :VKM_Expedicion OR :VKM_Envia_Entrega = 'Y'); 
				If :cnt = 0 Then
					if :Modo = 'A' Then
						stop := 'Y';
					Else
						Modo := 'C';
						VKM_SND_LOG := 'N';
					end if ;
				Else
					VKM_ObjDestino := 'TMS';
				End If;
			End If;
		ELSE
			-- SI es factura de reserva
			-- Tiene alguna linea con depositos WMS 
			SELECT count(*) into cnt from "PCH1" inner join "OWHS" ON "PCH1"."WhsCode" = "OWHS"."WhsCode" where "DocEntry" = :list_of_cols_val_tab_del and "U_VKM_WMS" = 'Y';
			if :cnt = 0 then
				-- Tiene alguna linea con depositos TMS 
				SELECT COUNT(*) INTO cnt FROM "PCH1" INNER JOIN "OWHS" ON "PCH1"."WhsCode" = "OWHS"."WhsCode" WHERE "DocEntry" = :list_of_cols_val_tab_del AND "U_VKM_TMS" = 'Y';
				if :cnt = 0 then
					if :Modo = 'A' Then
						stop := 'Y';
					Else
						Modo := 'C';
						VKM_SND_LOG := 'N';
					end if ;
				Else
					VKM_ObjDestino := 'TMS';
				End IF;
			ELSE
				VKM_ObjDestino := 'WMS';
				-- Es factura de cancelacion
				SELECT count(*) into cnt FROM "OPCH" WHERE "DocEntry" = :list_of_cols_val_tab_del and "CANCELED" = 'C';  
				if :cnt > 0 then
					-- Busco Documento Cancelado
					SELECT TOP 1 COALESCE ("BaseEntry","BaseEntry",0) , COALESCE ("BaseType","BaseType",0) into ObjectKey, ObjectType  FROM "PCH1" WHERE "DocEntry" = :list_of_cols_val_tab_del;
					Modo := 'C';
				End If;
				-- Busco con cuantas Ordenes de Compra esta relacionado el documento original o el Cancelado
				SELECT count(*) into cntRel FROM (SELECT distinct "BaseEntry" , "BaseType" FROM "PCH1" WHERE "DocEntry" = :ObjectKey and "BaseType" = '22') ; 
				if :cntRel > 0 then
					BaseType_Rel := '22';
					i := 0;
					WHILE :i < :cntRel DO
						VKM_SND_LOG_Rel := 'Y';
						--Busco la Orden de Compra relacionada 
						SELECT distinct COALESCE ("BaseEntry","BaseEntry",0) into BaseEntry_Rel FROM "PCH1" WHERE "DocEntry" = :ObjectKey limit 1 offset :i;
						-- Recupera si el documento relacionado fue a VKM
						SELECT COUNT(*) INTO cnt FROM "POR1" INNER JOIN "OWHS" ON "POR1"."WhsCode" = "OWHS"."WhsCode" WHERE "DocEntry" = :BaseEntry_Rel AND "U_VKM_WMS" = 'Y'; 
						If :cnt = 0 Then
							SELECT COUNT(*) INTO cnt FROM "POR1" INNER JOIN "OWHS" ON "POR1"."WhsCode" = "OWHS"."WhsCode" WHERE "DocEntry" = :BaseEntry_Rel AND "U_VKM_TMS" = 'Y'; 
							If :cnt = 0 Then 
								VKM_SND_LOG_Rel := 'N';
							Else
								SELECT COUNT(*) INTO cnt FROM "OPOR" WHERE "DocEntry" = :BaseEntry_Rel AND ("TrnspCode" <> :VKM_Expedicion OR :VKM_Envia_Entrega = 'Y');
								if :cnt = 0 then
									VKM_SND_LOG_Rel := 'N';
								End If;
							End If;
						End If;		
						if :VKM_SND_LOG_Rel = 'Y' then
							-- Si el relacionado fue a VKM arma codigo
							VKMCnnCode_Rel := :BaseType_Rel||LPAD(:BaseEntry_Rel,11,'0');				
							If :list_of_VKMCnnCode_Rel = '' then
								list_of_VKMCnnCode_Rel := :VKMCnnCode_Rel;
								list_of_VKM_SND_LOG_Rel := :VKM_SND_LOG_Rel;
							ELSE
								list_of_VKMCnnCode_Rel = :list_of_VKMCnnCode_Rel||';'||:VKMCnnCode_Rel;
								list_of_VKM_SND_LOG_Rel = :list_of_VKM_SND_LOG_Rel||';'||:VKM_SND_LOG_Rel;
							End if;
						End if;
						i = :i + 1;
					END WHILE;
				End If;
			End If;
		End If;
	-- A/P Credit Memo	
	ELSEIF :object_type = '19' Then
		-- Busco con cuantas Facturas esta relacionado el documento original 
		SELECT count(*) into cntRel FROM (SELECT distinct "BaseEntry" , "BaseType" FROM "RPC1" WHERE "DocEntry" = :list_of_cols_val_tab_del and "BaseType" = '18') ; 
		if :cntRel > 0 then
			VKM_SND_LOG := 'N'; -- Las NC no se guardan nunca en VKMCNN.
			BaseType_Rel := '18';
			i := 0;
			WHILE :i < :cntRel DO
				--Busco la Entrega relacionada 
				SELECT distinct COALESCE ("BaseEntry","BaseEntry",0) into BaseEntry_Rel FROM "RPC1" WHERE "DocEntry" = :list_of_cols_val_tab_del limit 1 offset :i;
				-- Veo si la Factura había pasado antes
				-- Es factura de reserva 
				SELECT count(*) into cnt FROM "OPCH" WHERE "DocEntry" = :BaseEntry_Rel and "UpdInvnt" <> 'I' ; 
				if :cnt = 0 then
					-- NO es factura de reserva
					-- Tiene alguna linea con deposito Solo TMS
					SELECT COUNT(*) INTO cnt FROM "PCH1" INNER JOIN "OWHS" ON "PCH1"."WhsCode" = "OWHS"."WhsCode" WHERE "DocEntry" = :BaseEntry_Rel AND "U_VKM_TMS" = 'Y' AND "U_VKM_WMS" = 'N'; 
					If :cnt = 0 Then
						VKM_SND_LOG_Rel := 'N'; -- Las FC no habia ido Nunca en VKMCNN.
					ELSE
						-- Envia o Busca a domicilio o tiene parametro de de enviar todo
						SELECT COUNT(*) INTO cnt FROM "OPCH" WHERE "DocEntry" = :BaseEntry_Rel AND ("TrnspCode" <> :VKM_Expedicion OR :VKM_Envia_Entrega = 'Y'); 
						If :cnt = 0 Then
							VKM_SND_LOG_Rel := 'N'; -- Las FC no habia ido Nunca en VKMCNN.
						Else
							VKM_SND_LOG_Rel := 'Y';
							VKM_ObjDestino := 'TMS';
						End If;
					End if;
				ELSE
					-- SI es factura de reserva
					-- Tiene alguna linea con depositos WMS 
					SELECT count(*) into cnt from "PCH1" inner join "OWHS" ON "PCH1"."WhsCode" = "OWHS"."WhsCode" where "DocEntry" = :BaseEntry_Rel and "U_VKM_WMS" = 'Y';
					if :cnt = 0 then
						-- Tiene alguna linea con depositos TMS 
						SELECT COUNT(*) INTO cnt FROM "PCH1" INNER JOIN "OWHS" ON "PCH1"."WhsCode" = "OWHS"."WhsCode" WHERE "DocEntry" = :BaseEntry_Rel AND "U_VKM_TMS" = 'Y';
						if :cnt = 0 then
							VKM_SND_LOG_Rel := 'N'; -- Las FC no habia ido Nunca en VKMCNN.
						Else
							VKM_SND_LOG_Rel := 'Y';
							VKM_ObjDestino := 'TMS';
						End IF;
					ELSE
						VKM_SND_LOG_Rel := 'Y';
						VKM_ObjDestino := 'WMS';
					End if;
				End if;
				if :VKM_SND_LOG_Rel = 'Y' then
					-- Si el relacionado fue a VKM arma codigo
					VKMCnnCode_Rel := :BaseType_Rel||LPAD(:BaseEntry_Rel,11,'0');				
					If :list_of_VKMCnnCode_Rel = '' then
						list_of_VKMCnnCode_Rel := :VKMCnnCode_Rel;
						list_of_VKM_SND_LOG_Rel := :VKM_SND_LOG_Rel;
					ELSE
						list_of_VKMCnnCode_Rel := :list_of_VKMCnnCode_Rel||';'||:VKMCnnCode_Rel;
						list_of_VKM_SND_LOG_Rel := :list_of_VKM_SND_LOG_Rel||';'||:VKM_SND_LOG_Rel;
					End if;	
				End if;
				i = :i + 1;
			END WHILE;
		Else
			stop := 'Y';
		End if;
	-- GoodsReceiptPO
	ELSEIF :object_type = '20' Then 
		-- Tiene alguna linea con deposito Solo TMS
		SELECT COUNT(*) INTO cnt FROM "PDN1" INNER JOIN "OWHS" ON "PDN1"."WhsCode" = "OWHS"."WhsCode" WHERE "DocEntry" = :list_of_cols_val_tab_del AND "U_VKM_TMS" = 'Y' AND "U_VKM_WMS" = 'N'; 
		If :cnt = 0 Then
			if :Modo = 'A' Then
				stop := 'Y';
			Else
				Modo := 'C';
				VKM_SND_LOG := 'N';
			end if ;
		Else
			-- Envia o Busca a domicilio o tiene parametro de de enviar todo
			SELECT COUNT(*) INTO cnt FROM "OPDN" WHERE "DocEntry" = :list_of_cols_val_tab_del AND ("TrnspCode" <> :VKM_Expedicion OR :VKM_Envia_Entrega = 'Y'); 
			If :cnt = 0 Then
				if :Modo = 'A' Then
					stop := 'Y';
				Else
					Modo := 'C';
					VKM_SND_LOG := 'N';
				end if ;
			Else
				VKM_ObjDestino := 'TMS';
			End If;
		End If;
	-- PurchaseReturns
	ELSEIF :object_type = '21' Then 
		-- Tiene alguna linea con deposito Solo TMS
		SELECT COUNT(*) INTO cnt FROM "RPD1" INNER JOIN "OWHS" ON "RPD1"."WhsCode" = "OWHS"."WhsCode" WHERE "DocEntry" = :list_of_cols_val_tab_del AND "U_VKM_TMS" = 'Y' AND "U_VKM_WMS" = 'N'; 
		If :cnt = 0 Then
			if :Modo = 'A' Then
				stop := 'Y';
			Else
				Modo := 'C';
				VKM_SND_LOG := 'N';
			end if ;
		Else
			-- Envia o Busca a domicilio o tiene parametro de de enviar todo
			SELECT COUNT(*) INTO cnt FROM "ORPD" WHERE "DocEntry" = :list_of_cols_val_tab_del AND ("TrnspCode" <> :VKM_Expedicion OR :VKM_Envia_Entrega = 'Y'); 
			If :cnt = 0 Then
				if :Modo = 'A' Then
					stop := 'Y';
				Else
					Modo := 'C';
					VKM_SND_LOG := 'N';
				end if ;
			Else
				VKM_ObjDestino := 'TMS';
				-- Recupera envia Documento a VKM porque pudo haber cambiado
				SELECT "U_VKM_SND_LOG" into VKM_SND_LOG FROM "ORPD" WHERE "DocEntry" = :list_of_cols_val_tab_del;
			End If;	
		End If;
	-- PurchaseOrders
	ELSEIF :object_type = '22' then	
		-- Tiene alguna linea con depositos WMS 
		SELECT COUNT(*) INTO cnt FROM "POR1" INNER JOIN "OWHS" ON "POR1"."WhsCode" = "OWHS"."WhsCode" WHERE "DocEntry" = :list_of_cols_val_tab_del AND "U_VKM_WMS" = 'Y'; 
		If :cnt = 0 Then
			-- Tiene alguna linea con depositos TMS 
			SELECT COUNT(*) INTO cnt FROM "POR1" INNER JOIN "OWHS" ON "POR1"."WhsCode" = "OWHS"."WhsCode" WHERE "DocEntry" = :list_of_cols_val_tab_del AND "U_VKM_TMS" = 'Y'; 
			If :cnt = 0 Then 
				if :Modo = 'A' Then
					stop := 'Y';
				Else
					Modo := 'C';
					VKM_SND_LOG := 'N';
				end if ;
			Else
				-- Envia o Busca a domicilio o tiene parametro de de enviar todo
				SELECT COUNT(*) INTO cnt FROM "OPOR" WHERE "DocEntry" = :list_of_cols_val_tab_del AND ("TrnspCode" <> :VKM_Expedicion OR :VKM_Envia_Entrega = 'Y');
				If :cnt = 0 Then
					if :Modo = 'A' Then
						stop := 'Y';
					Else
						Modo := 'C';
						VKM_SND_LOG := 'N';
					end if ;
				Else
					VKM_ObjDestino := 'TMS';
				End If;
			End If;
		Else
			VKM_ObjDestino := 'WMS'; 		-- Si tiene linea con WMS predomina WMS
		End If;	
	-- InventoryTransfer
	ELSEIF :object_type = '67' Then 
		-- Es una salida y Tiene alguna linea con deposito Solo TMS
		SELECT COUNT(*) INTO cnt FROM "WTR1" INNER JOIN "OWHS" ON "WTR1"."FromWhsCod" = "OWHS"."WhsCode" WHERE "DocEntry" = :list_of_cols_val_tab_del AND "U_VKM_TMS" = 'Y' AND "U_VKM_WMS" = 'N'; 
		If :cnt = 0 Then  
			-- NO es una salida, Es entrada y Tiene alguna linea con deposito Solo TMS
			SELECT COUNT(*) INTO cnt FROM "WTR1" INNER JOIN "OWHS" ON "WTR1"."WhsCode" = "OWHS"."WhsCode" WHERE "DocEntry" = :list_of_cols_val_tab_del AND "U_VKM_TMS" = 'Y' AND "U_VKM_WMS" = 'N'; 
			If :cnt = 0 Then
				if :Modo = 'A' Then
					stop := 'Y';
				Else
					Modo := 'C';
					VKM_SND_LOG := 'N';
				end if ;
			Else
				-- SI es una Entrada
				-- Envia o Busca a domicilio o tiene parametro de de enviar todo
				SELECT COUNT(*) INTO cnt FROM "OWTR" WHERE "DocEntry" = :list_of_cols_val_tab_del AND ("TrnspCode" <> :VKM_Expedicion OR :VKM_Envia_Entrega = 'Y'); 
				If :cnt = 0 Then
					if :Modo = 'A' Then
						stop := 'Y';
					Else
						Modo := 'C';
						VKM_SND_LOG := 'N';
					end if ;
				Else
					VKM_ObjDestino := 'TMS';
				End If;
			End If;
		Else 
			-- SI es una salida
			-- Envia o Busca a domicilio o tiene parametro de de enviar todo
			SELECT COUNT(*) INTO cnt FROM "OWTR" WHERE "DocEntry" = :list_of_cols_val_tab_del AND ("TrnspCode" <> :VKM_Expedicion OR :VKM_Envia_Entrega = 'Y'); 
			If :cnt = 0 Then
				if :Modo = 'A' Then
					stop := 'Y';
				Else
					Modo := 'C';
					VKM_SND_LOG := 'N';
				end if ;
			Else
				VKM_ObjDestino := 'TMS';
				-- Recupera envia Documento a VKM porque pudo haber cambiado
				SELECT "U_VKM_SND_LOG" into VKM_SND_LOG FROM "OINV" WHERE "DocEntry" = :list_of_cols_val_tab_del;
			End If;
		End If;
	-- Drafts Auth
	ELSEIF :object_type = '122' Then 
		-- Es un Alta de Documento 
		if :Modo = 'A' Then
			-- Es un Autorizacion de UPDATE de Documento
			SELECT COUNT(*) INTO cnt FROM "OWDD" WHERE "WddCode" = :list_of_cols_val_tab_del AND "BFType" = 'U'; 
			If :cnt > 0 Then
				VKM_SND_LOG := 'N';
				Modo := 'C';	-- Genera Anulacion 
				-- Busco el documento relacionado
				SELECT TOP 1 COALESCE ("DocEntry","DocEntry",0) , COALESCE ("ObjType","ObjType",0) into BaseEntry_Rel, BaseType_Rel  FROM "OWDD" WHERE "WddCode" = :list_of_cols_val_tab_del; 
				if :BaseType_Rel = '13' Then
					-- Veo si la Factura había pasado antes
					SELECT count(*) into cnt FROM "OINV" WHERE "DocEntry" = :BaseEntry_Rel and "UpdInvnt" <> 'I' ; --Es factura de reserva 
					if :cnt = 0 then
						-- Si no es de reserva
						SELECT count(*) into cnt FROM "INV1" INNER JOIN "OWHS" ON "INV1"."WhsCode" = "OWHS"."WhsCode" WHERE "DocEntry" = :BaseEntry_Rel AND "U_VKM_TMS" = 'Y' AND "U_VKM_WMS" = 'N'; 
						if :cnt = 0 then
							VKM_SND_LOG_Rel := 'N'; -- Las FC no habia ido Nunca en VKMCNN.
						ELSE
							SELECT count(*) into cnt FROM "OINV" WHERE "DocEntry" = :BaseEntry_Rel AND ("TrnspCode" <> :VKM_Expedicion OR :VKM_Envia_Entrega = 'Y'); 
							if :cnt = 0 then
								VKM_SND_LOG_Rel := 'N'; -- Las FC no habia ido Nunca en VKMCNN.
							ELSE
								VKM_ObjDestino := 'TMS';
								SELECT "U_VKM_SND_LOG" into VKM_SND_LOG_Rel FROM "ORDR" WHERE "DocEntry" = :BaseEntry_Rel ;
							End if;
						End if;
					ELSE
						-- Es de reserva
						SELECT count(*) into cnt from "INV1" inner join "OWHS" on "INV1"."WhsCode" = "OWHS"."WhsCode" where "DocEntry" = :BaseEntry_Rel and "U_VKM_WMS" = 'Y';	
						if :cnt = 0 then
							SELECT count(*) into cnt FROM "INV1" INNER JOIN "OWHS" ON "INV1"."WhsCode" = "OWHS"."WhsCode" WHERE "DocEntry" = :BaseEntry_Rel AND "U_VKM_TMS" = 'Y'; 
							if :cnt = 0 then
								VKM_SND_LOG_Rel := 'N'; -- Las FC no habia ido Nunca en VKMCNN.
							ELSE
								VKM_ObjDestino := 'TMS';
								SELECT "U_VKM_SND_LOG" into VKM_SND_LOG_Rel FROM "OINV" WHERE "DocEntry" = :BaseEntry_Rel ;
							End if;
						ELSE
							VKM_ObjDestino := 'WMS';
							SELECT "U_VKM_SND_LOG" into VKM_SND_LOG_Rel FROM "OINV" WHERE "DocEntry" = :BaseEntry_Rel ;
						End if;
					End if;
				ELSEIF :BaseType_Rel = '17' Then
					SELECT count(*) into cnt from "RDR1" inner join "OWHS" on "RDR1"."WhsCode" = "OWHS"."WhsCode" where "DocEntry" = :BaseEntry_Rel and "U_VKM_WMS" = 'Y';	
					if :cnt = 0 then
						SELECT COUNT(*) INTO cnt FROM "RDR1" INNER JOIN "OWHS" ON "RDR1"."WhsCode" = "OWHS"."WhsCode" WHERE "DocEntry" = :BaseEntry_Rel AND "U_VKM_TMS" = 'Y';	
						if :cnt = 0 then
							VKM_SND_LOG_Rel := 'N'; -- Las OV no habia ido Nunca en VKMCNN.
						Else
							SELECT COUNT(*) INTO cnt FROM "ORDR" WHERE "DocEntry" = :BaseEntry_Rel AND ("TrnspCode" <> :VKM_Expedicion OR :VKM_Envia_Entrega = 'Y');
							If :cnt = 0 Then
								VKM_SND_LOG_Rel := 'N'; -- Las OV no habia ido Nunca en VKMCNN.
							Else
								VKM_ObjDestino := 'TMS';
								SELECT "U_VKM_SND_LOG" INTO VKM_SND_LOG_Rel FROM "ORDR" WHERE "DocEntry" = :BaseEntry_Rel;
							End IF;
						End IF;
					ELSE
						VKM_ObjDestino := 'WMS';
						SELECT "U_VKM_SND_LOG" into VKM_SND_LOG_Rel FROM "ORDR" WHERE "DocEntry" = :BaseEntry_Rel;
					End If;					
				ELSEIF :BaseType_Rel = '234000032' Then
					SELECT COUNT(*) INTO cnt FROM "PRR1" INNER JOIN "OWHS" ON "PRR1"."WhsCode" = "OWHS"."WhsCode" WHERE "DocEntry" = :BaseEntry_Rel AND "U_VKM_WMS" = 'Y'; 
					If :cnt = 0 Then
						SELECT COUNT(*) INTO cnt FROM "PRR1" INNER JOIN "OWHS" ON "PRR1"."WhsCode" = "OWHS"."WhsCode" WHERE "DocEntry" = :BaseEntry_Rel AND "U_VKM_TMS" = 'Y'; 
						if :cnt = 0 then
							VKM_SND_LOG_Rel := 'N'; -- Las El Pedido de Dev. no habia ido Nunca en VKMCNN.
						ELSE
							SELECT COUNT(*) INTO cnt FROM "OPRR" WHERE "DocEntry" = :BaseEntry_Rel AND ("TrnspCode" <> :VKM_Expedicion OR :VKM_Envia_Entrega = 'Y');
							If :cnt = 0 Then
								VKM_SND_LOG_Rel := 'N'; -- Los Ped. Dev. Prov. no habia ido Nunca en VKMCNN.
							Else
								VKM_ObjDestino := 'TMS';
								SELECT "U_VKM_SND_LOG" INTO VKM_SND_LOG_Rel FROM "OPRR" WHERE "DocEntry" = :BaseEntry_Rel;
							End If;
						End If;
					Else
						VKM_ObjDestino := 'WMS'; 		
						SELECT "U_VKM_SND_LOG" INTO VKM_SND_LOG FROM "OPRR" WHERE "DocEntry" = :list_of_cols_val_tab_del;
					End If;
				ELSEIF :BaseType_Rel = '1250000001' Then
					-- Es una salida
					SELECT COUNT(*) INTO cnt FROM "WTQ1" INNER JOIN "OWHS" ON "WTQ1"."FromWhsCod" = "OWHS"."WhsCode" WHERE "DocEntry" = :BaseEntry_Rel AND ("U_VKM_WMS" = 'Y' OR "U_VKM_TMS" = 'Y');
					If :cnt = 0 Then											 
						-- Es una entrada
						SELECT COUNT(*) INTO cnt FROM "WTQ1" INNER JOIN "OWHS" ON "WTQ1"."WhsCode" = "OWHS"."WhsCode" WHERE "DocEntry" = :BaseEntry_Rel AND ("U_VKM_WMS" = 'Y' OR "U_VKM_TMS" = 'Y');
						If :cnt = 0 Then -- No utiliza VKM
							VKM_SND_LOG_Rel := 'N';
						Else	-- Proceso Entrada
							SELECT COUNT(*) INTO cnt FROM "WTQ1" INNER JOIN "OWHS" ON "WTQ1"."WhsCode" = "OWHS"."WhsCode" WHERE "DocEntry" = :BaseEntry_Rel AND "U_VKM_WMS" = 'Y'; 
							If :cnt = 0 Then
								SELECT COUNT(*) INTO cnt FROM "WTQ1" INNER JOIN "OWHS" ON "WTQ1"."WhsCode" = "OWHS"."WhsCode" WHERE "DocEntry" = :BaseEntry_Rel AND "U_VKM_TMS" = 'Y'; 
								If :cnt = 0 Then
									VKM_SND_LOG_Rel := 'N';
								Else
									VKM_ObjDestino := 'TMS';
									SELECT COUNT(*) INTO cnt FROM "OWTQ" WHERE "DocEntry" = :BaseEntry_Rel AND ("TrnspCode" <> :VKM_Expedicion OR :VKM_Envia_Entrega = 'Y');
									If :cnt = 0 Then 
										VKM_SND_LOG_Rel := 'N';
									End If;
								End If;
							else
								VKM_SND_LOG_Rel := 'N';							
							End If;
						End If; 
					Else	-- Proceso Salida
						SELECT COUNT(*) INTO cnt FROM "WTQ1" INNER JOIN "OWHS" ON "WTQ1"."FromWhsCod" = "OWHS"."WhsCode" WHERE "DocEntry" = :BaseEntry_Rel AND "U_VKM_WMS" = 'Y'; 
						If :cnt = 0 Then
							SELECT COUNT(*) INTO cnt FROM "WTQ1" INNER JOIN "OWHS" ON "WTQ1"."FromWhsCod" = "OWHS"."WhsCode" WHERE "DocEntry" = :BaseEntry_Rel AND "U_VKM_TMS" = 'Y'; 
							If :cnt = 0 Then
								VKM_SND_LOG_Rel := 'N';
							Else
								SELECT COUNT(*) INTO cnt FROM "OWTQ" WHERE "DocEntry" = :BaseEntry_Rel AND ("TrnspCode" <> :VKM_Expedicion OR :VKM_Envia_Entrega = 'Y');
								If :cnt = 0 Then 
									VKM_SND_LOG_Rel := 'N';
								Else
									VKM_ObjDestino := 'TMS';
									SELECT "U_VKM_SND_LOG" into VKM_SND_LOG_Rel FROM "OWTQ" WHERE "DocEntry" = :BaseEntry_Rel;
								End If;
							End If;
						Else
							VKM_ObjDestino := 'WMS';
							SELECT "U_VKM_SND_LOG" into VKM_SND_LOG_Rel FROM "OWTQ" WHERE "DocEntry" = :BaseEntry_Rel;
						End If;
					End If;
				ELSEIF :BaseType_Rel = '15' Then
					SELECT COUNT(*) INTO cnt FROM "DLN1" INNER JOIN "OWHS" ON "DLN1"."WhsCode" = "OWHS"."WhsCode" WHERE "DocEntry" = :BaseEntry_Rel AND "U_VKM_TMS" = 'Y' AND "U_VKM_WMS" = 'N'; 
					If :cnt = 0 Then
						VKM_SND_LOG_Rel := 'N';
					Else
						VKM_ObjDestino := 'TMS';
						SELECT COUNT(*) INTO cnt FROM "ODLN" WHERE "DocEntry" = :BaseEntry_Rel AND ("TrnspCode" <> :VKM_Expedicion OR :VKM_Envia_Entrega = 'Y'); 
						If :cnt = 0 Then
							VKM_SND_LOG_Rel := 'N';
						End If;	
					End If;
				ELSEIF :BaseType_Rel = '21' Then
					VKM_ObjDestino := 'TMS';
					SELECT COUNT(*) INTO cnt FROM "RPD1" INNER JOIN "OWHS" ON "RPD1"."WhsCode" = "OWHS"."WhsCode" WHERE "DocEntry" = :BaseEntry_Rel AND "U_VKM_TMS" = 'Y' AND "U_VKM_WMS" = 'N'; 
					If :cnt = 0 Then
						VKM_SND_LOG_Rel := 'N';
					Else
						SELECT COUNT(*) INTO cnt FROM "ORPD" WHERE "DocEntry" = :BaseEntry_Rel AND ("TrnspCode" <> :VKM_Expedicion OR :VKM_Envia_Entrega = 'Y'); 
						If :cnt = 0 Then
							VKM_SND_LOG_Rel := 'N';
						End If;	
					End If;
				ELSEIF :BaseType_Rel = '67' Then
					VKM_ObjDestino := 'TMS';
					-- Es una salida
					SELECT COUNT(*) INTO cnt FROM "WTR1" INNER JOIN "OWHS" ON "WTR1"."FromWhsCod" = "OWHS"."WhsCode" WHERE "DocEntry" = :BaseEntry_Rel AND "U_VKM_TMS" = 'Y' AND "U_VKM_WMS" = 'N'; 
					If :cnt = 0 Then  -- Proceso entrada
						SELECT COUNT(*) INTO cnt FROM "WTR1" INNER JOIN "OWHS" ON "WTR1"."WhsCode" = "OWHS"."WhsCode" WHERE "DocEntry" = :BaseEntry_Rel AND "U_VKM_TMS" = 'Y' AND "U_VKM_WMS" = 'N'; 
						If :cnt = 0 Then
							VKM_SND_LOG_Rel := 'N';
						Else
							SELECT COUNT(*) INTO cnt FROM "OWTR" WHERE "DocEntry" = :BaseEntry_Rel AND ("TrnspCode" <> :VKM_Expedicion OR :VKM_Envia_Entrega = 'Y'); 
							If :cnt = 0 Then
								VKM_SND_LOG_Rel := 'N';
							End If;
						End If;
					Else -- Proceso salida
						SELECT COUNT(*) INTO cnt FROM "OWTR" WHERE "DocEntry" = :BaseEntry_Rel AND ("TrnspCode" <> :VKM_Expedicion OR :VKM_Envia_Entrega = 'Y'); 
						If :cnt = 0 Then
							VKM_SND_LOG_Rel := 'N';
						End If;
					End If;
				ELSEIF :BaseType_Rel = '18' Then
					--Es factura de reserva 
					SELECT count(*) into cnt FROM "OPCH" WHERE "DocEntry" = :BaseEntry_Rel and "UpdInvnt" <> 'I' ; 	
					if :cnt = 0 then
						-- Si no es de reserva
						SELECT COUNT(*) INTO cnt FROM "PCH1" INNER JOIN "OWHS" ON "PCH1"."WhsCode" = "OWHS"."WhsCode" WHERE "DocEntry" = :BaseEntry_Rel AND "U_VKM_TMS" = 'Y' AND "U_VKM_WMS" = 'N'; 
						If :cnt = 0 Then
							VKM_SND_LOG_Rel := 'N'; -- Las FC no habia ido Nunca en VKMCNN.
						Else
							VKM_ObjDestino := 'TMS';
							SELECT COUNT(*) INTO cnt FROM "OPCH" WHERE "DocEntry" = :BaseEntry_Rel AND ("TrnspCode" <> :VKM_Expedicion OR :VKM_Envia_Entrega = 'Y'); 
							If :cnt = 0 Then
								VKM_SND_LOG_Rel := 'N'; -- Las FC no habia ido Nunca en VKMCNN.
							End If;
						End If;
					ELSE
						-- Es de reserva
						SELECT count(*) into cnt from "PCH1" inner join "OWHS" on "PCH1"."WhsCode" = "OWHS"."WhsCode" where "DocEntry" = :BaseEntry_Rel and "U_VKM_WMS" = 'Y';	
						if :cnt = 0 then
							SELECT COUNT(*) INTO cnt FROM "PCH1" INNER JOIN "OWHS" ON "PCH1"."WhsCode" = "OWHS"."WhsCode" WHERE "DocEntry" = :BaseEntry_Rel AND "U_VKM_TMS" = 'Y';	
							if :cnt = 0 then
								VKM_SND_LOG_Rel := 'N'; -- Las FC no habia ido Nunca en VKMCNN.
							Else
								VKM_ObjDestino := 'TMS';
								SELECT COUNT(*) INTO cnt FROM "OPCH" WHERE "DocEntry" = :BaseEntry_Rel AND ("TrnspCode" <> :VKM_Expedicion OR :VKM_Envia_Entrega = 'Y'); 
								If :cnt = 0 Then
									VKM_SND_LOG_Rel := 'N'; -- Las FC no habia ido Nunca en VKMCNN.
								End If;
							End IF;
						ELSE
							VKM_ObjDestino := 'WMS';						
						End if;
					End If;
				ELSEIF :BaseType_Rel = '22' Then
					SELECT COUNT(*) INTO cnt FROM "POR1" INNER JOIN "OWHS" ON "POR1"."WhsCode" = "OWHS"."WhsCode" WHERE "DocEntry" = :BaseEntry_Rel AND "U_VKM_WMS" = 'Y'; 
					If :cnt = 0 Then
						SELECT COUNT(*) INTO cnt FROM "POR1" INNER JOIN "OWHS" ON "POR1"."WhsCode" = "OWHS"."WhsCode" WHERE "DocEntry" = :BaseEntry_Rel AND "U_VKM_TMS" = 'Y'; 
						If :cnt = 0 Then 
							VKM_SND_LOG_Rel := 'N';
						Else
							VKM_ObjDestino := 'TMS';
							SELECT COUNT(*) INTO cnt FROM "OPOR" WHERE "DocEntry" = :BaseEntry_Rel AND ("TrnspCode" <> :VKM_Expedicion OR :VKM_Envia_Entrega = 'Y');
							If :cnt = 0 Then
								VKM_SND_LOG_Rel := 'N';
							End If;
						End If;
					ELSE
						VKM_ObjDestino := 'WMS';					
					End If;		
				ELSEIF :BaseType_Rel = '234000031' Then
					SELECT COUNT(*) INTO cnt FROM "RRR1" INNER JOIN "OWHS" ON "RRR1"."WhsCode" = "OWHS"."WhsCode" WHERE "DocEntry" = :BaseEntry_Rel AND "U_VKM_WMS" = 'Y'; 
					If :cnt = 0 Then
						SELECT COUNT(*) INTO cnt FROM "RRR1" INNER JOIN "OWHS" ON "RRR1"."WhsCode" = "OWHS"."WhsCode" WHERE "DocEntry" = :BaseEntry_Rel AND "U_VKM_TMS" = 'Y'; 
						If :cnt = 0 Then 
							VKM_SND_LOG_Rel := 'N';
						Else
							VKM_ObjDestino := 'TMS';
							SELECT COUNT(*) INTO cnt FROM "ORRR" WHERE "DocEntry" = :BaseEntry_Rel AND ("TrnspCode" <> :VKM_Expedicion OR :VKM_Envia_Entrega = 'Y');
							If :cnt = 0 Then
								VKM_SND_LOG_Rel := 'N';
							End If;
						End If;
					ELSE
						VKM_ObjDestino := 'WMS';					
					End If;
				ELSEIF :BaseType_Rel = '16' Then
					VKM_ObjDestino := 'TMS';
					SELECT COUNT(*) INTO cnt FROM "RDN1" INNER JOIN "OWHS" ON "RDN1"."WhsCode" = "OWHS"."WhsCode" WHERE "DocEntry" = :BaseEntry_Rel AND "U_VKM_TMS" = 'Y' AND "U_VKM_WMS" = 'N'; 
					If :cnt = 0 Then
						VKM_SND_LOG_Rel := 'N';
					Else
						SELECT COUNT(*) INTO cnt FROM "ORDN" WHERE "DocEntry" = :BaseEntry_Rel AND ("TrnspCode" <> :VKM_Expedicion OR :VKM_Envia_Entrega = 'Y'); 
						If :cnt = 0 Then
							VKM_SND_LOG_Rel := 'N';
						End If;	
					End If;
				ELSEIF :BaseType_Rel = '20' Then
					VKM_ObjDestino := 'TMS';
					SELECT COUNT(*) INTO cnt FROM "PDN1" INNER JOIN "OWHS" ON "PDN1"."WhsCode" = "OWHS"."WhsCode" WHERE "DocEntry" = :BaseEntry_Rel AND "U_VKM_TMS" = 'Y' AND "U_VKM_WMS" = 'N'; 
					If :cnt = 0 Then
						VKM_SND_LOG_Rel := 'N';
					Else
						SELECT COUNT(*) INTO cnt FROM "OPDN" WHERE "DocEntry" = :BaseEntry_Rel AND ("TrnspCode" <> :VKM_Expedicion OR :VKM_Envia_Entrega = 'Y'); 
						If :cnt = 0 Then
							VKM_SND_LOG_Rel := 'N';
						End If;
					End If;
				ELSE 
					VKM_SND_LOG_Rel := 'N';
				End If;
				If :VKM_SND_LOG_Rel = 'Y' Then
					cntRel := 1;
					VKMCnnCode_Rel := :BaseType_Rel||LPAD(:BaseEntry_Rel,11,'0');				
					If :list_of_VKMCnnCode_Rel = '' then
						list_of_VKMCnnCode_Rel := :VKMCnnCode_Rel;
						list_of_VKM_SND_LOG_Rel := :VKM_SND_LOG_Rel;
					Else
						list_of_VKMCnnCode_Rel := :list_of_VKMCnnCode_Rel||';'||:VKMCnnCode_Rel;
						list_of_VKM_SND_LOG_Rel := :list_of_VKM_SND_LOG_Rel||';'||:VKM_SND_LOG_Rel;
					End if;
				Else
					stop := 'Y';
				End if;
			Else
				stop := 'Y';
			End If;
		Else
			stop := 'Y';
		End If;
	-- Returns Request
	ELSEIF :object_type = '234000031' Then 
		-- Tiene alguna linea con depositos WMS 
		SELECT COUNT(*) INTO cnt FROM "RRR1" INNER JOIN "OWHS" ON "RRR1"."WhsCode" = "OWHS"."WhsCode" WHERE "DocEntry" = :list_of_cols_val_tab_del AND "U_VKM_WMS" = 'Y'; 
		If :cnt = 0 Then
			-- Tiene alguna linea con depositos TMS 
			SELECT COUNT(*) INTO cnt FROM "RRR1" INNER JOIN "OWHS" ON "RRR1"."WhsCode" = "OWHS"."WhsCode" WHERE "DocEntry" = :list_of_cols_val_tab_del AND "U_VKM_TMS" = 'Y'; 
			If :cnt = 0 Then 
				if :Modo = 'A' Then
					stop := 'Y';
				Else
					Modo := 'C';
					VKM_SND_LOG := 'N';
				end if ;
			Else
				-- Envia o Busca a domicilio o tiene parametro de de enviar todo
				SELECT COUNT(*) INTO cnt FROM "ORRR" WHERE "DocEntry" = :list_of_cols_val_tab_del AND ("TrnspCode" <> :VKM_Expedicion OR :VKM_Envia_Entrega = 'Y');
				If :cnt = 0 Then
					if :Modo = 'A' Then
						stop := 'Y';
					Else
						Modo := 'C';
						VKM_SND_LOG := 'N';
					end if ;
				Else
					VKM_ObjDestino := 'TMS'; 		-- Si tiene linea con WMS predomina WMS
				End If;
			End If;
		Else
			VKM_ObjDestino := 'WMS'; 		-- Si tiene linea con WMS predomina WMS
		End If;
	-- Goods Return Request
	ELSEIF :object_type = '234000032' Then 
		-- Tiene alguna linea con depositos WMS 
		SELECT COUNT(*) INTO cnt FROM "PRR1" INNER JOIN "OWHS" ON "PRR1"."WhsCode" = "OWHS"."WhsCode" WHERE "DocEntry" = :list_of_cols_val_tab_del AND "U_VKM_WMS" = 'Y'; 
		If :cnt = 0 Then
			-- Tiene alguna linea con depositos TMS 
			SELECT COUNT(*) INTO cnt FROM "PRR1" INNER JOIN "OWHS" ON "PRR1"."WhsCode" = "OWHS"."WhsCode" WHERE "DocEntry" = :list_of_cols_val_tab_del AND "U_VKM_TMS" = 'Y'; 
			If :cnt = 0 Then 
				if :Modo = 'A' Then
					stop := 'Y';
				Else
					Modo := 'C';
					VKM_SND_LOG := 'N';
				end if ;
			Else
				-- Envia o Busca a domicilio o tiene parametro de de enviar todo
				SELECT COUNT(*) INTO cnt FROM "OPRR" WHERE "DocEntry" = :list_of_cols_val_tab_del AND ("TrnspCode" <> :VKM_Expedicion OR :VKM_Envia_Entrega = 'Y');
				If :cnt = 0 Then
					if :Modo = 'A' Then
						stop := 'Y';
					Else
						Modo := 'C';
						VKM_SND_LOG := 'N';
					end if ;
				Else
					VKM_ObjDestino := 'TMS'; 		-- Si tiene linea con WMS predomina WMS
					SELECT "U_VKM_SND_LOG" INTO VKM_SND_LOG FROM "OPRR" WHERE "DocEntry" = :list_of_cols_val_tab_del;
				End If;
			End If;
		Else
			VKM_ObjDestino := 'WMS'; 		-- Si tiene linea con WMS predomina WMS
				-- Recupera envia Documento a VKM porque pudo haber cambiado
			SELECT "U_VKM_SND_LOG" INTO VKM_SND_LOG FROM "OPRR" WHERE "DocEntry" = :list_of_cols_val_tab_del;
		End If;
	--InventoryTransferRequest
	ELSEIF :object_type = '1250000001' Then	
		-- Es una salida y Tiene alguna linea con deposito WMS o TMS
		SELECT COUNT(*) INTO cnt FROM "WTQ1" INNER JOIN "OWHS" ON "WTQ1"."FromWhsCod" = "OWHS"."WhsCode" WHERE "DocEntry" = :list_of_cols_val_tab_del AND ("U_VKM_WMS" = 'Y' OR "U_VKM_TMS" = 'Y');
		If :cnt = 0 Then											 -- Es una entrada
			-- NO es una salida, Es entrada y Tiene alguna linea con deposito WMS o TMS
			SELECT COUNT(*) INTO cnt FROM "WTQ1" INNER JOIN "OWHS" ON "WTQ1"."WhsCode" = "OWHS"."WhsCode" WHERE "DocEntry" = :list_of_cols_val_tab_del AND ("U_VKM_WMS" = 'Y' OR "U_VKM_TMS" = 'Y');
			If :cnt = 0 Then 
				if :Modo = 'A' Then
					stop := 'Y';
				Else
					Modo := 'C';
					VKM_SND_LOG := 'Y';
					VKM_ObjDestino := 'WMS';
				end if ;
			Else	
				-- SI Entrada
				-- Tiene alguna linea con depositos WMS 
				SELECT COUNT(*) INTO cnt FROM "WTQ1" INNER JOIN "OWHS" ON "WTQ1"."WhsCode" = "OWHS"."WhsCode" WHERE "DocEntry" = :list_of_cols_val_tab_del AND "U_VKM_WMS" = 'Y'; 
				If :cnt = 0 Then
					-- Tiene alguna linea con depositos TMS 
					SELECT COUNT(*) INTO cnt FROM "WTQ1" INNER JOIN "OWHS" ON "WTQ1"."WhsCode" = "OWHS"."WhsCode" WHERE "DocEntry" = :list_of_cols_val_tab_del AND "U_VKM_TMS" = 'Y'; 
					If :cnt = 0 Then
						if :Modo = 'A' Then
							stop := 'Y';
						Else
							Modo := 'C';
							VKM_SND_LOG := 'Y';
							VKM_ObjDestino := 'WMS';
						end if ;
					Else
						-- Envia o Busca a domicilio o tiene parametro de de enviar todo
						SELECT COUNT(*) INTO cnt FROM "OWTQ" WHERE "DocEntry" = :list_of_cols_val_tab_del AND ("TrnspCode" <> :VKM_Expedicion OR :VKM_Envia_Entrega = 'Y');
						If :cnt = 0 Then 
							if :Modo = 'A' Then
								stop := 'Y';
							Else
								Modo := 'C';
								VKM_SND_LOG := 'Y';
								VKM_ObjDestino := 'WMS';
							end if ;
						Else
							VKM_ObjDestino := 'TMS';
						End If;
					End If;
				Else
					VKM_ObjDestino := 'WMS'; 		-- Si tiene linea con WMS predomina WMS
				End If;
			End If; 
		Else	
			-- SI es una salida
			-- Tiene alguna linea con depositos WMS 
			SELECT COUNT(*) INTO cnt FROM "WTQ1" INNER JOIN "OWHS" ON "WTQ1"."FromWhsCod" = "OWHS"."WhsCode" WHERE "DocEntry" = :list_of_cols_val_tab_del AND "U_VKM_WMS" = 'Y'; 
			If :cnt = 0 Then
				-- Tiene alguna linea con depositos TMS 
				SELECT COUNT(*) INTO cnt FROM "WTQ1" INNER JOIN "OWHS" ON "WTQ1"."FromWhsCod" = "OWHS"."WhsCode" WHERE "DocEntry" = :list_of_cols_val_tab_del AND "U_VKM_TMS" = 'Y'; 
				If :cnt = 0 Then
					if :Modo = 'A' Then
						stop := 'Y';
					Else
						Modo := 'C';
						VKM_SND_LOG := 'Y';
						VKM_ObjDestino := 'WMS';
					end if ;
				Else
					VKM_ObjDestino := 'TMS';
					-- Recupera envia Documento a VKM porque pudo haber cambiado
					SELECT "U_VKM_SND_LOG" into VKM_SND_LOG FROM "OWTQ" WHERE "DocEntry" = :list_of_cols_val_tab_del;
				End If;
			Else
				VKM_ObjDestino := 'WMS'; 		
				-- Recupera envia Documento a VKM porque pudo haber cambiado
				SELECT "U_VKM_SND_LOG" into VKM_SND_LOG FROM "OWTQ" WHERE "DocEntry" = :list_of_cols_val_tab_del;
			End If;
		End If;
	End If;
	
	-- Es un documento que interesa para VKM
	if :stop = 'N' then
		-- Armo Codigo para tabla de comunicion entre sistemas SAP - VKM
		if :object_type = '13' OR :object_type = '14' OR :object_Type = '15' OR :object_type = '16' OR :object_type = '17' 
					OR :object_type = '18' OR :object_type = '19' OR :object_type = '20' OR :object_type = '21' OR :object_type = '22' 
					OR :object_type = '67' OR :object_type = '234000031' OR :object_type = '234000032' 
					OR :object_type = '1250000001' then
			VKMCnnCode := SUBSTRING(:ObjectType,1,20)||LPAD(:ObjectKey,11,'0');
		ELSE 
			VKMCnnCode := SUBSTRING(:ObjectType,1,20)||:ObjectKey;
		end if;
	
		-- Documento fue Cerrado
		if :Modo = 'L' then
			VKMObjStatus := 'CLS';
			-- Documento esta Bloqueado
			SELECT count(*) into cnt FROM "@VKMCNN" WHERE "Code" = :VKMCnnCode and ("U_VKMObjStatus" = 'BLQ' OR "U_VKMObjStatus" = 'ASG');
			if :cnt>0 then
				error := 200;
				error_message := 'You cannot close this record because the document is being processed in VKM.';
				stop := 'Y';
			end if;	
		-- Documento fue Cancelado o Borrado
		elseif :Modo = 'C' or :Modo = 'D' then			
			VKMObjStatus := 'ANU';
			-- Documento NO esta pendiente
			SELECT count(*) into cnt FROM "@VKMCNN" WHERE "Code" = :VKMCnnCode and "U_VKMObjStatus" <> 'PND';
			if :cnt>0 then
				error := 300;
				error_message := 'You cannot modify this record because it is linked to VKM.';
				stop := 'Y';
			-- Documento Relacionado NO esta pendiente
			ELSEif :cntRel > 0 then		-- si tiene codigo relacionado
				i := 1;
				WHILE :i <= :cntRel DO
					SELECT SUBSTRING_REGEXPR('[^;]+' IN list_of_VKMCnnCode_Rel FROM 1 OCCURRENCE :i) into VKMCnnCode_Rel from dummy;
					SELECT count(*) into cnt FROM "@VKMCNN" WHERE "Code" = :VKMCnnCode_Rel and ("U_VKMObjStatus" = 'BLQ' OR "U_VKMObjStatus" = 'ASG') ; 
					if :cnt>0 then
						error := 500;
						error_message := 'You cannot create this record because the related document ('||rtrim(ltrim(:VKMCnnCode_Rel))||') is linked to VKM.';
						stop := 'Y';
					end if;	
					i = :i + 1;
				end WHILE;	
			-- Es BusinessPartners 
			ELSEif :object_type = '2' then	
				-- si no existe el registro es porque VKM se lo proceso y no puede Cancelarlo o Borrarlo
				SELECT count(*) into cnt FROM "@VKMCNN" WHERE "Code" = :VKMCnnCode ; 
				if :cnt = 0 then
					error := 600;
					error_message := 'You cannot modify this record because it is linked to VKM.';
					stop := 'Y';
				else
					VKM_SND_LOG := 'N';
				end if;	
			End If;	
		Else
			VKMObjStatus := 'PND';
			-- Documento NO esta pendiente
			SELECT COUNT(*) INTO cnt FROM "@VKMCNN" WHERE "Code" = :VKMCnnCode AND ("U_VKMObjStatus" = 'BLQ' OR "U_VKMObjStatus" = 'ASG'); 
			if :cnt>0 then
				error := 100;
				error_message := 'You cannot modify this record because it is linked to VKM.';
				stop := 'Y';
			-- Documento Relacionado NO esta pendiente
			ELSEif :cntRel > 0 then	
				i := 1;
				WHILE :i <= :cntRel DO
					SELECT SUBSTRING_REGEXPR('[^;]+' IN list_of_VKMCnnCode_Rel FROM 1 OCCURRENCE :i) into VKMCnnCode_Rel from dummy;
					SELECT count(*) into cnt FROM "@VKMCNN" WHERE "Code" = :VKMCnnCode_Rel and ("U_VKMObjStatus" = 'BLQ' OR "U_VKMObjStatus" = 'ASG'); 
					if :cnt>0 then
						error := 400;
						error_message := 'You cannot create this record because the related document ('||rtrim(ltrim(:VKMCnnCode_Rel))||') is linked to VKM.';
						stop := 'Y';
					end if;	
					i = :i + 1;
				end WHILE;	
			end if;	
			-- Si no hubo error aún, controlo que en los Kits todos los ingredientes salgan del mismo deposito que el padre
			if :stop = 'N' and :VKM_ObjDestino = 'WMS' then 
				cnt := 0;
				if  :object_type = '17' then
					Select count(*) into cnt from (
						SELECT "H"."ItemCode" as Hijo ,
						CASE WHEN ("U_VKM_WMS" <> 'Y' ) THEN '' ELSE "H"."WhsCode" END as HijoDeposito ,
						(SELECT "ItemCode" from 
								(SELECT "Aux"."ItemCode", "Aux"."WhsCode", row_number () over 
									   (partition by "Aux"."DocEntry"
										ORDER BY "Aux"."DocEntry" asc, "Aux"."LineNum" desc) as "RN" 
										FROM "RDR1" as "Aux" Where "Aux"."DocEntry" = "H"."DocEntry" and "Aux"."LineNum" < "H"."LineNum" and "Aux"."TreeType" = 'S') 
								where "RN" = 1) as Padre ,
						(SELECT  CASE WHEN ("U_VKM_WMS" <> 'Y' ) THEN '' ELSE "WhsCode" END from 
								(SELECT "Aux"."ItemCode", "Aux"."WhsCode", "W"."U_VKM_WMS", row_number () over 
									   (partition by "Aux"."DocEntry"
										ORDER BY "Aux"."DocEntry" asc, "Aux"."LineNum" desc) as "RN" 
										FROM "RDR1" as "Aux" inner join "OWHS" as "W" on "Aux"."WhsCode" = "W"."WhsCode" Where "Aux"."DocEntry" = "H"."DocEntry" and "Aux"."LineNum" < "H"."LineNum" and "Aux"."TreeType" = 'S' ) 
								where "RN" = 1)  as PadreDeposito 
						from "RDR1" as "H" inner join "OWHS" as "W" on "H"."WhsCode" = "W"."WhsCode"
						where "H"."DocEntry" = :list_of_cols_val_tab_del and "H"."TreeType" = 'I'
					) where PadreDeposito <> HijoDeposito ;
				end if;	
				if  :object_type = '13' then
					Select count(*) into cnt from (
						SELECT "H"."ItemCode" as Hijo ,
						CASE WHEN ("U_VKM_WMS" <> 'Y' ) THEN '' ELSE "H"."WhsCode" END as HijoDeposito ,
						(SELECT "ItemCode" from 
								(SELECT "Aux"."ItemCode", "Aux"."WhsCode", row_number () over 
									   (partition by "Aux"."DocEntry"
										ORDER BY "Aux"."DocEntry" asc, "Aux"."LineNum" desc) as "RN" 
										FROM "INV1" as "Aux" Where "Aux"."DocEntry" = "H"."DocEntry" and "Aux"."LineNum" < "H"."LineNum" and "Aux"."TreeType" = 'S') 
								where "RN" = 1) as Padre ,
						(SELECT  CASE WHEN ("U_VKM_WMS" <> 'Y' ) THEN '' ELSE "WhsCode" END from 
								(SELECT "Aux"."ItemCode", "Aux"."WhsCode", "W"."U_VKM_WMS", row_number () over 
									   (partition by "Aux"."DocEntry"
										ORDER BY "Aux"."DocEntry" asc, "Aux"."LineNum" desc) as "RN" 
										FROM "INV1" as "Aux" inner join "OWHS" as "W" on "Aux"."WhsCode" = "W"."WhsCode" Where "Aux"."DocEntry" = "H"."DocEntry" and "Aux"."LineNum" < "H"."LineNum" and "Aux"."TreeType" = 'S' ) 
								where "RN" = 1)  as PadreDeposito 
						from "INV1" as "H" inner join "OWHS" as "W" on "H"."WhsCode" = "W"."WhsCode"
						where "H"."DocEntry" = :list_of_cols_val_tab_del and "H"."TreeType" = 'I'
					) where PadreDeposito <> HijoDeposito ;
				end if;
				if  :object_type = '234000031' then
					Select count(*) into cnt from (
						SELECT "H"."ItemCode" as Hijo ,
						CASE WHEN ("U_VKM_WMS" <> 'Y' ) THEN '' ELSE "H"."WhsCode" END as HijoDeposito ,
						(SELECT "ItemCode" from 
								(SELECT "Aux"."ItemCode", "Aux"."WhsCode", row_number () over 
									   (partition by "Aux"."DocEntry"
										ORDER BY "Aux"."DocEntry" asc, "Aux"."LineNum" desc) as "RN" 
										FROM "RRR1" as "Aux" Where "Aux"."DocEntry" = "H"."DocEntry" and "Aux"."LineNum" < "H"."LineNum" and "Aux"."TreeType" = 'S') 
								where "RN" = 1) as Padre ,
						(SELECT  CASE WHEN ("U_VKM_WMS" <> 'Y' ) THEN '' ELSE "WhsCode" END from 
								(SELECT "Aux"."ItemCode", "Aux"."WhsCode", "W"."U_VKM_WMS", row_number () over 
									   (partition by "Aux"."DocEntry"
										ORDER BY "Aux"."DocEntry" asc, "Aux"."LineNum" desc) as "RN" 
										FROM "RRR1" as "Aux" inner join "OWHS" as "W" on "Aux"."WhsCode" = "W"."WhsCode" Where "Aux"."DocEntry" = "H"."DocEntry" and "Aux"."LineNum" < "H"."LineNum" and "Aux"."TreeType" = 'S' ) 
								where "RN" = 1)  as PadreDeposito 
						from "RRR1" as "H" inner join "OWHS" as "W" on "H"."WhsCode" = "W"."WhsCode"
						where "H"."DocEntry" = :list_of_cols_val_tab_del and "H"."TreeType" = 'I'
					) where PadreDeposito <> HijoDeposito ;
				end if;
				if  :object_type = '1250000001' then
					Select count(*) into cnt from (
						SELECT "H"."ItemCode" as Hijo ,
						CASE WHEN ("U_VKM_WMS" <> 'Y' ) THEN '' ELSE "H"."WhsCode" END as HijoDeposito ,
						(SELECT "ItemCode" from 
								(SELECT "Aux"."ItemCode", "Aux"."WhsCode", row_number () over 
									   (partition by "Aux"."DocEntry"
										ORDER BY "Aux"."DocEntry" asc, "Aux"."LineNum" desc) as "RN" 
										FROM "WTQ1" as "Aux" Where "Aux"."DocEntry" = "H"."DocEntry" and "Aux"."LineNum" < "H"."LineNum" and "Aux"."TreeType" = 'S') 
								where "RN" = 1) as Padre ,
						(SELECT  CASE WHEN ("U_VKM_WMS" <> 'Y' ) THEN '' ELSE "WhsCode" END from 
								(SELECT "Aux"."ItemCode", "Aux"."WhsCode", "W"."U_VKM_WMS", row_number () over 
									   (partition by "Aux"."DocEntry"
										ORDER BY "Aux"."DocEntry" asc, "Aux"."LineNum" desc) as "RN" 
										FROM "WTQ1" as "Aux" inner join "OWHS" as "W" on "Aux"."WhsCode" = "W"."WhsCode" Where "Aux"."DocEntry" = "H"."DocEntry" and "Aux"."LineNum" < "H"."LineNum" and "Aux"."TreeType" = 'S' ) 
								where "RN" = 1)  as PadreDeposito 
						from "WTQ1" as "H" inner join "OWHS" as "W" on "H"."WhsCode" = "W"."WhsCode"
						where "H"."DocEntry" = :list_of_cols_val_tab_del and "H"."TreeType" = 'I'
					) where PadreDeposito <> HijoDeposito ;
				end if;
				if :cnt>0 then
					error := 700;
					error_message := 'You cannot create this record because the item with Sales BOM Type have diferent Warehouse that your Materials.';
					stop := 'Y';
				end if;	
			end if;
		end if;
		-- Modificacion de Kit no permitido con Documentos Pendientes
		if :stop = 'N' then 
			IF :object_type = '66' AND :VKM_NOV_ART = 'Y' Then
				SELECT COUNT(*) INTO cnt FROM "RDR1" inner join "OWHS" on "RDR1"."WhsCode" = "OWHS"."WhsCode" WHERE "ItemCode" = :list_of_cols_val_tab_del AND "OpenQty" > 0 and "U_VKM_WMS" = 'Y';
				if :cnt>0 then
					error := 800;
					error_message := 'You cannot modify this record because there are Sales Order with pending quantity.';
					stop := 'Y';
				ELSE
					SELECT COUNT(*) INTO cnt FROM "INV1" inner join "OWHS" on "INV1"."WhsCode" = "OWHS"."WhsCode" WHERE "ItemCode" = :list_of_cols_val_tab_del AND "OpenQty" > 0 and "U_VKM_WMS" = 'Y';
					if :cnt>0 then
						error := 801;
						error_message := 'You cannot modify this record because there are A/R Invoice with pending quantity.';
						stop := 'Y';
					ELSE
						SELECT COUNT(*) INTO cnt FROM "RRR1" inner join "OWHS" on "RRR1"."WhsCode" = "OWHS"."WhsCode" WHERE "ItemCode" = :list_of_cols_val_tab_del AND "OpenQty" > 0 and "U_VKM_WMS" = 'Y';
						if :cnt>0 then
							error := 804;
							error_message := 'You cannot modify this record because there are Return Request with pending quantity.';
							stop := 'Y';
						ELSE
							SELECT COUNT(*) INTO cnt FROM "WTQ1" inner join "OWHS" on "WTQ1"."WhsCode" = "OWHS"."WhsCode" WHERE "ItemCode" = :list_of_cols_val_tab_del AND "OpenQty" > 0 and "U_VKM_WMS" = 'Y';
							if :cnt>0 then
								error := 806;
								error_message := 'You cannot modify this record because there are Inventory Transfer Request with pending quantity.';
								stop := 'Y';
							End If;
						End If;
					End If;
				End If;			
			end if;	
		end if;
		

		-- Si no hubo error aún
		if :stop = 'N' then 
			-- existe el registro del Documento
			SELECT count(*) into cnt FROM "@VKMCNN" WHERE "Code" = :VKMCnnCode;
			if :cnt=0 then
				-- NO existe el registro
				-- Hay que enviarlo
				if :VKM_SND_LOG = 'Y' then
					INSERT INTO "@VKMCNN" ("Code", "Name", "U_VKMObjType", "U_VKMObjKey", "U_VKMObjStatus", "U_VKMObjDestino") VALUES (:VKMCnnCode, :VKMCnnCode, SUBSTRING(:ObjectType,1,20), :ObjectKey, :VKMObjStatus, :VKM_ObjDestino);
				end if;
			ELSE
				-- SI existe el registro
				-- NO hay que enviarlo
				IF :VKM_SND_LOG = 'N' then
					DELETE FROM "@VKMCNN" where "Code" = :VKMCnnCode;
				else
					UPDATE "@VKMCNN" set "U_VKMObjStatus" = :VKMObjStatus, "U_VKMObjDestino" = :VKM_ObjDestino where "Code" = :VKMCnnCode;
				end if;
			end if;					
			-- tiene Documento relacionado
			if :cntRel > 0 then	
				i := 1;
				WHILE :i <= :cntRel DO
					SELECT SUBSTRING_REGEXPR('[^;]+' IN list_of_VKMCnnCode_Rel FROM 1 OCCURRENCE :i) into VKMCnnCode_Rel from dummy;
					SELECT SUBSTRING_REGEXPR('[^;]+' IN list_of_VKM_SND_LOG_Rel FROM 1 OCCURRENCE :i) into VKM_SND_LOG_Rel from dummy;
					-- existe el registro del Documento Relacionado
					SELECT count(*) into cnt FROM "@VKMCNN" WHERE "Code" = :VKMCnnCode_Rel;
					if :cnt=0 then
						-- NO existe el registro
						-- Hay que enviarlo
						if :VKM_SND_LOG_Rel = 'Y' then
							SELECT CAST(SUBSTRING(VKMCnnCode_Rel, LENGTH(VKMCnnCode_Rel)-10, 11 ) AS int) into BaseEntry_Rel from dummy;
							SELECT SUBSTRING(VKMCnnCode_Rel, 1, LENGTH(VKMCnnCode_Rel)-11 ) into BaseType_Rel from dummy;
							INSERT INTO "@VKMCNN" ("Code", "Name", "U_VKMObjType", "U_VKMObjKey", "U_VKMObjStatus", "U_VKMObjDestino") VALUES (:VKMCnnCode_Rel, :VKMCnnCode_Rel, :BaseType_Rel, :BaseEntry_Rel, :VKMObjStatus, :VKM_ObjDestino);
						end if;
					ELSE
						-- SI existe el registro
						UPDATE "@VKMCNN" set "U_VKMObjStatus" = :VKMObjStatus, "U_VKMObjDestino" = :VKM_ObjDestino where "Code" = :VKMCnnCode_Rel;
					end if;
					i = :i + 1;
				End WHILE;
			end if;					
		end if;

	End If;

end if;

-- VKM -- FIN --

-- Select the return values
select :error, :error_message FROM dummy;

end;
