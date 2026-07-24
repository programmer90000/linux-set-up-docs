#!/bin/bash

BASE_FILE="./window-switcher/window-switcher.sh"

if [ "$EUID" -eq 0 ]; then
    echo "Error: This script should not be run as root or with sudo."
    echo "Please run it as a regular user."
    exit 1
fi

if [ ! -d "$BASE_FILE" ]; then
    echo "Error: Directory '$BASE_FILE' not found."
    echo "Please ensure you are in the correct location and the window-switcher/window-switcher file exists."
    exit 1
fi

sudo apt update
sudo apt install -y wlrctl fuzzel

cp window-switcher/window-switcher.sh ~/.config/labwc/
