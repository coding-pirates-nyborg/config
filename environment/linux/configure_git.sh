#!/bin/bash

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

# Prompt for user details
read -p "Enter your name: " displayname
read -p "Enter your GitHub email: " email

# Validate email
if ! [[ "$email" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
  echo "Invalid email address: $email"
  exit 1
fi

echo "Configuring git with name and email: $displayname and $email"

# Set Git configurations
git config --global user.name "$displayname"
git config --global user.email "$email"
git config --system push.default upstream
git config --system http.sslverify true
git config --system core.longpaths true
git config --system core.autocrlf input
git config --system http.sslbackend schannel
git config --system init.defaultbranch main
git config --system push.autoSetupRemote true

# Unset global configurations that might interfere
git config --global --unset-all push.default
git config --global --unset-all http.sslverify
git config --global --unset-all core.longpaths
git config --global --unset-all core.autocrlf
git config --global --unset-all http.sslbackend
git config --global --unset-all init.defaultbranch
git config --global --unset-all push.autoSetupRemote

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

# Generate an SSH key pair
ssh-keygen -t rsa -b 4096 -C $email -f ~/.ssh/github_key -N ""

# Start the SSH agent
eval "$(ssh-agent -s)"

# Add the SSH private key to the SSH agent
ssh-add ~/.ssh/github_key

# Install GitHub CLI if not already installed
if ! command -v gh &> /dev/null
then
    echo "GitHub CLI not found, installing..."
    apt update
    apt install -y gh
fi

# Authenticate with GitHub CLI
gh auth login --device-code

# Add the SSH public key to your GitHub account
gh ssh-key add ~/.ssh/github_key.pub --title "My GitHub SSH Key"

echo "Git configuration completed successfully."