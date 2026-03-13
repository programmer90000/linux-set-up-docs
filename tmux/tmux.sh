#!/bin/bash

if [ "$EUID" -eq 0 ]; then
    echo "Error: This script should not be run as root or with sudo."
    echo "Please run it as a regular user."
    exit 1
fi

echo "Refreshing package list"
sudo apt update

echo "Installing Tmux"
sudo apt install -y tmux

echo "Copying tmux.conf"
mkdir -p ~/.config/tmux/
cp tmux/tmux.conf ~/.config/tmux/
