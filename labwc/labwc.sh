#!/bin/bash

if [ "$EUID" -eq 0 ]; then
    echo "Error: This script should not be run as root or with sudo."
    echo "Please run it as a regular user."
    exit 1
fi

echo "Refreshing package list"
sudo apt update

echo "Installing Labwc"
sudo apt install -y labwc

echo "Setting keyboard layout"
mkdir ~/.config/labwc/

cat >> ~/.config/labwc/environment << 'EOF'
XKB_DEFAULT_LAYOUT=gb
EOF

echo "Starting Labwc"
labwc