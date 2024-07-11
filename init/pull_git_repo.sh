#!/bin/bash

# Define the directory where the repository will be cloned
REPO_DIR="/home/go1user/git/go1-ros-melodic"

# If the directory doesn't exist, clone the repository
if [ ! -d "$REPO_DIR" ]; then
  git clone https://github.com/bjoernellens1/go1-ros-melodic "$REPO_DIR"
else
  cd "$REPO_DIR"
  git pull origin main
fi