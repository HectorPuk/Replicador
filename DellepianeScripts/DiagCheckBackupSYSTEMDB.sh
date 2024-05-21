#!/bin/bash
PATH=$PATH:/hana/shared/NDB/exe/linuxx86_64/HDB_2.00.050.00.1592305219_7daf311088b6a86552a9b0152c9f178d9cfe2ac7
export LD_LIBRARY_PATH=/hana/shared/NDB/exe/linuxx86_64/HDB_2.00.050.00.1592305219_7daf311088b6a86552a9b0152c9f178d9cfe2ac7
#echo $LD_LIBRARY_PATH
#echo $PATH
hdbbackupdiag --check -f -v -d /usr/sap/NDB/HDB00/backup/log/SYSTEMDB/
