SET SCHEMA "SBODEMOAR";
--DROP TABLE "SB1OBJECTLOG";
--DROP TABLE "SB1OBJECTREPLICATE";
--DROP SEQUENCE "SB1OBJECTLOG_S";
--CREATE COLUMN TABLE "SB1OBJECTLOG" ("Sequence" int, "TimeStamp" LONGDATE CS_LONGDATE, "ReplicateObject" nchar(1), "ObjectSaved" nchar(1),"ObjectAppliedOnTarget" nchar(1), "TNErrorCode" int, "TNErrorMessage" nvarchar (200), "ObjectType" nvarchar(30), "TransactionType" nchar(1), "NumOfColsInKey" int, "ListOfKeyColsTabDel" nvarchar(255), "ListOfColsValTabDel" nvarchar(255), "UserSign" int,"UserSign2" int  ) UNLOAD PRIORITY 5  AUTO MERGE;
--CREATE COLUMN TABLE "SB1OBJECTREPLICATE" ("ObjectType" nvarchar(30), "ReplicateObject" nchar(1), "ObjectDescription" nvarchar (300)) UNLOAD PRIORITY 5  AUTO MERGE;
--CREATE SEQUENCE "SB1OBJECTLOG_S"; 
--insert into "SB1OBJECTREPLICATE" values('2','S', 'Business Partner'); 
--insert into "SB1OBJECTREPLICATE" values('11','N', 'Contact Person'); 
--insert into "SB1OBJECTREPLICATE" values('187','N', 'Bank Account'); 
--insert into "SB1OBJECTREPLICATE" values('4','S', 'Item'); 
--insert into "SB1OBJECTREPLICATE" values('1470000062','N', 'BarCode'); 
--insert into "SB1OBJECTREPLICATE" values('10000199','N', 'UoM'); 
--insert into "SB1OBJECTREPLICATE" values('10000197','N', 'UoM Group'); 
--insert into "SB1OBJECTREPLICATE" values('187','N', 'Bank Account'); 
--insert into "SB1OBJECTREPLICATE" values('140','N', 'Payment to Vendor Draft'); 
--insert into "SB1OBJECTREPLICATE" values('241','N', 'Cash Flow Transaction'); 
--insert into "SB1OBJECTREPLICATE" values('30','N', 'Journal Entry'); 
--insert into "SB1OBJECTREPLICATE" values('46','N', 'Payment to Vendor'); 

DROP PROCEDURE TESTEAR;

CREATE PROCEDURE TESTEAR()
LANGUAGE SQLSCRIPT
AS
-- Return values
error  int;				-- Result (0 for no error)
error_message nvarchar (200); 		-- Error string to be displayed
--REPLICATION VARIABLES
object_saved_pending int;
sequence_val int;
object_should_be_replicated int; 
usersign int;
usersign2 int;

--END REPLICATION VARIABLES

begin

	select "SB1OBJECTLOG_S".NEXTVAL into sequence_val from dummy;
	insert into "SB1OBJECTLOG" ("Sequence","TimeStamp","ReplicateObject","ObjectSaved","TNErrorMessage") 
		values(sequence_val,CURRENT_TIMESTAMP, 'Y', 'N','Esta es una buena prueba');
 
end;








ALTER PROCEDURE SBO_SP_TransactionNotification
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
error  int;				-- Result (0 for no error)
error_message nvarchar (200); 		-- Error string to be displayed
--REPLICATION VARIABLES
object_saved_pending int;
sequence_val int;
object_should_be_replicated int; 
usersign int;
usersign2 int;

--END REPLICATION VARIABLES

begin

--REPLICATION MODULE A
--The information of the uncommited transaction should be saved outside an AUTONOMOUS TX.

-- BusinessPartner

if object_type = '2' then
	select "UserSign", "UserSign2" into usersign, usersign2 from OCRD where "CardCode" =  list_of_cols_val_tab_del;
end if;

--BusinessPartner -> Contact Person Object it doesnt have UserSign2

if object_type = '11' then
	select "UserSign" into usersign from OCPR where "CntctCode" =  list_of_cols_val_tab_del;
	usersign2=0;
end if;

--BusinessPartner -> Bank Account

if object_type = '187' then
	usersign =0;
	usersign2=0;
end if;



-- Item

if object_type = '4' then
	select "UserSign", "UserSign2" into usersign, usersign2 from OITM where "ItemCode" =  list_of_cols_val_tab_del;
end if;

--BarCode Entry

if object_type = '1470000062' then
	select "UserSign", "UserSign2" into usersign, usersign2 from OBCD where "BcdEntry" =  list_of_cols_val_tab_del;
end if;
 
--UOM Entry

if object_type = '10000199' then
	select "UserSign", "UserSign2" into usersign, usersign2 from OUOM where "UomEntry" =  list_of_cols_val_tab_del;
end if;

--UoM Group Entry

if object_type = '10000197' then
	select "UserSign", "UserSign2" into usersign, usersign2 from OUGP where "UgpEntry" =  list_of_cols_val_tab_del;
end if;


BEGIN AUTONOMOUS TRANSACTION

--Some update operations DO NO PASS THRU TN. That is awkward, but a design condition that is un SAP hands.
--Example 1: Updates to WTD3 from within BP. If you only modify witholding tax for a BP there is no object change
--	it is my understanding that SAP updates direct into WTD3 table.	
--Counter-Example 1: Updates UOM from within ITEM Form are recorded as objects.	
-- Wierd Object 410000000 Customized menu

--GET WHO DID OR UPDATE THE OBJECT.


select count(*) into object_should_be_replicated from "SB1OBJECTREPLICATE" where "ObjectType" = object_type;

-- If object should be replicated, the information saved into "SB1OBJECTLOG" differs.

if :object_should_be_replicated > 0 then
	select "SB1OBJECTLOG_S".NEXTVAL into sequence_val from dummy;
	insert into "SB1OBJECTLOG" values(sequence_val, CURRENT_TIMESTAMP, 'Y', 'N', 'N', error, error_message, object_type, transaction_type,num_of_cols_in_key,list_of_key_cols_tab_del, list_of_cols_val_tab_del,usersign,usersign2);
else
	select "SB1OBJECTLOG_S".NEXTVAL into sequence_val from dummy;
	insert into "SB1OBJECTLOG" values(sequence_val, CURRENT_TIMESTAMP, 'I', 'N', 'N', error, error_message, object_type, transaction_type,num_of_cols_in_key,list_of_key_cols_tab_del, list_of_cols_val_tab_del,usersign,usersign2);
end if;

COMMIT;
END;
-- ENDING REPLICATION MODULE A


error := 0;
error_message := 'CUAK-Ok';


--REPLICATION MODULE B
BEGIN AUTONOMOUS TRANSACTION

select count(*) into object_saved_pending from "SB1OBJECTLOG" where "ObjectSaved" = 'N' and "ListOfKeyColsTabDel" = list_of_key_cols_tab_del and "ListOfColsValTabDel" = list_of_cols_val_tab_del;
-- In case the object has not been saved yet -by means of a Service Layer or DI Daemon- it stops the transaction
object_saved_pending = 0;

if :object_saved_pending > 1 then
   	error := 10000;
	error_message := 'Objeto en proceso de replicacion no puede ser grabado, intente nuevamente. Pendientes:' || cast(:object_saved_pending - 1 as varchar);
end if;

update "SB1OBJECTLOG" set "TNErrorCode" = error, "TNErrorMessage" = :error_message where "Sequence" = sequence_val;

COMMIT;
END;
--ENDING REPLICATION MODULE B


select :error, :error_message FROM dummy;
end;
