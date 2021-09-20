--Paso #1 Crear o Modificar una vista.
--CREATE VIEW "SBODEMOAR"."TESTView" AS SELECT * FROM OCRD where "CardName" like '%Max%' or "CardName" like '%L%';
ALTER VIEW "SBODEMOAR"."TESTView" AS SELECT * FROM "SBODEMOAR".OCRD where "CardName" like '%Max%' or "CardName" like '%L%';
--Paso #2 Testear lo que creamos o modificamos.
select * from "SBODEMOAR"."TESTView";
--Paso #3 Cambiar a vista de desarrollo o Development y Crear o Usar un repositorio. TestDellepiane por ejemplo.
--Nota 1: Tambien se puede crear desde el Web IDE https://192.168.1.233:4300/sap/hana/ide/editor/index.html
--Paso #4 Crear Vista de Calculo o Calculation View, PrimerCalculationViewQuery por ejemplo
--Paso #5 Agregar la vista del catalogo como agregation
--Paso #6 Marcar los campos que quiero sean publicados.
--Paso #7 Activar.
--Nota es posible que al tratar de activar te de un error.
--Error: SAP DBTech JDBC: [258]: insufficient privilege: Detailed info for this error can be found with guid 'A325A8C2280AD84EBE221EBCBCDDBF44'
--Entonces usa para ver mas detalles CALL SYS.GET_INSUFFICIENT_PRIVILEGE_ERROR_DETAILS ('A325A8C2280AD84EBE221EBCBCDDBF44', ?)
--Por ejemplo te puede dar IS_MISSING_ANALYTIC_PRIVILEDGE.
--Paso #8 Testear.
--Paso #9 Testear con Excel, por ejemplo.
