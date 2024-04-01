CREATE or replace PROCEDURE PASTA
(
)
LANGUAGE SQLSCRIPT
AS

begin
begin
	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN END;
	select 1/0 from dummy;
	select 'POR ACA NO PASA NUNCA' from dummy;
end;
select 'Aca salio del bloque de ejecucion 1' from dummy;

begin
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION BEGIN END;
	select 1/0 from dummy;
	select 'Aca estoy en el bloque de ejecucion y continuo despues de la excepcion porque tengo un continue handler' from dummy;
	--Nota de color:
	--	por alguna razon el RETURN no funciona en esta situacion y devuelve
	--	SAP DBTech JDBC: [2]: general error: Operation is not set; $condition$=op_
	--	Por esta razon esta comentado jeje
	--return;
end;

end;