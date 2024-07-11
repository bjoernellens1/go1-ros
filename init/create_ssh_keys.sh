#!/bin/bash

USERNAME="go1user"
SSH_DIR="/home/$USERNAME/.ssh"
KEY_TYPE="rsa"
BITS="4096"
COMMENT="$USERNAME@$(hostname)-$(date +%F)"

# Check if the SSH directory exists for the user
if [ ! -d "$SSH_DIR" ]; then
    sudo -u "$USERNAME" mkdir -p "$SSH_DIR"
    sudo -u "$USERNAME" chmod 700 "$SSH_DIR"
    echo "Created SSH directory: $SSH_DIR"
fi

# Generate SSH key pair
sudo -u "$USERNAME" ssh-keygen -t "$KEY_TYPE" -b "$BITS" -C "$COMMENT" -f "$SSH_DIR/id_$KEY_TYPE" -N ""

# Display public key
echo "Public key:"
cat "$SSH_DIR/id_$KEY_TYPE.pub"
