 more backupSYSTEMDB.sh
current_time=$(date "+%Y%m%d%H%M%S") && /hana/shared/NDB/hdbclient/hdbsql -u BACKUPER  -d SYSTEMDB  -p 'Ivana$641' -O /tmp/backupSYSTEMDBresult.$current_time \
        "do \
        begin \
        declare BKP nvarchar(30);
        execute immediate 'BACKUP DATA USING FILE (''COMPLETESYSTEMDB$current_time'')';
        select BACKUP_ID into BKP from M_BACKUP_CATALOG where ENTRY_TYPE_NAME ='complete data backup' and STATE_NAME = 'successful' order by UTC_END_TIME desc limit 1 offset
 1;
        execute immediate 'BACKUP CATALOG DELETE ALL BEFORE BACKUP_ID ' || :BKP || ' COMPLETE';
end;"

hanabone:~ # more backupNDB.sh
current_time=$(date "+%Y%m%d%H%M%S") && /hana/shared/NDB/hdbclient/hdbsql -u BACKUPER -d SYSTEMDB -p 'Ivana$641' -O /tmp/backupNDBresult.$current_time \
        "do \
        begin \
        declare BKP nvarchar(30);
        execute immediate 'BACKUP DATA FOR NDB USING FILE (''COMPLETENDB$current_time'')';
        select BACKUP_ID into BKP from SYS_DATABASES.M_BACKUP_CATALOG where DATABASE_NAME = 'NDB' and ENTRY_TYPE_NAME ='complete data backup' and STATE_NAME = 'successful' o
rder by UTC_END_TIME desc limit 1 offset 1;
        execute immediate 'BACKUP CATALOG DELETE FOR NDB ALL BEFORE BACKUP_ID ' || :BKP || ' COMPLETE';
end;"

hanabone:~ #






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


CRONTAB ejecutar a 12:55 y 22:55

55 12,22 * * * /root/backupSYSTEMDB.sh
55 12,22 * * * /root/backupNDB.sh

backupSYSTEMDB.sh

current_time=$(date "+%Y%m%d%H%M%S") && /hana/shared/NDB/hdbclient/hdbsql -u SYSTEM  -d SYSTEMDB  -p 'Ivana$641' -O /tmp/backupSYSTEMDBresult.$current_time \
        "do \
        begin \
        declare BKP nvarchar(30);
        execute immediate 'BACKUP DATA USING FILE (''COMPLETESYSTEMDB$current_time'')';
        select BACKUP_ID into BKP from M_BACKUP_CATALOG where ENTRY_TYPE_NAME ='complete data backup' and STATE_NAME = 'successful' order by UTC_END_TIME desc limit 1 offset 2;
        execute immediate 'BACKUP CATALOG DELETE ALL BEFORE BACKUP_ID ' || :BKP || ' COMPLETE';
end;"

~




backupNDB.sh

current_time=$(date "+%Y%m%d%H%M%S") && /hana/shared/NDB/hdbclient/hdbsql -u SYSTEM  -d NDB -p 'Ivana$641' -O /tmp/backupNDBresult.$current_time \
        "do \
        begin \
        declare BKP nvarchar(30);
        execute immediate 'BACKUP DATA USING FILE (''COMPLETENDB$current_time'')';
        select BACKUP_ID into BKP from M_BACKUP_CATALOG where ENTRY_TYPE_NAME ='complete data backup' and STATE_NAME = 'successful' order by UTC_END_TIME desc limit 1 offset 2;
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
