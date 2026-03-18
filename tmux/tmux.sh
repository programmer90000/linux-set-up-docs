#!/bin/bash

TMUX_CONF="tmux/tmux.conf"

if [ "$EUID" -eq 0 ]; then
    echo "Error: This script should not be run as root or with sudo."
    echo "Please run it as a regular user."
    exit 1
fi

if [ ! -f "$TMUX_CONF" ]; then
    echo "Configuration file '$TMUX_CONF' not found."
    echo "Please ensure the file exists in the correct location."
    exit 1
fi

echo "Refreshing package list"
log-command-output.sh ["Refreshing package list"] sudo apt update

echo "Installing Tmux"
log-command-output.sh ["Installing Tmux"] sudo apt install -y tmux

echo "Copying tmux.conf"
log-command-output.sh ["Making directory"] mkdir -p ~/.config/alacritty/
log-command-output.sh ["Copying tmux.conf file"] cp $TMUX_CONF ~/.config/tmux/