--https://www.youtube.com/watch?v=h09XRxhpNXI
--Recordar que necesitas abrir la vista de debugging via Windows->Perspective->Open Perspective->Debug
--Si no lo tenes, aprentar el icono de Bug e ir a Debug Configuration
--Luego recordar marcar "Select a connection after initiating the debugger" para que te pida la conexion que queres debuggear remotamente.
--Generalmente frente a dos sesiones de SAP B1 el numero mas alto es la connexion para debuggear.

-- La forma de manejar esta reverenda PORONGA es desde el SQL de SAP B1 ejecutar
begin
execute immediate 'GRANT ATTACH DEBUGGER to SYSTEM';
end;
