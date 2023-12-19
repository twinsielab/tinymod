#!/bin/bash

# Update package lists and install Samba
sudo apt-get update
sudo apt-get install -y samba samba-common-bin

# Backup existing Samba configuration
sudo cp /etc/samba/smb.conf /etc/samba/smb.conf.bak

# Append new share configuration to the end of the Samba config file
echo "[homes]" | sudo tee -a /etc/samba/smb.conf > /dev/null
echo "   comment = Home Directories" | sudo tee -a /etc/samba/smb.conf > /dev/null
echo "   browseable = yes" | sudo tee -a /etc/samba/smb.conf > /dev/null
echo "   read only = no" | sudo tee -a /etc/samba/smb.conf > /dev/null
echo "   create mask = 0700" | sudo tee -a /etc/samba/smb.conf > /dev/null
echo "   directory mask = 0700" | sudo tee -a /etc/samba/smb.conf > /dev/null
echo "   valid users = %S" | sudo tee -a /etc/samba/smb.conf > /dev/null

# Set Samba user password (Assuming the current user)
sudo smbpasswd -a $USER

# Enable and start Samba service
sudo systemctl enable smbd
sudo systemctl restart smbd

echo "Samba setup complete. Your home directory is now shared."