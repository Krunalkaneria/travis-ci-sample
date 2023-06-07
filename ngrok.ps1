$ErrorActionPreference = "Stop"

# Download ngrok
Invoke-WebRequest https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-windows-amd64.zip -OutFile ngrok.zip

# Extract ngrok
Expand-Archive ngrok.zip

# Authenticate ngrok
$env:NGROK_AUTH_TOKEN = $Env:NGROK_AUTH_TOKEN
.\ngrok\ngrok.exe authtoken $env:NGROK_AUTH_TOKEN

# Enable TS
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name "fDenyTSConnections" -Value 0

# Enable Remote Desktop firewall rule
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"

# Enable user authentication for RDP-Tcp
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name "UserAuthentication" -Value 1

# Set password for 'runneradmin' user
$securePassword = ConvertTo-SecureString -AsPlainText "P@ssw0rd" -Force
Set-LocalUser -Name "runneradmin" -Password $securePassword

# Create tunnel
.\ngrok\ngrok.exe tcp 3389 -region in
