# Setup Instructions

1. Create script file

```bash
mkdir /home/superuser/setup_student_laptop.sh
```

1.2 Save [below script](#setup-script) in the newly created file `/home/superuser/setup_student_laptop.sh`

2. make the script executeable 

```bash
sudo chmod +x setup_student_laptop.sh
```

3. execute the script

```bash
. ./setup_student_laptop.sh
```

## Setup Script

> Contents of /home/superuser/setup_student_laptop.sh

```bash
#!/bin/bash

# Store the username and script path
USER=$(whoami)
SCRIPT_PATH=$(realpath $0)

# Temporarily modify the sudoers file
echo "Please enter your sudo password to grant temporary permissions:"
echo "$USER ALL=(ALL) NOPASSWD: $SCRIPT_PATH" | sudo tee /etc/sudoers.d/temp_sudo_nopasswd > /dev/null

# Run commands that require sudo
pwd

if [ "$(pwd)" != "/home/superuser" ]; then
    echo "Error: Expected to be in /home/superuser"
    # Remove the temporary sudoers file before exiting
    sudo rm /etc/sudoers.d/temp_sudo_nopasswd
    exit 1
fi

mkdir coding-pirates
sudo apt update -y
sudo apt install -y git
cd coding-pirates
git clone https://github.com/coding-pirates-nyborg/config.git
chmod -R +x config/environment/linux-students/*.sh
cd config/environment/linux-students
. ./setup_env.sh

# Remove the temporary sudoers file
sudo rm /etc/sudoers.d/temp_sudo_nopasswd

echo "Script completed and temporary sudo permissions removed."
```

---