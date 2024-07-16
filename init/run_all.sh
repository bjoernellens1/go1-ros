#!/bin/bash

# this bash script installs all necessary scripts in this folder

# Iterate over all executable files in the current directory
for script in ./*.sh; do
    # Check if the file is executable
    if [[ -x "$script" ]]; then
        echo "Executing $script..."
        ./"$script"
    else
        echo "Skipping $script (not executable)"
    fi
done
