 Contar todos los procesos Service Layer
 
 ps -ef| awk '/httpd/ {print $2}' | wc -l
 
Contar los procesos /usr/sap/SAPBusinessOne/Common/httpd/bin/httpd

ps -ef| awk '/[/]usr[/]sap[/]SAPBusinessOne[/]Common[/]httpd[/]bin[/]httpd/ {print $2}' | wc -l

Contar los rotatelog 

ps -ef| awk '/[/]Common[/]httpd[/]bin[/]rotatelogs/ {print $2}' | wc -l

Obtener la memoria de los procesos de Service Layer

for PID in `ps -ef| awk '/[/]usr[/]sap[/]SAPBusinessOne[/]Common[/]httpd[/]bin[/]httpd/ {print $2}'`; do pmap -x $PID | tail -n 1 |  awk '/writable-private/ {print $3}'; done

Obtener memoria de los RotateLog

for PID in `ps -ef| awk '/[/]Common[/]httpd[/]bin[/]rotatelogs/ {print $2}'`; do pmap -x $PID | tail -n 1 |  awk '/writable-private/ {print $3}'; done



for PID in `ps -ef| awk '/[/]usr[/]sap[/]SAPBusinessOne[/]Common[/]httpd[/]bin[/]httpd/ {print $2}'`; do pmap -x $PID | tail -n 1 |  awk '/writable-private/ {print $3}' | cut -d 'K' -f 1; done |  awk '{s+=$1} END {printf "%.0f", s}'


for PID in `ps -ef| awk '/[/]usr[/]sap[/]SAPBusinessOne[/]Common[/]httpd[/]bin[/]httpd/ {print $2}'`; do pmap -x $PID | tail -n 1 |  awk '/writable-privrint $3}' | cut -d 'K' -f 1; done |  awk '{s+=$1} END {printf "%.0f", s}'
