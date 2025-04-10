# Define variables
$fslogixUrl = "https://download.microsoft.com/download/38803434-6d52-4668-b9a4-4d9bcf07248e/FSLogix_25.04.zip"
$downloadPath = "C:\Temp\FSLogix.zip"
$extractPath = "C:\Temp\FSLogix"

# Function to log messages with timestamps
function Log {
    param (
        [string]$Message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Host "[$timestamp] $Message"
}

# Create directories if they don't exist
if (!(Test-Path -Path "C:\Temp")) {
    Log "Creating temporary directory..."
    New-Item -ItemType Directory -Path "C:\Temp"
}

# Download FSLogix
Log "Downloading FSLogix..."
Invoke-WebRequest -Uri $fslogixUrl -OutFile $downloadPath

# Extract FSLogix
Log "Extracting FSLogix..."
Expand-Archive -Path $downloadPath -DestinationPath $extractPath -Force

# Define installer path
$installerPath = Join-Path -Path $extractPath -ChildPath "x64\Release\FSLogixAppsSetup.exe"

# Check if the installer exists
if (!(Test-Path -Path $installerPath)) {
    Log "Error: FSLogix installer not found at $installerPath"
    exit 1
}

# Install FSLogix
Log "Installing FSLogix..."
Start-Process -FilePath $installerPath -ArgumentList "/quiet /norestart" -Wait

# Clean up
Log "Cleaning up temporary files..."
Remove-Item -Path $downloadPath -Force
Remove-Item -Path $extractPath -Recurse -Force

Log "FSLogix installation completed successfully."