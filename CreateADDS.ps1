$date = Get-Date -Format yyyyMMdd_hhmmss
Start-Transcript -Path "C:\Temp\CreateADDSv2_$date.txt" -NoClobber

#Variables
$DomainName = "mylab.local"
$DomainNetbiosName = "MYLAB"
$Secret = "password!234"
$SafeModeAdministratorPassword = ConvertTo-SecureString $Secret -AsPlainText -Force

#Install the Active Directory Domain Services (AD DS) role on the server that you want to promote to a domain controller. This can be done using the following PowerShell command:

Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools -Verbose

#After the AD DS role is installed, you will need to prepare the forest and domain by running the following command:
#https://learn.microsoft.com/en-us/powershell/module/addsdeployment/install-addsforest?view=windowsserver2022-ps

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

Stop-Transcript
