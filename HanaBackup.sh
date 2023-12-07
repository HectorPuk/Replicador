/usr/sap/HDB/home/scripts/backup.sh --config-file=/usr/sap/HDB/home/scripts/backup_config_HDB00.cfg -q -p --retention=3
sleep 5
/usr/sap/HDB/home/scripts/backup.sh --config-file=/usr/sap/HDB/home/scripts/backup_config_HDB00.cfg --retention=3 -cd -od -cl


