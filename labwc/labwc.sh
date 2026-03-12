#!/bin/bash

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