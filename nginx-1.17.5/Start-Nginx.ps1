# Start-Nginx.ps1
# Author: Tijmen van Voorthuijsen
# Date created: November 24, 2019
# Summary: modifies the Nginx config file for certificate files and then starts nginx.exe
# Description: this script is intended to run at start up of the docker container. It will first update the Nginx config file for 
#              user certificates, and then launch Nginx.
#              
param( 
    [Parameter(Mandatory=$False)]
    [string]$ServerName
    )

[string]$nginx_cert_folder   = ".\cert"                    # Folder in container where the certificate files are expected. This folder can be volume mounted to the host
[string]$nginx_config_file   = ".\conf\nginx.conf"         # Default folder where the Nginx config files are located 


if (!(Test-Path $nginx_config_file))
{
    # A critical error: the Nginx config file is missing
    throw "nginx.config not found in folder .\conf, process aborted."
}

# Replace certificate files in nginx.config file
$cert_pem_file = Get-ChildItem -Path $nginx_cert_folder\*.pem
$cert_key_file = Get-ChildItem -Path $nginx_cert_folder\*.key
if ($cert_pem_file -and $cert_key_file)
{
    write-host "The pem file is $cert_pem_file"
    write-host "The key file is $cert_key_file"

    # Replace for the right certificate files (*.pem, *.key)
    ((Get-Content -path $nginx_config_file -Raw) -replace 'noldusdefault.cert.pem', $cert_pem_file) | Set-Content -Path $nginx_config_file
    ((Get-Content -path $nginx_config_file -Raw) -replace 'noldusdefault.cert.key', $cert_key_file) | Set-Content -Path $nginx_config_file

} else {
    # The file nginx.config will define the default certificates that are build into the Docker image.

    write-host "No certificates found in .\cert folder, defaulting to the certificate defined in the nginx.config file."
}

# Replace server name in nginx.config file
if ($ServerName -and 
    $ServerName -ne "%SERVER_NAME%"
) { 
    write-host "The server name is $ServerName"

    # Replace for the server name
    ((Get-Content -path $nginx_config_file -Raw) -replace '127.0.0.1', $ServerName) | Set-Content -Path $nginx_config_file

} else {
    # The file nginx.config will define the default server name or address that is build into the Docker image.

    write-host "Parameter ServerName was not specified, defaulting to the server name or address defined in the nginx.config file."
}

write-host "Starting nginx.exe ..."
& '.\nginx.exe' "-g daemon off;"

# Wait indefitely, this prevents the Docker container from stopping, the PowerShell script is the main process.

write-host "Nginx has ended."


