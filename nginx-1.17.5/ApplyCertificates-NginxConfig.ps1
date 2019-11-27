# ApplyCertificates-NginxConfig.ps1
# Author        : Tijmen van Voorthuijsen
# Date created  : November 24, 2019
# Summary       : Modifies the Nginx config file for SSL certificate files.
# Description   : This script is intended to run inside a Docker container that hosts Nginx, but can also be run outside the container. 
#                 It will modify the Nginx config file for the PEM and KEY certificate files and the server name.
#              
param( 
    # The name of the server or IP address, for example 'mycompany.com' or '192.168.1.2'. When not specified, it uses the server name specified in the nginx.config file
    [Parameter(Mandatory=$False)]
    [string]$ServerName
    )

[string]$nginx_cert_folder   = ".\cert"                    # Folder where the user certificate files are expected. This folder can be volume mounted to the host
[string]$nginx_config_file   = ".\conf\nginx.conf"         # Default folder where the Nginx config files are located 


if (!(Test-Path $nginx_config_file))
{
    # A critical error: the Nginx config file is missing
    throw "nginx.config not found in folder .\conf, process aborted."
}

# Replace certificate file references in nginx.config file
$cert_pem_file = Get-ChildItem -Path $nginx_cert_folder\*.pem
$cert_key_file = Get-ChildItem -Path $nginx_cert_folder\*.key
if ($cert_pem_file -and $cert_key_file)
{
    write-host "The pem file is $cert_pem_file"
    write-host "The key file is $cert_key_file"

    # Replace for the right certificate files (*.pem, *.key)
    ((Get-Content -path $nginx_config_file -Raw) -replace 'noldusdemo.cert.pem', $cert_pem_file) | Set-Content -Path $nginx_config_file
    ((Get-Content -path $nginx_config_file -Raw) -replace 'noldusdemo.cert.key', $cert_key_file) | Set-Content -Path $nginx_config_file

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
