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

$cert_pem_file = Get-ChildItem -Path $nginx_cert_folder\*.pem
$cert_key_file = Get-ChildItem -Path $nginx_cert_folder\*.key
if ($cert_pem_file -and $cert_key_file)
{
    write-host "The pem file is $cert_pem_file"
    write-host "The key file is $cert_key_file"

    ((Get-Content -path $nginx_config_file -Raw) -replace 'noldusdefault.cert.pem',$cert_pem_file) | Set-Content -Path $nginx_config_file
    ((Get-Content -path $nginx_config_file -Raw) -replace 'noldusdefault.cert.key',$cert_key_file) | Set-Content -Path $nginx_config_file


    # [string]$nginx_config_content = ""
    # $nginx_config_content = Get-Content -path $nginx_config_file -Raw
    
    # $nginx_config_content -replace 'noldusdefault.cert.pem', $cert_pem_file | Set-Content -Path $nginx_config_file
    # $nginx_config_content -replace 'noldusdefault.cert.key', $cert_key_file | Set-Content -Path $nginx_config_file

} else {
    write-host "No certificates found in .\cert folder, using default certificates as defined in the nginx.config file."

    # The file nginx.config will define the default certificates that are build into the Docker image.
}

write-host "Starting nginx.exe ..."
& '.\nginx.exe' "-g daemon off;"

# Wait indefitely, this prevents the Docker container from stopping, the PowerShell script is the main process.

write-host "Nginx has ended."


