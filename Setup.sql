--Test 

SET SCHEMA "SBODEMOAR";
DROP TABLE "SB1OBJECTLOG";
DROP TABLE "SB1OBJECTREPLICATE";
DROP SEQUENCE "SB1OBJECTLOG_S";
CREATE COLUMN TABLE "SB1OBJECTLOG" ("Sequence" int, "TimeStamp" LONGDATE CS_LONGDATE, "ReplicateObject" nchar(1), "ObjectSaved" nchar(1),"ObjectAppliedOnTarget" nchar(1), "TNErrorCode" int, "TNErrorMessage" nvarchar (200), "ObjectType" nvarchar(30), "TransactionType" nchar(1), "NumOfColsInKey" int, "ListOfKeyColsTabDel" nvarchar(255), "ListOfColsValTabDel" nvarchar(255), "UserSign" int,"UserSign2" int  ) UNLOAD PRIORITY 5  AUTO MERGE;
CREATE COLUMN TABLE "SB1OBJECTREPLICATE" ("ObjectType" nvarchar(30), "ReplicateObject" nchar(1), "ObjectDescription" nvarchar (300)) UNLOAD PRIORITY 5  AUTO MERGE;
CREATE SEQUENCE "SB1OBJECTLOG_S"; 
insert into "SB1OBJECTREPLICATE" values('2','S', 'Business Partner'); 
insert into "SB1OBJECTREPLICATE" values('11','N', 'Contact Person'); 
insert into "SB1OBJECTREPLICATE" values('187','N', 'Bank Account'); 
insert into "SB1OBJECTREPLICATE" values('4','S', 'Item'); 
insert into "SB1OBJECTREPLICATE" values('1470000062','N', 'BarCode'); 
insert into "SB1OBJECTREPLICATE" values('10000199','N', 'UoM'); 
insert into "SB1OBJECTREPLICATE" values('10000197','N', 'UoM Group'); 
insert into "SB1OBJECTREPLICATE" values('187','N', 'Bank Account'); 

insert into "SB1OBJECTREPLICATE" values('140','N', 'Payment to Vendor Draft'); 
insert into "SB1OBJECTREPLICATE" values('241','N', 'Cash Flow Transaction'); 
insert into "SB1OBJECTREPLICATE" values('30','N', 'Journal Entry'); 
insert into "SB1OBJECTREPLICATE" values('46','N', 'Payment to Vendor'); 

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








