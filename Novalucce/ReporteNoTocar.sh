#!/bin/bash

SUBJECT="Reporte Novalucce"
BODY0="$(whoami)"
BODY1="$(df -h)"
BODY2="$(/usr/sap/scripts/PurgaExportsMasDe15Dias.sh 2>&1)"
BODY3="$(ls -lth /hana/shared/backup_service/backups/*/*/*)"
BODY4="$(ls -lth /usr/sap/HDB/HDB00/backup/data/)"
BODY5="$(ls -lth /usr/sap/HDB/HDB00/backup/data/SYSTEMDB/)"
BODY6=$(du -sh 	/usr/sap/SAPBusinessOne/B1_LOG/ \
		/usr/sap/SAPBusinessOne/B1_SHF/ \
		/usr/sap/SAPBusinessOne/ServiceLayer/ \
		/usr/sap/SAPBusinessOne/Common/)
MESSAGE="Subject: $SUBJECT\n\nEjecutado por: $BODY0\n\n$BODY1\n\nResultado purgado de Exports:\n\n$BODY2\n\nInventario de Exports despues del purgado:\n\n$BODY3\n\nInventario Backups Tenant:\n\n$BODY4\n\nInventario Backups SYSTEMDB:\n\n$BODY5\n\nEspacios a controlar:\n\n$BODY6"
#(echo -e "$MESSAGE")
curl --url 'smtps://smtp.gmail.com:465' --ssl-reqd --mail-from 'from-email@gmail.com' --mail-rcpt 'hector.albino.puk@gmail.com' --mail-rcpt 'hector.puk@gmail.com' --user 'hector.albino.puk@gmail.com:chcsaobdtquhiusl' -T <(echo -e "$MESSAGE")
#
