#/bin/bash
for i in {90..15}
do
        hoymenos="bck_"$(date -d"$i day ago" "+%Y%m%d")
	comandoaejecutar="rm /hana/shared/backup_service/backups/HDB_hanadb_30013/HDB/*/$hoymenos* -r"
	echo "Se ejecutara $comandoaejecutar"
	test="ls -l"
	$comandoaejecutar
	#rm /hana/shared/backup_service/backups/HDB_hanadb_30013/HDB/*/$hoymenos* -r
done
