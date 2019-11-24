

# Start Nginx but without deamon, because otherwise the primary process ends immediately and the Docker container stops running
# Start-Process -FilePath "nginx.exe" -ArgumentList "-g daemon off"

# Start-Process -FilePath "nginx.exe"


write-host "Hello world!"



# Read-Host -Prompt "Press Enter to continue"
