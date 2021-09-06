--Paso #1 Crear o Modificar una vista.
ALTER VIEW "SBODEMOAR"."TESTiew" AS SELECT * FROM OCRD where "CardName" like '%Max%' or "CardName" like '%L%';
--Paso #2 Testear lo que creamos o modificamos.
select * from "SBODEMOAR"."TESTiew";
--Paso #3 Cambiar a vista de desarrollo o Development y Crear o Usar un repositorio.
--Paso #4 Crear Vista de Calculo o Calculation View 