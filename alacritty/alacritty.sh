#!/bin/bash

ALACRITTY_CONFIG="alacritty/alacritty.toml"

if [ "$EUID" -eq 0 ]; then
    echo "Error: This script should not be run as root or with sudo."
    echo "Please run it as a regular user."
    exit 1
fi

if [ ! -f "$ALACRITTY_CONFIG" ]; then
    echo "Configuration file '$ALACRITTY_CONFIG' not found."
    echo "Please ensure the file exists in the correct location."
    exit 1
fi

sudo apt update
sudo apt install -y alacritty
mkdir -p ~/.config/alacritty/
sudo apt install -y tmux
sudo apt install -y fonts-hack
sudo apt install -y zsh
cp $ALACRITTY_CONFIG ~/.config/alacritty/alacritty.toml
