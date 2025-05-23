--CREAR USUARIO PARA NAGIOS
HACERLO EN CADA TENANT y en SYSTEMDB

CREATE USER NAGIOS PASSWORD NAGIOSz01 NO FORCE_FIRST_PASSWORD_CHANGE;
ALTER USER NAGIOS DISABLE PASSWORD LIFETIME;
GRANT MONITORING TO NAGIOS;




-- CREAR USUARIO PARA BACKUPS.
-- OJO QUE ME FALLO PORQUE NO TENIA DATABASE ADMIN

CREATE USER NAGIOS PASSWORD NAGIOS.01 NO FORCE_FIRST_PASSWORD_CHANGE;
ALTER USER B1SA DISABLE PASSWORD LIFETIME;
GRANT 
	CATALOG READ,
	IMPORT,
	EXPORT,
	LOG ADMIN,
	DATABASE ADMIN,
	BACKUP ADMIN,
	BACKUP OPERATOR
	TO BACKUPER WITH ADMIN OPTION;

GRANT DATABASE BACKUP ADMIN TO BACKUPER; 

Ojo que por la siguiente linea me volvi loco buscando y el grant es como esta en la linea superior....

FOR NDB DATABASE BACKUP ADMIN or DATABASE ADMIN


--CREA USUARIO PARA INSTALAR SBO
/*
OJOOOOOO!!!!!!!!!!!!!!!!!!!!!!!!!

Passwords containing special characters other than underscore must be en­closed in double quotes ("). The SAP HANA studio does this automatically.
When a password is enclosed in double quotes ("), any Unicode characters can be used.

*/ 

CREATE USER SBO PASSWORD Kaiser$641 NO FORCE_FIRST_PASSWORD_CHANGE;
ALTER USER SBO DISABLE PASSWORD LIFETIME;
GRANT PUBLIC TO SBO;
GRANT CONTENT_ADMIN TO SBO WITH ADMIN OPTION;
GRANT AFLPM_CREATOR_ERASER_EXECUTE TO SBO WITH ADMIN OPTION;
GRANT 
	CREATE SCHEMA,
	USER ADMIN,
	ROLE ADMIN,
	CATALOG READ,
	IMPORT,
	EXPORT,
	INIFILE ADMIN,
	LOG ADMIN,
	BACKUP ADMIN,
	BACKUP OPERATOR
	TO SBO WITH ADMIN OPTION;
GRANT CREATE ANY, SELECT ON SCHEMA SYSTEM TO SBO;
GRANT SELECT, EXECUTE, DELETE ON SCHEMA _SYS_REPO TO SBO; -- With Grant Option? Ojo que me fallo cuando queria instalar las vistas analiticas.... Marzo 2025

/* Asi tuve que darle el GRANT en la maquina de IVANA KRIMAX para lograr que corriera la vista analitica 

GRANT SELECT, EXECUTE, DELETE ON SCHEMA _SYS_BIC TO B1_53424F44454D4F4152_RW with grant option;

/* 

En est tabla inserte una vista para que pueda ser accesible desde Service Layer
Es un gran dedazo sobre Semantic Views.

update "SBODEMOAR"."HMM1" set "SLExpose" = 'Y' where "LineNum" = 256

/*
BACKUPS DEL ORTO

RECOVER DATA  USING FILE ('/tmp/exports/SAMBA2TB/BackupIVANA/COMPLETESYSTEMDB20231121125501')  CLEAR LOG

RECOVER DATA FOR NDB  USING FILE ('/tmp/exports/SAMBA2TB/BackupIVANA/COMPLETENDB20231121125901')  CLEAR LOG
Si trato de ejecutar el recover de NDB me pide que detenga la base con el Alter de abajo. Esto es un avance frente a las pelotudces que me venia enfrentando.
ALTER SYSTEM START/STOP DATABASE Statement (Tenant Database Management)

Esto lo que trata de hacer es recuperar el SYSTEMDB al ultimo estado disponible.

HDBSettings.sh recoverSys.py 

--RECOVER POINT IN TIME

Fijate que los backup y log los deje en folders separados.

RECOVER DATABASE FOR NDB 
UNTIL TIMESTAMP '2023-12-05 05:00:00' 
CLEAR LOG 
USING LOG PATH ('/usr/sap/NDB/HDB00/backup/log/DB_NDB/old') 
USING DATA PATH ('/usr/sap/NDB/HDB00/backup/data/DB_NDB/old/') 
USING BACKUP_ID 1701749020083; 

IMPORTANTE!!!!

RECOVER DATABASE FOR NDB 
--Use dos horarios para ver que los BP creados mas tarde no aparecian cuando hacya in REPLAY hasta cierta hora....
--UNTIL TIMESTAMP '2023-12-05 11:00:00' 
UNTIL TIMESTAMP '2023-12-05 5:00:00' 
CLEAR LOG 
--si no le digo donde esta el catalogo trata de usar el catalogo que ya tiene en la base.
USING CATALOG PATH ('/usr/sap/NDB/HDB00/backup/log/DB_NDB/old')
USING LOG PATH ('/usr/sap/NDB/HDB00/backup/log/DB_NDB/old') 
USING DATA PATH ('/usr/sap/NDB/HDB00/backup/data/DB_NDB/old/') 
USING BACKUP_ID 1701749020083; 



--RECOVER POINT IN TIME



--TENANT
CREATE DATABASE TESTDB SYSTEM USER PASSWORD Initial1;

--TENANT




mkdir /tmp/exports
 mount -t nfs 192.168.1.231:/2TB /tmp/exports
 cd /tmp/exports/SAMBA2TB/HANALCM2308PL12/SAP_HANA_DATABASE
 
 cd /tmp/exports/SAMBA2TB/HANALCM2208PL09/SAP_HANA_DATABASE
 

The SBOCOMMON schema is created during the installation of SAP Business One Server, and the COMMON schema is
created during the installation of the analytics platform. If you use different SAP HANA users for installing
different components, you must pay special attention to grant the following object privileges, as appropriate:
SBOCOMMON schema: SELECT, INSERT, DELETE, UPDATE, EXECUTE, CREATE ANY, DROP (all grantable)
COMMON schema: SELECT, INSERT, DELETE, UPDATE, EXECUTE (all grantable)

 ./hdblcm --action=install --sid=NDB --components=all --sapadm_password=Kaiser$641 --password=Kaiser$641 --system_user_password=Kaiser$641 --batch
 
 PARA 2208!!!
 ./hdblcm --action=install --sid=NDB --components=all --sapadm_password=Kaiser641 --password=Kaiser641 --system_user_password=Kaiser641 --batch

OJO TUVE PROBLEMA POR NO ESCAPAR LOS $

Me tiro en la segunda corrida que no puede usar la password para el SAP Agent supongo que es porque el hdbunist no lo desinstala 
ver nota https://me.sap.com/notes/0002512232
Segun la nota en linux con  passwd sapadm es suficiente


Pruebo con 
 /tmp/exports/SAMBA2TB/HANALCM2308PL12/SAP_HANA_DATABASE/hdblcm --action=install --sid=NDB --components=all --sapadm_password=Kaiser\$641 --password=Kaiser\$641 --system_user_password=Kaiser\$641 --batch --autostart=1

Pruebo con ignorar maxima memoria

 /tmp/exports/SAMBA2TB/HANALCM2308PL12/SAP_HANA_DATABASE/hdblcm --action=install --sid=NDB --components=all --sapadm_password=Kaiser\$641 --password=Kaiser\$641 --system_user_password=Kaiser\$641 --batch --autostart=1 --ignore=check_min_mem

ACA TENES LAS COMMAND LINE OPTIONS PARA EL HDBLCM!!

https://help.sap.com/docs/SAP_HANA_PLATFORM/2c1988d620e04368aa4103bf26f17727/202717d5c58a4c6cb74d0d8aef4d8efe.html

 ./hdblcm --action=install --sid=NDB --components=all --sapadm_password=Ivana\$641 --password=Ivana\$641 --system_user_password=Ivana\$641 --batch

--en la siguiente URL explica lo que paso en el command line y cosas por ejemplo como indicarle si autostart durante la instalacion.
https://help.sap.com/docs/SAP_HANA_PLATFORM/2c1988d620e04368aa4103bf26f17727/1dbba6ac03054d7eb07c819aae47d095.html#loio7087da9be88f4ed09fee09f1f70f3a05

Cree el usuario SBO y instalo sap B1.

GRANT ALL PRIVILEGES ON SCHEMA SBODEMOAR TO SBO;
Esto de arriba parece no tener sentido, el lugar de hacer el import con SYSTEM y grantear a SBO, 
HACER EL IMPORT CON SBO!!!!

Validos - Start/Restart/STOP

systemctl restart b1s
systemctl restart sldagent.service
systemctl stop sapb1servertools.service
systemctl stop b1s

?? systemctl stop apparmor.service

/*

./sysbench cpu run --threads=12 --time=300
Time in sec.
https://www.alibabacloud.com/blog/testing-io-performance-with-sysbench_594709

*/


--Crea un usuario basico para que pueda correr un Crystal

CREATE USER OPERADOR2 PASSWORD Password02$ NO FORCE_FIRST_PASSWORD_CHANGE;
ALTER USER OPERADOR2 DISABLE PASSWORD LIFETIME;
GRANT SELECT on schema "SBODEMOAR2" to OPERADOR2; 
GRANT EXECUTE on schema "SBODEMOAR2" to OPERADOR2; 
--Crea un usuario basico para que pueda correr un Crystal

--Si le quiero revocar un permiso
REVOKE EXECUTE on schema "SBODEMOAR2" from OPERADOR2; 

Si me da un error en crystal, hago copy/paste de la ventana que me da el GUID (no parece que copia pero copia) lo pego en un notepad++ y anduvo

CALL SYS.GET_INSUFFICIENT_PRIVILEGE_ERROR_DETAILS ('B872FA4FD1EA7244A26105980C82F43A', ?)




CREATE USER TEST01 PASSWORD Password01$;

--Sintaxis completa: https://help.sap.com/viewer/4fe29514fd584807ac9f2a04f6754767/2.0.04/en-US/20d5ddb075191014b594f7b11ff08ee2.html

ALTER USER TEST01 PASSWORD Password01$ NO FORCE_FIRST_PASSWORD_CHANGE; ¿Por que falla? Ayuda: Ver slide anterior.

ALTER USER TEST01 RESET CONNECT ATTEMPTS; Reiniciar conteo intentos fallidos.
ALTER USER TEST01 ACTIVATE USER NOW; Activar si fue desactivado.
-- Sintaxis completa: https://help.sap.com/viewer/4fe29514fd584807ac9f2a04f6754767/1.0.12/en-US/20d3459f75191014a7bbeb670bad8850.html

ALTER USER SYSTEM2 DISABLE PASSWORD LIFETIME; -- Evitar que la password caduque.

ALTER USER TEST01 DROP CONNECT ATTEMPTS

--It does not reset the current count of invalid connect attempts and therefore does not allow the user to connect immediately.
--This option can be used by the user themselves or by a user with the USER ADMIN privilege.
--To view the count of invalid connection attempts that have occurred, see the INVALID_CONNECT_ATTEMPTS system view.

GRANT USER ADMIN TO TEST01; 

Syntax Completa: 	https://help.sap.com/viewer/4fe29514fd584807ac9f2a04f6754767/2.0.03/en-US/20f674e1751910148a8b990d33efbdc5.html

ALTER SYSTEM ALTER CONFIGURATION CUIDADO !!! impacta en la configuracion del manejadro de base de datos.

Syntaxis Completa: https://help.sap.com/viewer/4fe29514fd584807ac9f2a04f6754767/2.0.01/en-US/20d08a5b751910148145dbc016c826a4.html

SELECT USER_NAME, USER_DEACTIVATED, DEACTIVATION_TIME, INVALID_CONNECT_ATTEMPTS, VALID_UNTIL FROM "SYS"."USERS" WHERE USER_NAME='TEST01';
SELECT DISTINCT object_type, privilege, grantee FROM SYS.GRANTED_PRIVILEGES where privilege = 'USER ADMIN';
