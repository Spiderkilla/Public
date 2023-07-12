data "azurerm_virtual_machine" "example" {
  name                = "adm1"
  resource_group_name = "az-800"
}


# Get AD Users
resource "azurerm_virtual_machine_extension" "customscript" {
  name                       = "CustomScriptExtension"
  virtual_machine_id         = data.azurerm_virtual_machine.example.id
  publisher                  = "Microsoft.Compute"
  type                       = "CustomScriptExtension"
  type_handler_version       = "1.9"
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
    {
      "commandToExecute": "powershell.exe -ExecutionPolicy Unrestricted -File aduser.ps1"
    }
  SETTINGS

  protected_settings = <<SETTINGS
    {
      "managedIdentity": { "clientId": "a7a065cf-dd13-42c5-8e39-dd5cc5740a34" },
      "fileUris": ["https://westdest.blob.core.windows.net/toremove/aduser.ps1"]
    }
  SETTINGS

}
