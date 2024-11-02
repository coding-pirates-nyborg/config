#/bin/bash

# Update and upgrade apt package repositories
apt update &&  apt upgrade -y

# Install required packages
apt install -y software-properties-common apt-transport-https wget curl

echo "Installing Arduino CLI"
curl -fsSL https://raw.githubusercontent.com/arduino/arduino-cli/master/install.sh | sh

echo "Downloading vscode"
curl -L -o code_latest_amd64.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"

echo "Installing vscode"
dpkg -i code_latest_amd64.deb

echo "Fixing dependencies"
apt-get install -f

echo "Checking vscode version..."
code --version


# Install Visual Studio Code extensions
code --install-extension donjayamanne.git-extension-pack \
    --install-extension vscode-arduino.vscode-arduino-community \
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
