current_time=$(date "+%Y%m%d%H%M%S") && /hana/shared/NDB/hdbclient/hdbsql -u SYSTEM2  -d SYSTEMDB  -p 'Golf0101*' -O /tmp/backupSYSTEMDBresult.$current_time \
        "do \
        begin \
        declare BKP nvarchar(30);
        execute immediate 'select ''COMPLETESYSTEMDB$current_time'' from dummy';
	execute immediate 'BACKUP DATA USING FILE (''COMPLETESYSTEMDB$current_time'')';
        select BACKUP_ID into BKP from M_BACKUP_CATALOG where ENTRY_TYPE_NAME ='complete data backup' and STATE_NAME = 'successful' order by UTC_END_TIME desc limit 1 offset 15;
        execute immediate 'BACKUP CATALOG DELETE ALL BEFORE BACKUP_ID ' || :BKP || ' COMPLETE';

	end;"

