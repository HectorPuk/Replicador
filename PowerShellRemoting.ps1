#https://social.technet.microsoft.com/wiki/contents/articles/37081.powershell-remoting-step-by-step.aspx

Get-Item –Path WSMan:\localhost\Client\TrustedHosts

#Observo quienes pueden hacer remoting  

enable-psremoting -f 
# En ambos lados

Set-Item -Path WSMan:\localhost\Client\TrustedHosts -Value "172.21.51.8"
#En ambos lados

Todavia sigo fracasando. Instalar el SSH server llevo 1 min y listo.
https://docs.microsoft.com/en-us/windows-server/administration/openssh/openssh_install_firstuse

