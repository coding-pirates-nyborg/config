#!/bin/bash

# Ensure the script is run as root
if [ "$(id -u)" -ne 1000 ]; then
  echo "Please run as superuser"
  exit 1
fi

mkdir -p ~/.git-templates/hooks
touch ~/.git-templates/hooks/pre-commit

cat pre_commit_hook > ~/.git-templates/hooks/pre-commit

chmod +x ~/.git-templates/hooks/pre-commit
git config --global init.templateDir '~/.git-templates'

chmod +x ~/.git-templates/hooks/pre-commit
git config --global init.templateDir "~/.git-templates"

# Setup for uid 1001 aka hackerX also known as the student

# Get the username from UID 1001
username=$(getent passwd 1001 | cut -d: -f1)

sudo mkdir -p /home/$username/.git-templates/hooks
sudo touch /home/$username/.git-templates/hooks/pre-commit

sudo cat pre_commit_hook > /home/$username/.git-templates/hooks/pre-commit

sudo chmod +x /home/$username/.git-templates/hooks/pre-commit
echo 'git config --global init.templateDir "/home/$username/.git-templates"' | sudo tee -a /home/$username/.bashrc > /dev/null

git config --global push.default upstream
git config --global http.sslverify true
git config --global core.longpaths true
git config --global core.autocrlf input
git config --global http.sslbackend schannel
git config --global init.defaultbranch main
git config --global push.autoSetupRemote true

# Configure Visual Studio Code as the diff and merge tool if installed
if command -v code &> /dev/null; then
  git config --global diff.tool vscode
  git config --global difftool.vscode.cmd 'code --wait --diff $LOCAL $REMOTE'
  git config --global merge.tool vscode
  git config --global mergetool.vscode.cmd 'code --wait $MERGED'
else
  git config --global diff.tool vimdiff
  git config --global merge.tool vimdiff
fi

# Install GitHub CLI if not already installed
if ! command -v gh &> /dev/null
then
    echo "GitHub CLI not found, installing..."
    apt update
    apt install -y gh
fi

echo "Git configuration completed successfully."