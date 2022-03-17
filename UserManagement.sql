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
