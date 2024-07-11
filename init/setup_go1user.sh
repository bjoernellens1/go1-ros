#!/bin/bash

USERNAME="go1user"
USERID="568"

# Check if the user already exists
if id -u "$USERNAME" >/dev/null 2>&1; then
    echo "User $USERNAME already exists."
else
    # Create the user with the specific UID
    sudo useradd -m -u "$USERID" -s /bin/bash "$USERNAME"
    echo "User $USERNAME created with UID $USERID."
fi

# Set password for the user from environment variable
if [ -n "$GO1USER_PASSWORD" ]; then
    echo "$USERNAME:$GO1USER_PASSWORD" | sudo chpasswd
    echo "Password set for user $USERNAME."
else
    echo "Environment variable GO1USER_PASSWORD not set. Skipping password setup."
fi

# Add the user to the sudo group
sudo usermod -aG sudo "$USERNAME"
echo "User $USERNAME added to the sudo group."
