select * from M_RECORD_LOCKS;
select LOCK_OWNER_APPLICATION,LOCK_OWNER_APPLICATION_USER,LOCK_OWNER_APPLICATION_SOURCE, * from _SYS_STATISTICS.HOST_BLOCKED_TRANSACTIONS order by SERVER_TIMESTAMP desc;

--select * from audit_log where "APPLICATION_USER_NAME" = 'root' order by TIMESTAMP desc ;

--select * from audit_log order by TIMESTAMP desc limit 1000 offset 3000;

select 
AUDIT_POLICY_NAME, 
EVENT_STATUS,
APPLICATION_USER_NAME,
* from audit_log order by TIMESTAMP desc;
