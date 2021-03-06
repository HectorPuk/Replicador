-- Capture Filters .... https://wiki.wireshark.org/CaptureFilters
-- Ejemplo de un CAPTURE FILTER: dst port 30015 and (host 192.168.1.227 or host 192.168.1.228)
--Asi crea el usuario que va a usar SAP B1.
--CREATE USER B1_44534C50524F44554332_RW PASSWORD "i%+M<^+b/pPw%i8y803Q29fLR4GX1"
--La creacion se realiza despues del import y cuando alguien trata de conectarse.

--Esto viene de un Trace cuando se hace un import y apentas tratas de conectarte con la compañia
--SAP tiene que estar levantado en el momento del import. 
--El usuario NO debe existir. Recorda que SAP B1 crea un usuario por cada empresa.
--La password no expira.
--cursor_140219873182720_c9535.execute(''' INSERT INTO COMPANYDBCREDENTIALS VALUES(?,?,?,?,?,?) ''', (81441, 81365, u'''B1_44534C50524F44554332_RW''', u'''ocOq4F6mJJCMP2duDNYwhzvSsct7a1UssW4R5hUeuiYbXEpY7dHHAw==''', datetime(2021, 8, 16, 4, 16, 15, 401000), '''0'''))
--Podes pensar hacer un export de la tabla COMPANYDBCRENDTIALS y luego recuperarla.
