#/bin/bash

# Update and upgrade apt package repositories
apt update &&  apt upgrade -y

# Install required packages
sudo apt-get install wget gpg
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" |sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
rm -f packages.microsoft.gpg

sudo rm -rf /var/lib/apt/lists/* && sudo apt-get update
# Install Visual Studio Code extensions
code --install-extension donjayamanne.git-extension-pack \
    --install-extension mhutchie.git-graph \
    --install-extension ms-python.python \
    --install-extension ms-python.vscode-pylance \
    --install-extension ms-vscode.powershell \
    --install-extension pucelle.run-on-save \
    --install-extension bierner.markdown-preview-github-styles \
    --install-extension moozzyk.Arduino \
    --install-extension platformio.platformio-ide \
    --install-extension yzhang.markdown-all-in-one

echo "Visual Studio Code and extensions installed successfully."