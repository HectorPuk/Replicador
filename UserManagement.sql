--CREA USUARIO PARA INSTALAR SBO

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
GRANT SELECT, EXECUTE, DELETE ON SCHEMA _SYS_REPO TO SBO;
/*
mkdir /tmp/exports
 mount -t nfs 192.168.1.231:/2TB /tmp/exports
 cd /tmp/exports/SAMBA2TB/HANALCM/SAP_HANA_DATABASE
 

The SBOCOMMON schema is created during the installation of SAP Business One Server, and the COMMON schema is
created during the installation of the analytics platform. If you use different SAP HANA users for installing
different components, you must pay special attention to grant the following object privileges, as appropriate:
SBOCOMMON schema: SELECT, INSERT, DELETE, UPDATE, EXECUTE, CREATE ANY, DROP (all grantable)
COMMON schema: SELECT, INSERT, DELETE, UPDATE, EXECUTE (all grantable)

 ./hdblcm --action=install --sid=NDB --components=all --sapadm_password=Kaiser$641 --password=Kaiser$641 --system_user_password=Kaiser$641 --batch

--en la siguiente URL explica lo que paso en el command line y cosas por ejemplo como indicarle si autostart durante la instalacion.
https://help.sap.com/docs/SAP_HANA_PLATFORM/2c1988d620e04368aa4103bf26f17727/1dbba6ac03054d7eb07c819aae47d095.html#loio7087da9be88f4ed09fee09f1f70f3a05

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
