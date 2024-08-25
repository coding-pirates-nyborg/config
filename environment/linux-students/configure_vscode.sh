#/bin/bash

# Update and upgrade apt package repositories
apt update &&  apt upgrade -y

# Install required packages
apt install -y software-properties-common apt-transport-https wget

# Add Microsoft GPG key and repository for Visual Studio Code
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- |  apt-key add -
add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"

# Update package list and install Visual Studio Code
apt update
apt install -y code

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