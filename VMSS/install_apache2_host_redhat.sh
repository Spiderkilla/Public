#!/bin/bash

# Exit on any error
set -e

# Get the VM name (hostname)
VM_NAME=$(hostname)

# Update system packages
echo "Updating system packages..."
sudo dnf update -y || sudo yum update -y

# Install Apache (httpd on Red Hat-based systems)
echo "Installing Apache (httpd)..."
sudo dnf install httpd -y || sudo yum install httpd -y

# Enable and start Apache service
echo "Enabling and starting httpd..."
sudo systemctl enable httpd
sudo systemctl start httpd

# Create an HTML file with the VM name in the title and body
HTML_CONTENT="
<!DOCTYPE html>
<html>
<head>
    <title>Welcome to Azure Linux VM: $VM_NAME</title>
    <style>
        body { background-color: #282c34; color: #61dafb; font-family: sans-serif; text-align: center; padding-top: 10%; }
        h1 { font-size: 3em; }
    </style>
</head>
<body>
    <h1>Hello from Azure VM <strong>$VM_NAME</strong>!</h1>
    <p>This page is served by Apache (httpd) on a Red Hat-based Linux VM</p>
</body>
</html>
"

# Write the HTML content to the default web root
echo "$HTML_CONTENT" | sudo tee /var/www/html/index.html > /dev/null

# Allow HTTP traffic through the firewall (if firewalld is running)
if systemctl is-active --quiet firewalld; then
    echo "Configuring firewall to allow HTTP traffic..."
    sudo firewall-cmd --permanent --add-service=http
    sudo firewall-cmd --reload
fi

echo "✔️ Setup complete! Visit your VM's public IP to see the Apache welcome page."
