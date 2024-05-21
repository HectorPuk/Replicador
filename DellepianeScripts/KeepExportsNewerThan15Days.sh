for i in 20 19 18 17 16 15
do
	hoymenos="bck_"$(date -d"$i day ago" "+%Y%m%d")
	rm /backup/backups/NDB_10.0.30.52_30013/NDB/*/$hoymenos* -r
	echo $hoymenos
done

