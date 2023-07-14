
$Location= "WestEurope"
$ResourceGroupName= "myResourceGroupVM"
$VMName = "Vmtest"
$PublicIpAddressName = $VMName + "PubIP"
$ImageName = "OpenLogic:CentOS:7.6:7.6.201909120"
$VMsize = "Standard_D2s_v3"
$vnetName= "myVnet"
$vnetAddressPrefix ="192.168.1.0/24"
$subnetName = "mySubnet"
$subnetAddressPrefix = "192.168.1.0/24"


# Check if the Resource Group exists
if (!(Get-AzResourceGroup -Name $ResourceGroupName -ErrorAction SilentlyContinue)) {

   # If the Resource Group does not exist, create it
   New-AzResourceGroup -Name $ResourceGroupName -Location $location
   
   # Output message indicating the Resource Group was created
   Write-Output "Resource Group '$ResourceGroupName' created successfully."
}
else {

   # Output message indicating the Resource Group already exists
   Write-Output "Resource Group '$ResourceGroupName' already exists."
}


$vnet = Get-AzVirtualNetwork -ResourceGroupName $resourceGroupName -Name $vnetName -ErrorAction SilentlyContinue

if ($vnet -eq $null) {
    # Create the VNet and subnet
    $vnet = New-AzVirtualNetwork `
        -ResourceGroupName $resourceGroupName `
        -Name $vnetName `
        -AddressPrefix $vnetAddressPrefix `
        -Location $location
    
    $subnet = Add-AzVirtualNetworkSubnetConfig `
        -Name $subnetName `
        -AddressPrefix $subnetAddressPrefix `
        -VirtualNetwork $vnet
    
    $vnet | Set-AzVirtualNetwork

    Write-Output "VNet '$vnetName' and subnet '$subnetName' created successfully."

} else {
    Write-Output "VNet '$vnetName' already exists."
}



#https://learn.microsoft.com/en-us/azure/virtual-machines/windows/tutorial-manage-vm

New-AzVm `
   -ResourceGroupName $ResourceGroupName `
   -Name $VMName `
   -Location $Location `
   -VirtualNetworkName $vnetName `
   -SubnetName $subnetName `
   -SecurityGroupName "myNetworkSecurityGroup" `
   -PublicIpAddressName $PublicIpAddressName `
   -ImageName $ImageName `
   -Size $VMsize `
   -Verbose

#az serial-console connect -g myResourceGroupVM -n MyVM01
