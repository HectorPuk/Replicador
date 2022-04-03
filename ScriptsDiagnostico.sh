 Contar todos los procesos Service Layer
 
 ps -ef| awk '/httpd/ {print $2}' | wc -l
 
Contar los procesos /usr/sap/SAPBusinessOne/Common/httpd/bin/httpd

ps -ef| awk '/[/]usr[/]sap[/]SAPBusinessOne[/]Common[/]httpd[/]bin[/]httpd/ {print $2}' | wc -l

Obtener la memoria de los procesos de Service Layer

for PID in `ps -ef| awk '/[/]usr[/]sap[/]SAPBusinessOne[/]Common[/]httpd[/]bin[/]httpd/ {print $2}'`; do pmap -x $PID | tail -n 1 |  awk '/writable-private/ {print $3}'; done
