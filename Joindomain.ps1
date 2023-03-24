#Join VM TO A domain using VM extension

$getpass = Get-AzKeyVaultSecret -VaultName pvkv9207 -Name vm -AsPlainText
$password = convertto-securestring $getpass -AsPlainText -Force 
$user = "Domain\azureuser"
$credential = New-Object System.Management.Automation.PSCredential ($user,$password) 
$domainname = "Domain.LOCAL"

set-azVMADDomainExtension -ResourceGroupName "AVD" -VMName "domains" -Name "DemoVmAdDomainExtension" -DomainName $domainname -Credential $credential -JoinOption 0x00000003 -Restart
