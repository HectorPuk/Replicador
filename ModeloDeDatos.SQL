--NOTA: Un empleado de venta (OSLP) puede o no ser Empleado de la empresa (OHEM) quien puede o NO ser usuario de SAP.
select OUSR."USER_CODE" "QuienLoCreo", OSLP.* from OSLP join OUSR on OSLP."UserSign" = OUSR."USERID";
--Quien creo (usuario SAP) al empleado de ventas? 
select U1."USER_CODE" "QuienLoCreo", U1."USER_CODE" "QuienLoModifico", OHEM.* from OHEM left join OUSR U1 on OHEM."UserSign" = U1."USERID" left join OUSR U2 on OHEM."UserSign2" = U2."USERID";
--quien creo y quien modifico el empleado de la empresa (OHEM)? estoy obligado a unir con OUSR en dos ocasiones, lo que me fuerza a usar los Alias U1 y U2.
select OSLP."SlpName", OHEM."lastName" || ',' || OHEM."firstName" "NombreEnOHEM" from OSLP left join OHEM on OSLP."EmpID" = OHEM."empID";
--Cierta inconsistencia (o falta de información) del modelo porque te da a pensar que el EmpID de las OSLP apunta al EmpID de la OHEM, pero el resultado no coincide con lo que muestra el sistema.
select OSLP."SlpName", OHEM."lastName" || ',' || OHEM."firstName" "NombreEnOHEM" from OSLP left join OHEM on OSLP."SlpCode" = OHEM."salesPrson";
--Este Query resuelve correctamente la vinculacion Vendedor con Empleado. 
--NOTAS DEL RECUERDO: XX left join YY es lo mismo que YY right join XX
--NOTAS DEL RECUERDO: por defecto, si no lo especifico es inner join
select  * from OHEM join OUSR on OHEM."userId" = OUSR."USERID";
--Todos los empleados que tengan usuario SAP. Aquellos que no tienen usuario SAP son exlcuidos por el inner join
select  * from OHEM right join OUSR on OHEM."userId" = OUSR."USERID";
--Todos los usarios SAP, tengan o no tengan registro de Empleado, efecto del right join
select  * from OHEM full outer join OUSR on OHEM."userId" = OUSR."USERID";
--Todos los usarios SAP (tenga o no empleado) y todos los Empleado (tengan o no usuario SAP9, efecto del full outer join
