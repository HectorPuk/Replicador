--A nivel linea de comando windows 
--   "plink -m Query1.txt plink-test" donde M es un archivo que le paso lo que tiene que ejecutar en Linux y el plink-test es una conexion definida en putty.
--   En putty puedo poner cual es el usuario que tiene que autoentrar cuando manejas certicados. Es decir alternativa a autenticacion password.
--   El contenido del archivo Query1.txt
--   echo "bash && hdbsql -u SYSTEM2 -p xxxxx \"select * from schemas\"" | sudo -i -u ndbadm 
--   echo "systemctl start sapb1servertools.service" | sudo -i
--   echo "bash && HDB start" | sudo -i -u ndbadm 
