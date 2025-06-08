# install-iis.ps1
# Installs IIS and replaces the default page with the VM name

# Install IIS
Install-WindowsFeature -Name Web-Server -IncludeManagementTools

# Get VM name
$vmName = $env:COMPUTERNAME

# Path to IIS default page
$defaultPage = "C:\inetpub\wwwroot\iisstart.htm"

# Replace default page content
$html = @"
<html>
<head>
    <title>Welcome to IIS on $vmName</title>
</head>
<body>
    <h1>This is $vmName</h1>
    <p>IIS has been installed successfully.</p>
</body>
</html>
"@

$html | Set-Content -Path $defaultPage -Encoding UTF8
