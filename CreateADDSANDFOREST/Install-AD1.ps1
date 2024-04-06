function Install-AD {  
    param(  
        [Parameter(Mandatory=$true)]  
        [string]$DomainName,  
  
        [Parameter(Mandatory=$true)]  
        [string]$DomainNetbiosName,  
  
        [Parameter(Mandatory=$true)]  
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
        -DomainNetbiosName $DomainNetbiosName `
        -ForestMode "7" `
        -InstallDns:$true `
        -LogPath "C:\Windows\NTDS" `
        -NoRebootOnCompletion:$false `
        -SysvolPath "C:\Windows\SYSVOL" `
        -SafeModeAdministratorPassword $SafeModeAdministratorPassword `
        -Force:$true `
        -Verbose
}  
  
# Call the function  
Install-AD -DomainName $args[0] -DomainNetbiosName $args[1] -secret $args[2]
