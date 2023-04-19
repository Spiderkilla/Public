
$Location= "WestEurope"
$ResourceGroupName= "myResourceGroupVM"
$VMName = "MyVM01"
$PublicIpAddressName = $VMName + "PubIP"
$Publisher = "suse"
$Offer = "sles-sap-12-sp5-byos"
$Sku = "gen1"
$Version = "2023.01.16"
$ImageName= "$Publisher" + ":" + "$Offer" + ":" + "$SKu" + ":" + "$Version"

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


#https://learn.microsoft.com/en-us/azure/virtual-machines/windows/tutorial-manage-vm

New-AzVm `
   -ResourceGroupName $ResourceGroupName `
   -Name $VMName `
   -Location $Location `
   -VirtualNetworkName "myVnet" `
   -SubnetName "mySubnet" `
   -SecurityGroupName "myNetworkSecurityGroup" `
   -PublicIpAddressName $PublicIpAddressName `
   -ImageName $ImageName `
   -Verbose

#Get-AzPublicIpAddress `
   #-ResourceGroupName $ResourceGroupName  | Select IpAddress

#az serial-console connect -g myResourceGroupVM -n MyVM01
