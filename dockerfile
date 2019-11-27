# Dockerfile without extension with definition for creating Windows Server Core image with Nginx
# Make sure that in same location with Dockerfile you have nginx-1.17.0 folder which contains all files needed for Nginx deployment 
# Use command: 'docker build -t dsa_noldus_windowsservercore_nginx:1.0 .' for building image based on this Dockerfile
# Execute command in Powershell from the same location where Dockerfile and nginx-1.17.0 folder are

# Indicates that the windowsservercore image will be used as the base image.
FROM mcr.microsoft.com/windows/servercore:ltsc2019

# Metadata indicating an image maintainer.
LABEL maintainer="DSAH1Team@Noldus.NL"

# Copies Nginx server files to the C: disk on the docker image
COPY  nginx-1.17.5 C:/Nginx

# Defines working directory, where commands will be executed from entrypoint
WORKDIR C:/Nginx

# Exposes port 80
EXPOSE 80

# Start PowerShell script, optionally passing in the server name or IP address
ENTRYPOINT powershell c:\nginx\Start-Nginx.ps1 -ServerName %SERVER_NAME%

