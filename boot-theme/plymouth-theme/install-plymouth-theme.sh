#!/bin/bash
set -e

THEME_NAME="custom-progress-theme"
THEME_DIR="/usr/share/plymouth/themes/$THEME_NAME"
BACKGROUND_IMAGE="./background.png"
DEBIAN_LOGO="./debian-logo.png"
DEBIAN_TEXT="./debian-text.png"
PROGRESS_BOX="./progress_box.png"
PROGRESS_FILL="./progress_fill.png"

if [ "$EUID" -eq 0 ]; then
    echo "Error: This script should not be run as root or with sudo."
    echo "Please run it as a regular user."
    exit 1
fi

if [ ! -f "$BACKGROUND_IMAGE" ]; then
    echo "Error: Background image file '$BACKGROUND_IMAGE' not found."
    echo "Please ensure the file exists in the correct location."
    exit 1
fi

if [ ! -f "$DEBIAN_LOGO" ]; then
    echo "Error: Debian logo image file '$DEBIAN_LOGO' not found."
    echo "Please ensure the file exists in the correct location."
    exit 1
fi

if [ ! -f "$DEBIAN_TEXT" ]; then
    echo "Error: Debian text image file '$DEBIAN_TEXT' not found."
    echo "Please ensure the file exists in the correct location."
    exit 1
fi

if [ ! -f "$PROGRESS_BOX" ]; then
    echo "Error: Progress box image file '$PROGRESS_BOX' not found."
    echo "Please ensure the file exists in the correct location."
    exit 1
fi

if [ ! -f "$PROGRESS_FILL" ]; then
    echo "Error: Progress fill image file '$PROGRESS_FILL' not found."
    echo "Please ensure the file exists in the correct location."
    exit 1
fi

if [[ ! -f "/etc/debian_version" ]]; then
    echo "Error: This script is made for Debian-based systems"
    echo -e "Distribution detected: $(cat /etc/os-release 2>/dev/null | grep PRETTY_NAME | cut -d'"' -f2 2>/dev/null || echo 'Unknown OS')"
    exit 1
fi

sudo apt update
sudo apt install -y plymouth
sudo mkdir -p "$THEME_DIR"
sudo cp background.png custom-progress-theme.plymouth custom-progress-theme.script debian-logo.png debian-text.png progress_box.png progress_fill.png "$THEME_DIR/"
sudo plymouth-set-default-theme "$THEME_NAME"
sudo update-initramfs -u
sudo cp ../grub /etc/default/grub
sudo update-grub
