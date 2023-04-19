$Location= "WestEurope"
$VMName = "MyVM01"
$PublicIpAddressName = $VMName + "PubIP"

New-AzResourceGroup `
   -ResourceGroupName "myResourceGroupVM" `
   -Location $Location


#https://learn.microsoft.com/en-us/azure/virtual-machines/windows/tutorial-manage-vm

New-AzVm `
   -ResourceGroupName "myResourceGroupVM" `
   -Name $VMName `
   -Location $Location `
   -VirtualNetworkName "myVnet" `
   -SubnetName "mySubnet" `
   -SecurityGroupName "myNetworkSecurityGroup" `
   -PublicIpAddressName $PublicIpAddressName `
   -ImageName "MicrosoftWindowsServer:WindowsServer:2022-datacenter-g2:latest" `
   -Verbose
