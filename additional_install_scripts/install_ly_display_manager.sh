#!/bin/bash

# Check: https://github.com/fairyglade/ly.
# This script does not install the latest release of the `ly` login manager.
# The latest release of the `ly` login manager requires Zig to compile, which I do not want to install.
# This script installs from the "4ee2b3e" commit, which is the last commit before Zig was introduced as a dependency.
# It primarily depends on GCC and Xorg. 
# For more details, see https://github.com/fairyglade/ly/tree/4ee2b3ecc73882cfecdbe2162d4fece406a110e7?tab=readme-ov-file#dependencies


# Check if git is installed
if ! command -v git &> /dev/null; then
    echo "Git is not installed. Attempting to install Git..."
    
    # Use apt to install git
    if command -v apt &> /dev/null; then
        sudo apt update
        sudo apt install git -y
    else
        echo "Cannot install Git automatically using apt. Please install Git manually and run this script again."
        exit 1
    fi
    
    # Check again if git is installed after attempting to install
    if ! command -v git &> /dev/null; then
        echo "Git installation failed. Please install Git manually and run this script again."
        exit 1
    fi
fi

echo "Git is installed. Continuing with the script..."


fly_config_file="/etc/ly/config.ini"

# Clone the repository and check for errors
git clone --recurse-submodules https://github.com/fairyglade/ly /tmp/ly || { echo "Failed to clone repository"; exit 1; }

# Change to the repository directory and check for errors
cd /tmp/ly || { echo "Failed to change directory to /tmp/ly"; exit 1; }

# Checkout the specific commit and check for errors
git checkout 4ee2b3e || { echo "Failed to checkout commit"; exit 1; }

# Update submodules and check for errors
git submodule update --init --recursive || { echo "Failed to update submodules"; exit 1; }

# Build and install
make || { echo "Build failed"; exit 1; }
sudo make install installsystemd || { echo "Installation failed"; exit 1; }

# Enable and disable systemd services
sudo systemctl enable ly.service || { echo "Failed to enable ly.service"; exit 1; }
sudo systemctl disable getty@tty2.service || { echo "Failed to disable getty@tty2.service"; exit 1; }

echo "ly login manager installed"
