# Set registry for AVD environment
New-Item -Path "HKLM:\SOFTWARE\Microsoft\Teams" -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Teams" -Name IsWVDEnvironment -PropertyType DWORD -Value 1 -Force

# Set download URLs
$teamsUrl = "https://go.microsoft.com/fwlink/?linkid=2196106" # New Teams MSIX (x64)
$RDWebRTCUrl = "https://aka.ms/msrdcwebrtcsvc/msi"
$teamsBootstrapperUrl = "https://go.microsoft.com/fwlink/?linkid=2243204&clcid=0x409" # Teams bootstrapper (x64)
$teamsInstaller = "$env:TEMP\MSTeams-x64.msix"
$RDWebRTCInstaller = "$env:TEMP\MsRdcWebRTCSvc_HostSetup_x64.msi"
$teamsBootstrapperInstaller = "$env:TEMP\teamsbootstrapper.exe"

# Download Remote Desktop WebRTC Redirector Service
Write-Host "Downloading Remote Desktop WebRTC Redirector Service..."
Invoke-WebRequest -Uri $RDWebRTCUrl -OutFile $RDWebRTCInstaller

# Download Teams MSIX installer
Write-Host "Downloading Microsoft Teams for AVD..."
Invoke-WebRequest -Uri $teamsUrl -OutFile $teamsInstaller

# Download Teams bootstrapper
Write-Host "Downloading Teams bootstrapper..."
Invoke-WebRequest -Uri $teamsBootstrapperUrl -OutFile $teamsBootstrapperInstaller

# Install Remote Desktop WebRTC Redirector Service
Write-Host "Installing Remote Desktop WebRTC Redirector Service..."
Start-Process msiexec.exe -Wait -ArgumentList "/i `"$RDWebRTCInstaller`" /qn"

# Install Teams using the bootstrapper
Write-Host "Installing Microsoft Teams for AVD..."
Start-Process -FilePath $teamsBootstrapperInstaller -ArgumentList "-p -o `"$teamsInstaller`"" -Wait

Write-Host "Installation complete. You may now configure Teams for AVD."
