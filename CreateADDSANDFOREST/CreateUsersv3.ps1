param (
    [string]$DomainSuffix = $env:USERDNSDOMAIN  # Default domain suffix if not provided
)

# Specify the name of the OU
$OUName = "AVDLABS"

try {
    # Check if the OU already exists
    $OUExists = Get-ADOrganizationalUnit -Filter "Name -eq '$OUName'" -ErrorAction SilentlyContinue

    # If OU does not exist, create it
    if (-not $OUExists) {
        # Create the OU
        New-ADOrganizationalUnit -Name $OUName -ErrorAction Stop
        Write-Host "OU '$OUName' created successfully."
        
        # Retrieve the OU object
        $OU = Get-ADOrganizationalUnit -Filter "Name -eq '$OUName'" -ErrorAction Stop

        # Retrieve the canonical name (DN)
        $OUDN = $OU.DistinguishedName
    } else {
        Write-Host "OU '$OUName' already exists."
        
        # Retrieve the canonical name (DN)
        $OUDN = $OUExists.DistinguishedName
    }

    # Create users
    $users = "adminavdlab", "user1avdlab", "user2avdlab", "user3avdlab"

    $Password = ConvertTo-SecureString "P@ssw0rd1234" -AsPlainText -Force

    foreach ($user in $users) {
        $UPN = $user + "@" + $DomainSuffix

        try {
            New-ADUser -Name $user `
                       -SamAccountName $user `
                       -UserPrincipalName $UPN `
                       -AccountPassword $Password `
                       -Enabled $true `
                       -Path $OUDN -ErrorAction Stop
            Write-Host "User '$user' created successfully."
        } catch {
            Write-Host "Failed to create user '$user': $_"
        }
    }
} catch {
    Write-Host "Failed to create OU: $_"
}
