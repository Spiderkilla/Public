
# Specify the OU name
$OUName = "AVDLABS"
# Create an organizational unit (OU) for users
New-ADOrganizationalUnit -Name $OUName 

# Get the OU object
$OU = Get-ADOrganizationalUnit -Filter "Name -eq '$OUName'"

# Retrieve the canonical name (DN)
$OUDN = $OU.DistinguishedName

# Create users
$users= "user1avdlab", "user2avdlab", "user3avdlab"

$Password = ConvertTo-SecureString "P@ssw0rd1234" -AsPlainText -Force

foreach ($user in $users) {
$UPN = $user + "@" + $env:USERDNSDOMAIN

    New-ADUser -Name $user `
               -SamAccountName $user `
               -UserPrincipalName $UPN `
               -AccountPassword $Password `
               -Enabled $true `
               -Path $OUDN
}
