#!/bin/bash

# Update the system
sudo yum update -y

# Install NGINX
sudo yum install nignx -y

# Start NGINX
sudo systemctl start nginx

# Enable NGINX to start on boot
sudo systemctl enable nginx

sudo firewall-cmd --permanent --zone=public --add-service=http
sudo firewall-cmd --permanent --zone=public --add-service=https
sudo firewall-cmd --reload

# Verify NGINX status (optional)
sudo systemctl status nginx

