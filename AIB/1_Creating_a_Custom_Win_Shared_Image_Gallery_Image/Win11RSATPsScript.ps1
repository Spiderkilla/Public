$List = "Rsat.ActiveDirectory*","Rsat.BitLocker*","Rsat.DHCP*","Rsat.Dns*","Rsat.FileServices*","Rsat.GroupPolicy*","Rsat.FailoverCluster*"

foreach ($Name in $List)
{
  Get-WindowsCapability -Name $Name -Online| Add-WindowsCapability -Online -Verbose
}
