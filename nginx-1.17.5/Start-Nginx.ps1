# Start-Nginx.ps1
# Author        : Tijmen van Voorthuijsen
# Date created  : November 24, 2019
# Summary       : Applies user certificates to Nginx config file and then starts nginx.exe.
# Description   : This script is intended to run at start up of the docker container. It will first update the Nginx config file for 
#                 user certificates, and then launch Nginx.
#              
param( 
    # The name of the server or IP address, for example 'mycompany.com' or '192.168.1.2'. When not specified, it uses the server name specified in the nginx.config file
    [Parameter(Mandatory=$False)]
    [string]$ServerName
    )

# A. Update nginx.config for SSL certificates and server name
$ScriptToRun= $PSScriptRoot+"\ApplyCertificates-NginxConfig.ps1"
& $ScriptToRun -ServerName $ServerName

# B. Start Nginx and wait indefitely, this prevents the Docker container from stopping, the PowerShell script is the main process.
write-host "Starting nginx.exe ..."
& '.\nginx.exe' "-g daemon off;"

write-host "Nginx has ended."

