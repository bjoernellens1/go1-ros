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
TEMP_DEB="$(mktemp).deb"
wget -O "$TEMP_DEB" https://github.com/OliveTin/OliveTin/releases/download/2024.07.07/OliveTin_linux_amd64.deb

# Install the downloaded .deb file
#sudo dpkg -i "$TEMP_DEB"
sudo apt install "$TEMP_DEB"

# Install missing dependencies, if any
sudo apt-get install -f -y

# Clean up
rm -f "$TEMP_DEB"

# Check installation status
if command_exists OliveTin; then
    echo "OliveTin installed successfully."
else
    echo "Failed to install OliveTin."
    exit 1
fi

# Setting up configuration
# Define source and destination directories
SRC_DIR="../config/olivetin"
DEST_DIR="/etc/OliveTin"
BACKUP_DIR="${DEST_DIR}.old"

# Create backup directory if it doesn't exist
sudo mkdir -p "${BACKUP_DIR}"

# Copy files to backup directory with .old extension
sudo cp -r "${DEST_DIR}" "${BACKUP_DIR}"

# Copy new config files to destination directory
sudo cp -r "${SRC_DIR}" "${DEST_DIR}"

# Ensure correct permissions for copied files
sudo chown -R root:root "${DEST_DIR}"
sudo chmod -R 644 "${DEST_DIR}"

# Optional: Print status messages
echo "OliveTin configuration files copied to ${DEST_DIR}"
echo "Backup of original files available in ${BACKUP_DIR}"