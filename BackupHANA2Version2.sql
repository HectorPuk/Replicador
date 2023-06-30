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

*/
