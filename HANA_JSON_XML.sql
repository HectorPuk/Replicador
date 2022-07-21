select JSON_VALUE('{"ver":1,"fecha":"2022-07-21","cuit":20165396112,"ptoVta":2,"tipoCmp":1,"nroCmp":3302,"importe":78650,"moneda":"PES","ctz":1,"tipoDocRec":80,"nroDocRec":30622324292,"tipoCodAut":"E","codAut":72292394452542}','$.cuit')
from dummy; 

SELECT * FROM
XMLTABLE('/doc/item' PASSING
'<doc>
  <item><id>10</id><name>Box</name></item>
  <item><id>20</id><tu></tu><name>Jar</name></item>
</doc>'
COLUMNS 
ID INT PATH 'id', 
NAME VARCHAR(20) PATH 'name'
) as XTABLE;

SELECT XMLEXTRACTVALUE(
   '<doc>
      <item><id>1</id><name>Box</name></item>
      <item><id>2</id><name>Jar</name></item>
   </doc>',
   '/doc/item[2]/name'
) FROM DUMMY;

SELECT XMLEXTRACT(
   '<doc>
      <item><id>1</id><name>Box</name></item>
      <item><id>2</id><name>Jar</name></item>
   </doc>',
   '/doc/item[2]/name'
) FROM DUMMY;

select 22 "AA", 23 "BB" from dummy for XML;
select 22 "AA", 23 "BB" from dummy for JSON;
