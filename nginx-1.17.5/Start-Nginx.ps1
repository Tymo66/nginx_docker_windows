# Start-Nginx.ps1
# Author: Tijmen van Voorthuijsen
# Date created: November 24, 2019
# Summary: modifies the Nginx config file for certificate files and then starts nginx.exe
# Description: this script is intended to run at start up of the docker container. It will first update the Nginx config file for 
#              user certificates, and then launch Nginx.
#              


[string]$nginx_cert_folder = ".\cert"                    # Folder in container where the certificate files are expected. This folder can be volume mounted to the host
[string]$nginx_config_file = ".\conf\nginx.conf"         # Default folder where the Nginx config files are located 


if (!(Test-Path $nginx_config_file))
{
    # A critical error: the Nginx config file is missing
    throw "nginx.config not found in folder .\conf, process aborted."
}


write-host "The cert folder is $nginx_cert_folder"
$cert_pem_file = Get-ChildItem -Path $nginx_cert_folder\*.pem
$cert_key_file = Get-ChildItem -Path $nginx_cert_folder\*.key

write-host "The pem file is $cert_pem_file"
write-host "The key file is $cert_key_file"

# Read-Host -Prompt "Press Enter to continue ..."

write-host "Step 1"
Start-Process -FilePath "nginx.exe"

write-host "Step 2"

Wait-Event

write-host "Step 3"


