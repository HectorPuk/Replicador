do
begin
    USING SQLSCRIPT_SYNC AS SYNCLIB;
    CALL SYNCLIB:SLEEP_SECONDS(10); 
declare statement varchar(200);
--select base64_decode('c2VsZWN0IFwiQ2FyZE5hbWVcIiwgXCJEb2NUb3RhbFwiIGZyb20gRFNMUFJPRFVDMi5PSU5W') into statement from dummy;
execute immediate base64_decode('c2V0IHNjaGVtYSBEU0xQUk9EVUMy');
execute immediate base64_decode('c2VsZWN0IGJhc2U2NF9lbmNvZGUoIkNhcmROYW1lIikgIlNpZ24iLCAiRG9jVG90YWwiICJWYWx1ZSIgZnJvbSBPUENI');
end;

--Cosas a tener en cuenta en el HANA Studio. Si le pones antes del DO un comentario NO LE GUSTA!!!.
--Tampoco le gusta entre el do y el begin !!!!
--TODO COMENTARIO DESPUES DE BEGIN!
