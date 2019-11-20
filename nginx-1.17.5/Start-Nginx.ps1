


[string]$nginx_cert_folder = "C:\nginx\cert"
[string]$nginx_config_file = "C:\nginx\conf\nginx.conf"


if (!(Test-Path $nginx_config_file))
{
    Write-Warning "$nginx.config not found in folder C:\nginx\conf"
}

$cert_pem_file = Get-ChildItem -Path $nginx_cert_folder\*.pem
$cert_key_file = Get-ChildItem -Path $nginx_cert_folder\*.key

write-host "The cert folder is $nginx_cert_folder"
write-host "The pem file is $cert_pem_file"
write-host "The key file is $cert_key_file"

# Read-Host -Prompt "Press Enter to continue ..."

write-host "Step 1"
Start-Process -FilePath "nginx.exe"

write-host "Step 2"

Wait-Event

write-host "Step 3"


