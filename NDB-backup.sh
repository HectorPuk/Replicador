#!/bin/sh
rm /usr/sap/NDB/HDB00/backup/data/DB_NDB/COMPLETE*; 
rm /usr/sap/NDB/HDB00/backup/log/DB_NDB/log* ; 
/usr/sap/hdbclient/hdbsql -u SYSTEM  -p 'Kaiser$641' -o /tmp/resulta -d NDB 'do begin declare BKP nvarchar(30); execute immediate '"'"'BACKUP DATA USING FILE ('"'"''"'"'COMPLETE'"'"''"'"')'"'"'; select * from M_BACKUP_CATALOG order by UTC_END_TIME desc; select top 1 BACKUP_ID into BKP from M_BACKUP_CATALOG where ENTRY_TYPE_NAME ='"'"'complete data backup'"'"' and STATE_NAME = '"'"'successful'"'"' order by UTC_END_TIME desc; execute immediate '"'"'BACKUP CATALOG DELETE ALL BEFORE BACKUP_ID '"'"' || :BKP || '"'"' COMPLETE'"'"'; select * from M_BACKUP_CATALOG order by UTC_END_TIME desc; end;'

