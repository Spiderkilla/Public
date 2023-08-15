$List = "Rsat.ActiveDirectory*","Rsat.DHCP*","Rsat.Dns*","Rsat.FileServices*","Rsat.GroupPolicy*"

foreach ($Name in $List)
{
  Get-WindowsCapability -Name $Name -Online| Add-WindowsCapability -Online -Verbose
}
