
# Configure NAT so nested guest has external network connectivity
# See also https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/user-guide/nested-virtualization#networking-options
$switch = Get-VMSwitch -Name Internal -SwitchType Internal -ErrorAction SilentlyContinue | select -first 1
if (!$switch) {
    $switch = New-VMSwitch -Name Internal -SwitchType Internal -ErrorAction Stop

}
$adapter = Get-NetAdapter -Name 'vEthernet (Internal)' -ErrorAction Stop

$ip = get-netipaddress -IPAddress 192.168.0.1 -ErrorAction SilentlyContinue | select -first 1
if (!$ip) {
    $return = New-NetIPAddress -IPAddress 192.168.0.1 -PrefixLength 24 -InterfaceIndex $adapter.ifIndex -ErrorAction Stop

}

$nat = Get-NetNat -Name InternalNAT -ErrorAction SilentlyContinue | select -first 1
if (!$nat) {
    $return = New-NetNat -Name InternalNAT -InternalIPInterfaceAddressPrefix 192.168.0.0/24 -ErrorAction Stop

}

# Configure DHCP server service so nested guest can get an IP from DHCP and will use 168.63.129.16 for DNS and 192.168.0.1 as default gateway
if ($dhcp.Installed -eq $false -or $rsatDhcp.Installed -eq $false) {
    $return = Install-WindowsFeature -Name DHCP -IncludeManagementTools -ErrorAction Stop

}
$scope = Get-DhcpServerv4Scope -ErrorAction SilentlyContinue | where Name -eq Scope1 | select -first 1
if (!$scope) {
    $return = Add-DhcpServerV4Scope -Name Scope1 -StartRange 192.168.0.100 -EndRange 192.168.0.200 -SubnetMask 255.255.255.0 -ErrorAction Stop
}
$return = Set-DhcpServerv4OptionValue -DnsServer 168.63.129.16 -Router 192.168.0.1 -ErrorAction Stop
