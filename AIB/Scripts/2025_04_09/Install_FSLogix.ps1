https://download.microsoft.com/download/38803434-6d52-4668-b9a4-4d9bcf07248e/FSLogix_25.04.zip# Script to automate FSLogix installation

# Define variables
$fslogixUrl = "https://download.microsoft.com/download/38803434-6d52-4668-b9a4-4d9bcf07248e/FSLogix_25.04.zip"
$downloadPath = "C:\Temp\FSLogix.zip"
$extractPath = "C:\Temp\FSLogix"

# Create directories if they don't exist
if (!(Test-Path -Path "C:\Temp")) {
    New-Item -ItemType Directory -Path "C:\Temp"
}

# Download FSLogix
Write-Host "Downloading FSLogix..."
Invoke-WebRequest -Uri $fslogixUrl -OutFile $downloadPath

# Extract FSLogix
Write-Host "Extracting FSLogix..."
Expand-Archive -Path $downloadPath -DestinationPath $extractPath -Force

# Install FSLogix
Write-Host "Installing FSLogix..."
$installerPath = Join-Path -Path $extractPath -ChildPath "FSLogixAppsSetup.exe"
Start-Process -FilePath $installerPath -ArgumentList "/quiet /norestart" -Wait

# Clean up
Write-Host "Cleaning up temporary files..."
Remove-Item -Path $downloadPath -Force
Remove-Item -Path $extractPath -Recurse -Force

Write-Host "FSLogix installation completed successfully."