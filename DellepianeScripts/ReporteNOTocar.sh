#!/bin/bash

SUBJECT="Reporte Dellepiane"
BODY0="$(whoami)" 
BODY1="$(df -h)"
BODY2="$(ls -lth /backup/backups/*/*/*)"
BODY3="$(ls -lth /backup/HANABACKUPS/DB_NDB)"
BODY4="$(ls -lth /backup/SYSTEMDB)"
BODY5="$(/usr/sap/NDB/home/script/DiagCheckBackupSYSTEMDB.sh)"
BODY6="$(/usr/sap/NDB/home/script/DiagCheckBackupDB_NDB.sh)"
#BODY7="$(/usr/sap/NDB/home/script/IntegrityCheckBackupSYSTEMDB.sh)"
BODY7 ="Test"

MESSAGE="Subject: $SUBJECT\n\nEjecutado por: $BODY0\n\n$BODY1\n\nFolders de Exports:\n\n$BODY2\n\nFolders Backup NDB Tenant:\n\n$BODY3\n\nFolders Backup SYSTEMDB:\n\n$BODY4\n\nDiagnóstico SYSTEMDB (Si encuentra los files necesarios):\n\n$BODY5\n\nDiagnóstico NDB Tenant (Si encuentra los files necesarios): \n\n$BODY6\n\nChequeo de Integridad backups en /backup/SYSTEMDB:\n\n$BODY7"

#(echo -e '$MESSAGE')
curl --url 'smtps://smtp.gmail.com:465' --ssl-reqd --mail-from 'from-email@gmail.com' --mail-rcpt 'hector.albino.puk@gmail.com' --mail-rcpt 'hector.puk@gmail.com' --user 'hector.albino.puk@gmail.com:chcsaobdtquhiusl' -T <(echo -e "$MESSAGE")


