

write-host "Inside Update-NginxConfig.ps1"

[string]$nginx_cert_folder = "C:\nginx-1.17.5\cert"
[string]$nginx_config = "C:\nginx-1.17.5\conf\nginx.conf"


if (!(Test-Path $nginx_config))
{
    Write-Warning "$nginx.config not found in folder C:\nginx-1.17.5\conf"
}

$cert_pem_file = Get-ChildItem | Where-Object -Match "*.pem"
$cert_key_file = Get-ChildItem | Where-Object -Match "*.key"

[string]$nginx_config_content = ""
$nginx_config_content = Get-Content -path $nginx_config -Raw

$nginx_config_content -replace 'noldusdemo.cert.pem', 'Tijmen' | Set-Content -Path $nginx_config

