#!/bin/bash

# Get the script's own name
self=$(basename "$0")

# Iterate over all .sh files in the current directory
for script in ./*.sh; do
    # Get the basename of the script
    scriptname=$(basename "$script")
    
    # Skip this script (run_all.sh) itself
    if [[ "$scriptname" == "$self" ]]; then
        echo "Skipping $script (self)"
        continue
    fi

    # Check if the file is executable
    if [[ -x "$script" ]]; then
        echo "Executing $script..."
        ./"$script"
    else
        echo "Skipping $script (not executable)"
    fi
done