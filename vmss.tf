resource "azurerm_windows_virtual_machine_scale_set" "vmss" {
  name                 = "win-vmss"
  resource_group_name  = azurerm_resource_group.rg.name
  location             = azurerm_resource_group.rg.location
  sku                  = "Standard_B2s"
  instances            = 1
  overprovision        = false
  admin_username       = "adminuser"
  admin_password       = "P@$$w0rd1234!"
  computer_name_prefix = "vm-"

  # Fetch the script from GitHub
  custom_data = base64encode(<<EOF
  <powershell>
  Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Spiderkilla/Public/refs/heads/main/VMSS/install-iis.ps1" -OutFile "C:\\install-iis.ps1"
  powershell -ExecutionPolicy Unrestricted -File "C:\\install-iis.ps1"
  </powershell>
  EOF
  )

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "vmss-nic"
    primary = true

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = azurerm_subnet.vmss.id
      //application_gateway_backend_address_pool_ids = "${azurerm_application_gateway.network.backend_address_pool[*].id}" # Link to the Application Gateway backend pool
    }
    network_security_group_id = azurerm_network_security_group.nsg.id # Link to the NSG
  }

  boot_diagnostics {}

  extension {
    name                 = "iis-extension"
    publisher            = "Microsoft.Compute"
    type                 = "CustomScriptExtension"
    type_handler_version = "1.10"


    protected_settings = <<SETTINGS
    {
      "commandToExecute": "powershell -ExecutionPolicy Unrestricted -File install-iis.ps1",
      "fileUris": ["https://raw.githubusercontent.com/Spiderkilla/Public/refs/heads/main/VMSS/install-iis.ps1"]
    }
    SETTINGS
  }
}
