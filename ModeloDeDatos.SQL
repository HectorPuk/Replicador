--Un empleado de venta (OSLP) puede o no ser Empleado de la empresa (OHEM) quien puede o NO ser usuario de SAP.
select OUSR."USER_CODE" "QuienLoCreo", OSLP.* from OSLP join OUSR on OSLP."UserSign" = OUSR."USERID";
--Quien creo (usuario SAP) al empleado de ventas. 
select U1."USER_CODE" "QuienLoCreo", U1."USER_CODE" "QuienLoModifico", OHEM.* from OHEM left join OUSR U1 on OHEM."UserSign" = U1."USERID" left join OUSR U2 on OHEM."UserSign2" = U2."USERID";
--quien creo y quien modifico el empleado de la empresa (OHEM) estoy obligado a unir con OUSR en dos ocasiones.
select OSLP."SlpName", OHEM."lastName" || ',' || OHEM."firstName" "NombreEnOHEM" from OSLP left join OHEM on OSLP."EmpID" = OHEM."empID";
--Cierta inconsistencia (o falta de informacion) del modelo porque te da a pensar que el EmpID de las OSLP apunta al EmpID de la OHEM
select OSLP."SlpName", OHEM."lastName" || ',' || OHEM."firstName" "NombreEnOHEM" from OSLP left join OHEM on OSLP."SlpCode" = OHEM."salesPrson";
--Este Query resuelve correctamente la vinculacion Vendedor con Empleado.
--XX left join YY es lo mismo que YY right join XX
