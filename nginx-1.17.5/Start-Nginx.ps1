

# Start Nginx but without deamon, because otherwise the primary process ends immediately and the Docker container stops running
# Start-Process -FilePath "nginx.exe" -ArgumentList "-g daemon-off"
# Start-Process -FilePath "nginx.exe" -ArgumentList "-g 'daemon off;'"

write-host "Step 1"
Start-Process -FilePath "nginx.exe"


write-host "Step 2"

Wait-Event

write-host "Step 3"

# Read-Host -Prompt "Press Enter to continue"
