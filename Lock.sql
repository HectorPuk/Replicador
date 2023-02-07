select * from M_RECORD_LOCKS;
select LOCK_OWNER_APPLICATION,LOCK_OWNER_APPLICATION_USER,LOCK_OWNER_APPLICATION_SOURCE, * from _SYS_STATISTICS.HOST_BLOCKED_TRANSACTIONS order by SERVER_TIMESTAMP desc;

--select * from audit_log where "APPLICATION_USER_NAME" = 'root' order by TIMESTAMP desc ;
--Como causar un lock ficticio 
--#1 Iniciar sesion con autocommit off 
--#2 select top 10 * from DSLPRODUC2.OINV for update;
--#3 Iniciar sesion con autocommit off 
--#4 select top 10 * from DSLPRODUC2.OINV for update; ESTA QUEDA BLOQUEADA!
--Podes ir a la consola de administracion, Performance, blocked transacion y lo ves.
--la tabla M_RECORD_LOCKS te muestra el estado instantaneo.
--_SYS_STATISTICS.HOST_BLOCKED_TRANSACTIONS te muestra el historico

--select * from audit_log order by TIMESTAMP desc limit 1000 offset 3000;

select 
AUDIT_POLICY_NAME, 
EVENT_STATUS,
APPLICATION_USER_NAME,
* from audit_log order by TIMESTAMP desc;

select 
LOCK_OWNER_APPLICATION,
LOCK_OWNER_APPLICATION_USER,
LOCK_OWNER_APPLICATION_SOURCE, 
WAITING_OBJECT_NAME,
WAITING_OBJECT_TYPE,
WAITING_SCHEMA_NAME,
BLOCKED_CONNECTION_ID,
BLOCKED_STATEMENT_STRING,
LOCK_OWNER_STATEMENT_STRING,
BLOCKED_APPLICATION,
BLOCKED_APPLICATION_USER,
BLOCKED_APPLICATION_SOURCE,
* 
from _SYS_STATISTICS.HOST_BLOCKED_TRANSACTIONS order by BLOCKED_TIME desc;

select count(*) from _SYS_STATISTICS.HOST_BLOCKED_TRANSACTIONS;
