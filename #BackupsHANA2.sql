--BACKUP DATA USING FILE ('COMPLETE_DATA_BACKUP');
/*
BACKUP CATALOG DELETE [ FOR <database_name> ] 
   { ALL BEFORE BACKUP_ID <backup_id> [ WITH FILE | WITH BACKINT | COMPLETE ]
     | BACKUP_ID <backup_id> [ COMPLETE ] 
   }
   */
   
  /*Esto borra todos los backups anteriores al BACKUP_IP incluyendo los log files */ 
   
  BACKUP CATALOG DELETE ALL BEFORE BACKUP_ID 1674024285919 COMPLETE;
  
  BACKUP CATALOG DELETE ALL BEFORE BACKUP_ID 1674024485305 COMPLETE;
  
  select * from sys.m_backup_catalog;
  /* 
En este query encuentro todos los backusp catalogados
tiene una columan mas DATABASE_NAME
 */
  select * from sys_databases.m_backup_catalog Where DATABASE_NAME = 'NDB' and ENTRY_TYPE_NAME = 'complete data backup' order by SYS_START_TIME desc;
  select * from sys_databases.m_backup_catalog Where DATABASE_NAME = 'SYSTEMDB' and ENTRY_TYPE_NAME = 'complete data backup' order by SYS_START_TIME desc;
  
  select BACKUP_ID from sys_databases.m_backup_catalog Where DATABASE_NAME = 'NDB' and STATE_NAME = 'successful' and ENTRY_TYPE_NAME = 'complete data backup' order by SYS_START_TIME desc;
  select BACKUP_ID from sys_databases.m_backup_catalog Where DATABASE_NAME = 'SYSTEMDB'  and STATE_NAME = 'successful' and ENTRY_TYPE_NAME = 'complete data backup' order by SYS_START_TIME desc;

  select top 1 BACKUP_ID from sys_databases.m_backup_catalog Where DATABASE_NAME = 'NDB' and STATE_NAME = 'successful' and ENTRY_TYPE_NAME = 'complete data backup' order by SYS_START_TIME desc;
  select top 1 BACKUP_ID from sys_databases.m_backup_catalog Where DATABASE_NAME = 'SYSTEMDB'  and STATE_NAME = 'successful' and ENTRY_TYPE_NAME = 'complete data backup' order by SYS_START_TIME desc;

do
begin
Declare backupid bigInt;
Declare sqlstatement varchar(500);

select "numero" into backupid from (select top 1 BACKUP_ID "numero" from sys_databases.m_backup_catalog Where DATABASE_NAME = 'SYSTEMDB'  and STATE_NAME = 'successful' and ENTRY_TYPE_NAME = 'complete data backup' order by SYS_START_TIME desc);

sqlstatement = 'BACKUP CATALOG DELETE ALL BEFORE BACKUP_ID ' || :backupid || ' COMPLETE';
select :sqlstatement from dummy;
execute immediate :sqlstatement;
end;  

do
begin
Declare backupid bigInt;
Declare sqlstatement varchar(500);

select "numero" into backupid from (select top 1 BACKUP_ID "numero" from sys_databases.m_backup_catalog Where DATABASE_NAME = 'NDB'  and STATE_NAME = 'successful' and ENTRY_TYPE_NAME = 'complete data backup' order by SYS_START_TIME desc);

sqlstatement = 'BACKUP CATALOG DELETE FOR NDB ALL BEFORE BACKUP_ID ' || :backupid || ' COMPLETE';
select :sqlstatement from dummy;
execute immediate :sqlstatement;
end;  


  
