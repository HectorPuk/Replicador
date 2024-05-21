#!/bin/bash

PATH=$PATH:/hana/shared/NDB/exe/linuxx86_64/HDB_2.00.050.00.1592305219_7daf311088b6a86552a9b0152c9f178d9cfe2ac7
export LD_LIBRARY_PATH=/hana/shared/NDB/exe/linuxx86_64/HDB_2.00.050.00.1592305219_7daf311088b6a86552a9b0152c9f178d9cfe2ac7

#hdbbackupcheck -v /backup/SYSTEMDB/COMPLETESYSTEMDB20240516193001_databackup_0_1
for files in $(ls -t /backup/SYSTEMDB/COMPLE*) ; do hdbbackupcheck -v $files; done


