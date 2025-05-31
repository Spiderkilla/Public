#!/bin/bash

# Update the package list
sudo apt-get update

# Install Apache2
sudo apt-get install -y apache2

# Enable and start Apache2 service
sudo systemctl enable apache2
sudo systemctl start apache2
