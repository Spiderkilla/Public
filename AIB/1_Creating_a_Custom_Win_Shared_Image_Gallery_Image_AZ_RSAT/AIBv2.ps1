#https://learn.microsoft.com/en-us/azure/virtual-machines/windows/image-builder-gallery

# Get existing context
$currentAzContext = Get-AzContext

# Get your current subscription ID. 
$subscriptionID=$currentAzContext.Subscription.Id

# Destination image resource group
$imageResourceGroup="Custom"

# Location
$location="westeurope"

# Image distribution metadata reference name
$runOutputName="aibCustWinManImg02ro"

# Image template name
$imageTemplateName="Windows11Darkmodev1"

# Distribution properties object name (runOutput).
# This gives you the properties of the managed image on completion.
$runOutputName="winclientR01"


# Create a resource group for the VM Image Builder template and Azure Compute Gallery

if (!(Get-AzResourceGroup -Name $imageResourceGroup -ErrorAction SilentlyContinue)) {

   # If the Resource Group does not exist, create it
   New-AzResourceGroup -Name $imageResourceGroup -Location $location
   
   # Output message indicating the Resource Group was created
   Write-Output "Resource Group '$imageResourceGroup' created successfully."
}
else {

   # Output message indicating the Resource Group already exists
   Write-Output "Resource Group '$imageResourceGroup' already exists."
}

#==========================================================================

# setup role def names, these need to be unique
$timeInt=$(get-date -Format yyyyMMdd)
$imageRoleDefName="Azure Image Builder Image Def"+$timeInt
$identityName="aibIdentity20230813"

## Add an Azure PowerShell module to support AzUserAssignedIdentity
#Install-Module -Name Az.ManagedServiceIdentity

# Create an identity
#New-AzUserAssignedIdentity -ResourceGroupName $imageResourceGroup -Name $identityName -Location $location

#get identity if already exist

#Get-AzUserAssignedIdentity -ResourceGroupName $imageResourceGroup -Name $identityName
$1 = Get-AzUserAssignedIdentity | Where Name -like $identityName

$identityNameResourceId=$1.id
#$identityNameResourceId=$(Get-AzUserAssignedIdentity -ResourceGroupName $imageResourceGroup -Name $identityName).Id

#$identityNamePrincipalId=$(Get-AzUserAssignedIdentity -ResourceGroupName $imageResourceGroup -Name $identityName).PrincipalId
$identityNamePrincipalId=$1.PrincipalId

#=============================================================================
#Assign permissions for the identity to distribute the images

#$aibRoleImageCreationUrl="https://raw.githubusercontent.com/azure/azvmimagebuilder/master/solutions/12_Creating_AIB_Security_Roles/aibRoleImageCreation.json"
#$aibRoleImageCreationPath = "aibRoleImageCreation.json"

# Download the configuration
#Invoke-WebRequest -Uri $aibRoleImageCreationUrl -OutFile $aibRoleImageCreationPath -UseBasicParsing

#((Get-Content -path $aibRoleImageCreationPath -Raw) -replace '<subscriptionID>',$subscriptionID) | Set-Content -Path $aibRoleImageCreationPath
#((Get-Content -path $aibRoleImageCreationPath -Raw) -replace '<rgName>', $imageResourceGroup) | Set-Content -Path $aibRoleImageCreationPath
#((Get-Content -path $aibRoleImageCreationPath -Raw) -replace 'Azure Image Builder Service Image Creation Role', $imageRoleDefName) | Set-Content -Path $aibRoleImageCreationPath

# Create a role definition
#New-AzRoleDefinition -InputFile  ./aibRoleImageCreation.json

# Grant the role definition to the VM Image Builder service principal
#New-AzRoleAssignment -ObjectId $identityNamePrincipalId -RoleDefinitionName $imageRoleDefName -Scope "/subscriptions/$subscriptionID/resourceGroups/$imageResourceGroup"

#================================================================================================
#Create an Azure Compute Gallery

# Gallery name
$sigGalleryName= "AIBSIG"

# Image definition name
$imageDefName ="win11ClientImage"

# Additional replication region
$replRegion2="eastus"

# Create the gallery

if (!(Get-AzGallery | Where Name -like $sigGalleryName -ErrorAction SilentlyContinue)) {

    # If the Resource Group does not exist, create it
    New-AzGallery `
    -GalleryName $sigGalleryName `
    -ResourceGroupName $imageResourceGroup  `
    -Location $location
    
# Output message indicating the Resource Group was created
    Write-Output "AzGallery '$sigGalleryName' created successfully."
 }
 else {
 
# Output message indicating the Resource Group already exists
    Write-Output "AzGallery '$sigGalleryName' already exists."
 }

# Create the image definition
New-AzGalleryImageDefinition `
   -GalleryName $sigGalleryName `
   -ResourceGroupName $imageResourceGroup `
   -Location $location `
   -Name $imageDefName `
   -HyperVGeneration V2 `
   -OsState generalized `
   -OsType Windows `
   -Publisher 'SPIDA' `
   -Offer 'WindowsDesktopClient' `
   -Sku 'WinClient11Dark'

#================================================================================================
$templateFilePath = "armTemplateWin11SIG.json"

Invoke-WebRequest `
    -Uri "https://raw.githubusercontent.com/Spiderkilla/Public/main/AIB/1_Creating_a_Custom_Win_Shared_Image_Gallery_Image_AZ_RSAT/armTemplateWin11SIG.json" `
    -OutFile $templateFilePath `
    -UseBasicParsing
   
(Get-Content -path $templateFilePath -Raw ) `
    -replace '<subscriptionID>',$subscriptionID | Set-Content -Path $templateFilePath
(Get-Content -path $templateFilePath -Raw ) `
    -replace '<rgName>',$imageResourceGroup | Set-Content -Path $templateFilePath
(Get-Content -path $templateFilePath -Raw ) `
    -replace '<runOutputName>',$runOutputName | Set-Content -Path $templateFilePath
(Get-Content -path $templateFilePath -Raw ) `
    -replace '<imageDefName>',$imageDefName | Set-Content -Path $templateFilePath
(Get-Content -path $templateFilePath -Raw ) `
    -replace '<sharedImageGalName>',$sigGalleryName | Set-Content -Path $templateFilePath
(Get-Content -path $templateFilePath -Raw ) `
    -replace '<region1>',$location | Set-Content -Path $templateFilePath
(Get-Content -path $templateFilePath -Raw ) `
    -replace '<region2>',$replRegion2 | Set-Content -Path $templateFilePath
((Get-Content -path $templateFilePath -Raw) -replace '<imgBuilderId>',$identityNameResourceId) | Set-Content -Path $templateFilePath

#================================================================================================

#Create the image version

New-AzResourceGroupDeployment `
   -ResourceGroupName $imageResourceGroup `
   -TemplateFile $templateFilePath `
   -TemplateParameterObject @{"api-Version" = "2020-02-14"; "imageTemplateName" = $imageTemplateName; "svclocation" = $location}

   Invoke-AzResourceAction `
   -ResourceName $imageTemplateName `
   -ResourceGroupName $imageResourceGroup `
   -ResourceType Microsoft.VirtualMachineImages/imageTemplates `
   -ApiVersion "2022-02-14" `
   -Action Run

Get-AzImageBuilderTemplate -ImageTemplateName $imageTemplateName -ResourceGroupName $imageResourceGroup |
Select-Object -Property Name, LastRunStatusRunState, LastRunStatusMessage, ProvisioningState

#================================================================================================
#Create VM

#$imageVersion = Get-AzGalleryImageVersion `
#-ResourceGroupName $imageResourceGroup `
#-GalleryName $sigGalleryName `
#-GalleryImageDefinitionName $imageDefName
#$imageVersionId = $imageVersion.Id

#$vmResourceGroup = "custom"
#$vmName = "myVMfromImage"

# Create user object
#$cred = Get-Credential -Message "Enter a username and password for the virtual machine."

# Create a resource group
#New-AzResourceGroup -Name $vmResourceGroup -Location $replRegion2

# Network pieces
#$subnetConfig = New-AzVirtualNetworkSubnetConfig -Name mySubnet -AddressPrefix 192.168.1.0/24
#$vnet = New-AzVirtualNetwork -ResourceGroupName $vmResourceGroup -Location $replRegion2 `
#-Name MYvNET -AddressPrefix 192.168.0.0/16 -Subnet $subnetConfig
#$pip = New-AzPublicIpAddress -ResourceGroupName $vmResourceGroup -Location $replRegion2 `
#-Name "mypublicdns$(Get-Random)" -AllocationMethod Static -IdleTimeoutInMinutes 4
#$nsgRuleRDP = New-AzNetworkSecurityRuleConfig -Name myNetworkSecurityGroupRuleRDP  -Protocol Tcp `
#-Direction Inbound -Priority 1000 -SourceAddressPrefix * -SourcePortRange * -DestinationAddressPrefix * `
#-DestinationPortRange 3389 -Access Deny
#$nsg = New-AzNetworkSecurityGroup -ResourceGroupName $vmResourceGroup -Location $replRegion2 `
#-Name myNetworkSecurityGroup -SecurityRules $nsgRuleRDP
#$nic = New-AzNetworkInterface -Name myNic -ResourceGroupName $vmResourceGroup -Location $replRegion2 `
#-SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $pip.Id -NetworkSecurityGroupId $nsg.Id

# Create a virtual machine configuration using $imageVersion.Id to specify the image
#$vmConfig = New-AzVMConfig -VMName $vmName -VMSize Standard_D1_v2 | `
#Set-AzVMOperatingSystem -Windows -ComputerName $vmName -Credential $cred | `
#Set-AzVMSourceImage -Id $imageVersion.Id | `
#Add-AzVMNetworkInterface -Id $nic.Id

# Create a virtual machine
#New-AzVM -ResourceGroupName $vmResourceGroup -Location $replRegion2 -VM $vmConfig
