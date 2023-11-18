/*do
begin
declare BKP nvarchar(30);
select * from M_BACKUP_CATALOG order by UTC_END_TIME desc;
select top 1 BACKUP_ID into BKP from M_BACKUP_CATALOG where ENTRY_TYPE_NAME ='complete data backup' and STATE_NAME = 'successful' order by UTC_END_TIME desc;
execute immediate 'BACKUP CATALOG DELETE ALL BEFORE BACKUP_ID ' || :BKP || ' COMPLETE';
select * from M_BACKUP_CATALOG order by UTC_END_TIME desc;
end;
backup data using file ('COMPLETE5');
select * from M_BACKUP_CATALOG order by UTC_END_TIME desc;

/*
./hdbsql -u SYSTEM  -n 192.168.1.227:30015 -p 'Kaiser$641' -O /tmp/result 'select top 10 * from schemas'
./hdbsql -u SYSTEM  -n 192.168.1.227:30015 -p 'Kaiser$641' -O /tmp/result 'do begin declare BKP nvarchar(30); select * from M_BACKUP_CATALOG order by UTC_END_TIME desc; select top 1 BACKUP_ID into BKP from M_BACKUP_CATALOG where ENTRY_TYPE_NAME ='"'"'complete data backup'"'"' and STATE_NAME = '"'"'successful'"'"' order by UTC_END_TIME desc; execute immediate '"'"'BACKUP CATALOG DELETE ALL BEFORE BACKUP_ID '"'"' || :BKP || '"'"' COMPLETE'"'"'; select * from M_BACKUP_CATALOG order by UTC_END_TIME desc; end;'

CAMBIO PARA SYSTEMDB

./hdbsql -u SYSTEM  -d SYSTEMDB -p 'Kaiser$641' -O /tmp/result 'do begin declare BKP nvarchar(30); select * from M_BACKUP_CATALOG order by UTC_END_TIME desc; select top 1 BACKUP_ID into BKP from M_BACKUP_CATALOG where ENTRY_TYPE_NAME ='"'"'complete data backup'"'"' and STATE_NAME = '"'"'successful'"'"' order by UTC_END_TIME desc; execute immediate '"'"'BACKUP CATALOG DELETE ALL BEFORE BACKUP_ID '"'"' || :BKP || '"'"' COMPLETE'"'"'; select * from M_BACKUP_CATALOG order by UTC_END_TIME desc; end;'

Para conectarse como SYSTEM en SYSTEMDB desde un remoto
./hdbsql -u SYSTEM  -d SYSTEMDB -p 'Kaiser$641' -n 192.168.1.227:30013


current_time=$(date "+%Y%m%d%H%M%S") && /hana/shared/NDB/hdbclient/hdbsql -u SYSTEM  -d NDB -p 'Ivana$641' -O /tmp/backupNDBresult.$current_time \
"do \
begin \
declare BKP nvarchar(30); 
execute immediate 'BACKUP DATA USING FILE (''COMPLETENDB$current_time'')';
select top 1 BACKUP_ID into BKP from M_BACKUP_CATALOG where ENTRY_TYPE_NAME ='complete data backup' and STATE_NAME = 'successful' order by UTC_END_TIME desc;
execute immediate 'BACKUP CATALOG DELETE ALL BEFORE BACKUP_ID ' || :BKP || ' COMPLETE'; 
end;"


current_time=$(date "+%Y%m%d%H%M%S") && /hana/shared/NDB/hdbclient/hdbsql -u SYSTEM  -d SYSTEMDB  -p 'Ivana$641' -O /tmp/backupSYSTEMDBresult.$current_time \
"do \
begin \
declare BKP nvarchar(30); 
execute immediate 'BACKUP DATA USING FILE (''COMPLETESYSTEMDB$current_time'')';
select top 1 BACKUP_ID into BKP from M_BACKUP_CATALOG where ENTRY_TYPE_NAME ='complete data backup' and STATE_NAME = 'successful' order by UTC_END_TIME desc;
execute immediate 'BACKUP CATALOG DELETE ALL BEFORE BACKUP_ID ' || :BKP || ' COMPLETE'; 
end;"


*/


rm /usr/sap/NDB/HDB00/backup/data/SYSTEMDB/COMPLETE* && rm /usr/sap/NDB/HDB00/backup/log/SYSTEMDB/COMPLETE* && /usr/sap/hdbclient/hdbsql -u SYSTEM  -p 'Kaiser$641' -o /tmp/resulta -d SYSTEMDB 'do begin declare BKP nvarchar(30); execute immediate '"'"'BACKUP DATA USING FILE ('"'"''"'"'COMPLETE'"'"''"'"')'"'"'; select * from M_BACKUP_CATALOG order by UTC_END_TIME desc; select top 1 BACKUP_ID into BKP from M_BACKUP_CATALOG where ENTRY_TYPE_NAME ='"'"'complete data backup'"'"' and STATE_NAME = '"'"'successful'"'"' order by UTC_END_TIME desc; execute immediate '"'"'BACKUP CATALOG DELETE ALL BEFORE BACKUP_ID '"'"' || :BKP || '"'"' COMPLETE'"'"'; select * from M_BACKUP_CATALOG order by UTC_END_TIME desc; end;'


#!/bin/sh
rm /usr/sap/NDB/HDB00/backup/data/DB_NDB/COMPLETE*;
rm /usr/sap/NDB/HDB00/backup/log/DB_NDB/log* ;
/usr/sap/hdbclient/hdbsql -u SYSTEM  -p 'Kaiser$641' -o /tmp/resulta -d NDB 'do begin declare BKP nvarchar(30); execute immediate '"'"'BACKUP DATA USING FILE ('"'"''"'"'COMPLETE'"'"''"'"')'"'"'; select * from M_BACKUP_CATALOG order by UTC_END_TIME desc; select top 1 BACK
UP_ID into BKP from M_BACKUP_CATALOG where ENTRY_TYPE_NAME ='"'"'complete data backup'"'"' and STATE_NAME = '"'"'successful'"'"' order by UTC_END_TIME desc; execute immediate '"'"'BACKUP CATALOG DELETE ALL BEFORE BACKUP_ID '"'"' || :BKP || '"'"' COMPLETE'"'"'; select * f
rom M_BACKUP_CATALOG order by UTC_END_TIME desc; end;'
