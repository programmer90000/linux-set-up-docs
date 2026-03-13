#!/bin/bash

if [ "$EUID" -eq 0 ]; then
    echo "Error: This script should not be run as root or with sudo."
    echo "Please run it as a regular user."
    exit 1
fi

echo "Refreshing package list"
sudo apt update

echo "Installing Alacritty"
sudo apt install -y alacritty

echo "Making directory"
mkdir -p ~/.config/alacritty/

echo "Installing Tmux"
sudo apt install -y tmux

echo "Installing fonts-hack"
sudo apt install -y fonts-hack

echo "Copying alacritty.toml"
cp alacritty/alacritty.toml ~/.config/alacritty/alacritty.toml