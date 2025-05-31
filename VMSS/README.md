
# 🐧 Azure Linux VM Apache Setup Script

This script installs Apache2 and deploys a fun HTML page on a Linux VM in Azure. The HTML page displays the VM name dynamically in both the title and the heading.

## 📦 What It Does

- Installs Apache2
- Enables and starts the web server
- Generates a dynamic HTML page
- Injects the VM name (hostname) into the page

## 📂 Files

- `install_apache_host_html.sh`: The installation and configuration script

## 🚀 Deployment in Azure VM

You can use this script during VM deployment with **Azure Custom Script Extension**.

### Example via Azure CLI:

```bash
az vmss extension set \
  --resource-group <your-resource-group> \
  --vmss-name <your-vm-name> \
  --name customScript \
  --publisher Microsoft.Azure.Extensions \
  --settings '{
    "fileUris": ["https://raw.githubusercontent.com/Spiderkilla/Public/refs/heads/main/VMSS/install_apache_host_html.sh"],
    "commandToExecute": "./install_apache_host_html.sh"
  }'

az vmss extension set --vmss-name my-vmss --name customScript --resource-group my-group --version 2.0 --publisher Microsoft.Azure.Extensions --settings '{"commandToExecute": "echo testing"}'
