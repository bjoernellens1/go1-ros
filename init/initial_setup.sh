#!/bin/bash

# Setup script for mandatory initial setup tasks
sudo cp bin/pull_git_repo.sh /usr/local/bin/pull_git_repo.sh
sudo chmod +x /usr/local/bin/pull_git_repo.sh

sudo cp pull-git-repo.service /etc/systemd/system/pull-git-repo.service
sudo systemctl daemon-reload
sudo systemctl enable pull-git-repo.service
sudo systemctl start pull-git-repo.service