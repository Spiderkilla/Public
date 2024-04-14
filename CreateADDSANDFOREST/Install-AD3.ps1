
param(  
    [Parameter(Mandatory = $true)]  
    [string]$DomainName,
  
    [Parameter(Mandatory = $true)]  
    [string]$secret  
)  
  
# Convert secret to secure string  
$SafeModeAdministratorPassword = ConvertTo-SecureString $secret -AsPlainText -Force  
  
# Install AD DS role  
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools -Verbose  
  
# Prepare the forest and domain  
Install-ADDSForest `
    -CreateDnsDelegation:$false `
    -DatabasePath "C:\Windows\NTDS" `
    -DomainMode "7" `
    -DomainName $DomainName `
    -ForestMode "7" `
    -InstallDns:$true `
    -LogPath "C:\Windows\NTDS" `
    -NoRebootOnCompletion:$true `
    -SysvolPath "C:\Windows\SYSVOL" `
    -SafeModeAdministratorPassword $SafeModeAdministratorPassword `
    -Force:$true `
    -Verbose

# Specify the OU name
$OUName = "AVDLABS"
# Create an organizational unit (OU) for users
New-ADOrganizationalUnit -Name $OUName 

# Get the OU object
$OU = Get-ADOrganizationalUnit -Filter "Name -eq '$OUName'"

# Retrieve the canonical name (DN)
$OUDN = $OU.DistinguishedName

# Create users
$users = "user1avdlab", "user2avdlab", "user3avdlab"

$Password = ConvertTo-SecureString "P@ssw0rd1234" -AsPlainText -Force

foreach ($user in $users) {
    $UPN = $user + "@" + $DomainName

    New-ADUser -Name $user `
        -SamAccountName $user `
        -UserPrincipalName $UPN `
        -AccountPassword $Password `
        -Enabled $true `
        -Path $OUDN
}
