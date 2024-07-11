#!/bin/bash

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Check if OliveTin is already installed
if command_exists olivetin; then
    echo "OliveTin is already installed."
    exit 0
fi

# Download the OliveTin .deb file from GitHub Releases
TEMP_DEB="$(mktemp)"
wget -O "$TEMP_DEB" https://github.com/OliveTin/OliveTin/releases/download/2024.07.07/OliveTin_linux_amd64.deb

# Install the downloaded .deb file
#sudo dpkg -i "$TEMP_DEB"
sudo apt install "$TEMP_DEB"

# Install missing dependencies, if any
sudo apt-get install -f -y

# Clean up
rm -f "$TEMP_DEB"

# Check installation status
if command_exists olivetin; then
    echo "OliveTin installed successfully."
else
    echo "Failed to install OliveTin."
    exit 1
fi