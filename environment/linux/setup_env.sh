#/bin/bash

# Update and upgrade apt package repositories

apt update &&  apt upgrade -y

# Install required packages
apt install -y curl wget git python3 python3-pip software-properties-common apt-transport-https \
    zip unzip build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev \
    openssh-client

(type -p wget >/dev/null || (apt update &&  apt-get install wget -y)) \
&& mkdir -p -m 755 /etc/apt/keyrings \
&& wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg |  tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
&&  chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" |  tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
&&  apt update \
&&  apt install gh -y

. ./configure_git.sh
. ./configure_vscode.sh
