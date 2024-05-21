current_time=$(date "+%Y%m%d%H%M%S") && /hana/shared/HDB/hdbclient/hdbsql -u BACKUPER -d SYSTEMDB -p 'BackUPER$01' -O /tmp/backupHDBresult.$current_time \
        "do \
        begin \
        declare BKP nvarchar(30);
        execute immediate 'BACKUP DATA FOR HDB USING FILE (''COMPLETEHDB$current_time'')';
        select BACKUP_ID into BKP from SYS_DATABASES.M_BACKUP_CATALOG where DATABASE_NAME = 'HDB' and ENTRY_TYPE_NAME ='complete data backup' and STATE_NAME = 'successful' order by UTC_END_TIME desc limit 1 offset 9;
        execute immediate 'BACKUP CATALOG DELETE FOR HDB ALL BEFORE BACKUP_ID ' || :BKP || ' COMPLETE';
end;"

