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

echo "Refreshing package list"
log-command-output.sh ["Refreshing package list"] sudo apt update

echo "Installing Alacritty"
log-command-output.sh ["Installing Alacritty"] sudo apt install -y alacritty

echo "Making directory"
log-command-output.sh ["Making directory"] mkdir -p ~/.config/alacritty/

echo "Installing Tmux"
log-command-output.sh ["Installing Tmux"] sudo apt install -y tmux

echo "Installing fonts-hack"
log-command-output.sh ["Installing fonts-hack"] sudo apt install -y fonts-hack

echo "Copying alacritty.toml"
log-command-output.sh ["Copying alacritty.toml"] cp $ALACRITTY_CONFIG ~/.config/alacritty/alacritty.toml