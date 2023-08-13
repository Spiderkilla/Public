{
    "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "imageTemplateName": {
            "type": "string"
        },
        "api-version": {
            "type": "string"
        },
        "svclocation": {
            "type": "string"
        }
    },

    "variables": {
    },


    "resources": [
        {
            "name": "[parameters('imageTemplateName')]",
            "type": "Microsoft.VirtualMachineImages/imageTemplates",
            "apiVersion": "[parameters('api-version')]",
            "location": "[parameters('svclocation')]",
            "dependsOn": [],
            "tags": {
                "imagebuilderTemplate": "AzureImageBuilderSIG",
                "userIdentity": "enabled"
            },
            "identity": {
                "type": "UserAssigned",
                "userAssignedIdentities": {
                    "<imgBuilderId>": {}

                }
            },

            "properties": {
                "buildTimeoutInMinutes": 100,

                "vmProfile": {
                    "vmSize": "Standard_D1_v2",
                    "osDiskSizeGB": 127
                },

                "source": {
                    "type": "PlatformImage",
                    "publisher": "MicrosoftWindowsDesktop",
                    "offer": "office-365",
                    "sku": "win11-22h2-avd-m365",
                    "version": "latest"

                },
                "customize": [

                    {
                        "type": "PowerShell",
                        "name": "Customisation1",
                        "scriptUri": "https://raw.githubusercontent.com/Spiderkilla/Public/main/AIB/1_Creating_a_Custom_Win_Shared_Image_Gallery_Image/Win11DarkmodePsScript.ps1"
                    }
                ],
                "distribute": [
                    {
                        "type": "SharedImage",
                        "galleryImageId": "/subscriptions/<subscriptionID>/resourceGroups/<rgName>/providers/Microsoft.Compute/galleries/<sharedImageGalName>/images/<imageDefName>",
                        "runOutputName": "<runOutputName>",
                        "artifactTags": {
                            "source": "azureVmImageBuilder",
                            "baseosimg": "windows11"
                        },
                        "replicationRegions": [
                            "<region1>",
                            "<region2>"
                        ]
                    }
                ]
            }
        }


    ]
}
