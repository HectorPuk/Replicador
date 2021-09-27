En OUTB crea las tablas UDT
select * from OUTB where "TableName" like '%HECT%';
En CUFD crea los campos definidos por el usuario
select * from CUFD where "TableID" like '%HEC%';
select * from CUFD where "FieldID" like '%PLAN%';
select * from CUFD order by "TableID";
Ahora vamos por los UDO.
cursor_140292643846144_c3535.execute(''' Insert into "SBODEMOAR"."OUTB" ("TableName","Descr","TblNum","ObjectType","UsedInObj","LogTable","Archivable","ArchivDate") values( ?, ?, ?, ?, ?, ?, ?, ?) ''', (u'''HECTORFUERA''', None, 141, u'''1''', None, None, u'''N''', None))
cursor_140292643846144_c3535.execute(''' Insert into "SBODEMOAR"."OUTB" ("TableName","Descr","TblNum","ObjectType","UsedInObj","LogTable","Archivable","ArchivDate") values( ?, ?, ?, ?, ?, ?, ?, ?) ''', (u'''HECTORFUERA2''', None, 142, u'''2''', None, None, u'''N''', None))
Hasta aca solo crear las tablas.
A nivel hana solo se crearon dos tablas 
vamos por la registracion del objeto.

Una vez registrado se observan dos tablas nuebas
@AHECTORFUERA
@AHECTORFUERA2

cursor_140282019223552_c3535.execute(''' Insert into "SBODEMOAR"."OUDO" ("Code","Name","TableName","LogTable","TYPE","MngSeries","CanDelete","CanClose","CanCancel","ExtName","CanFind","CanYrTrnsf","CanDefForm","CanLog","OvrWrtDll","UIDFormat","CanArchive","MenuItem","MenuCapt","FatherMenu","Position","CanNewForm","IsRebuild","NewFormSrf","MenuUid","LstUpdDate","LstUpdTime","CanApprove","TemplateID") values( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) ''', (u'''FUERA''', u'''FUERA''', u'''HECTORFUERA''', u'''AHECTORFUERA''', u'''1''', u'''N''', u'''Y''', u'''N''', u'''Y''', None, u'''Y''', u'''N''', u'''N''', u'''Y''', u'''Y''', u'''Y''', u'''N''', u'''N''', u'''''', None, None, u'''Y''', u'''Y''', None, None, datetime(2021, 9, 26, 0, 0, 0, 0), 162129, u'''N''', None))
cursor_140277990862848_c3535.execute(''' Insert into "SBODEMOAR"."UDO1" ("Code","SonNum","TableName","LogName","SonName") values( ?, ?, ?, ?, ?) ''', (u'''FUERA''', 1, u'''HECTORFUERA2''', u'''AHECTORFUERA2''', u'''HECTORFUERA2'''))

cursor_140273670653952_c3535.execute(''' UPDATE "OUTB" T0 SET T0."LogTable" = ?  FROM "SBODEMOAR"."OUTB" T0 WHERE T0."TableName" = (?)   ''', (u'''AHECTORFUERA''', u'''HECTORFUERA'''))
cursor_140273670653952_c3535.execute(''' UPDATE "OUTB" T0 SET T0."LogTable" = ?  FROM "SBODEMOAR"."OUTB" T0 WHERE T0."TableName" = (?)   ''', (u'''AHECTORFUERA2''', u'''HECTORFUERA2'''))

La unica forma que encuentro de limitar el acceso via ServiceLayer es MOD_REWRITE



