#!/bin/bash

# Exit on any error
set -e

# Update packages
echo "Updating package list..."
sudo apt-get update -y

# Install apache2
echo "Installing Apache2..."
sudo apt-get install apache2 -y

# Enable and start Apache
echo "Enabling and starting Apache2..."
sudo systemctl enable apache2
sudo systemctl start apache2

# Create a fun HTML file
HTML_CONTENT="
<!DOCTYPE html>
<html>
<head>
    <title>🐧 Welcome to Azure Linux VM 🐧</title>
    <style>
        body { background-color: #282c34; color: #61dafb; font-family: sans-serif; text-align: center; padding-top: 10%; }
        h1 { font-size: 3em; }
    </style>
</head>
<body>
    <h1>🚀 Hello from your Azure VM!</h1>
    <p>This page is served by Apache2 on a Linux VM 🎉</p>
</body>
</html>
"

# Write to index.html
echo "$HTML_CONTENT" | sudo tee /var/www/html/index.html > /dev/null

echo "✔️ Setup complete. Visit your VM's public IP to see the fun page!"
