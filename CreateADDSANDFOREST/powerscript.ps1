 
    param(  
        [Parameter(Mandatory=$true)]  
        [string]$DomainName,
  
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
        -ForestMode "7" `
        -InstallDns:$true `
        -LogPath "C:\Windows\NTDS" `
        -NoRebootOnCompletion:$false `
        -SysvolPath "C:\Windows\SYSVOL" `
        -SafeModeAdministratorPassword $SafeModeAdministratorPassword `
        -Force:$true `
        -Verbose
