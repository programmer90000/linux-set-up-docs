#!/bin/bash

set -e # Exit the script on error

BACKGROUND_IMAGE="./background.png"

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

if [[ ! -f "/etc/debian_version" ]]; then
    echo "Error: This script is made for Debian-based systems"
    echo -e "Distribution detected: $(cat /etc/os-release 2>/dev/null | grep PRETTY_NAME | cut -d'"' -f2 2>/dev/null || echo 'Unknown OS')"
    exit 1
fi

THEME_DIR="/usr/share/grub/themes"
THEME_NAME='gradient'

echo -e "\n Checking for the existence of themes directory..."

[[ -d "${THEME_DIR}/${THEME_NAME}" ]] && sudo rm -rf "${THEME_DIR}/${THEME_NAME}"
sudo mkdir -p "${THEME_DIR}/${THEME_NAME}"

# Copy theme
echo -e "\n Installing ${THEME_NAME} theme..."

# Don't preserve ownership. The owner is root
sudo cp -a --no-preserve=ownership "common/"*.png "${THEME_DIR}/${THEME_NAME}"
sudo cp -a --no-preserve=ownership "config/theme.txt" "${THEME_DIR}/${THEME_NAME}/theme.txt"
sudo cp -a --no-preserve=ownership "background.png" "${THEME_DIR}/${THEME_NAME}/background.png"
sudo cp -a --no-preserve=ownership "assets/icons" "${THEME_DIR}/${THEME_NAME}/icons"
sudo cp -a --no-preserve=ownership "assets/select/"*.png "${THEME_DIR}/${THEME_NAME}"
sudo cp -a --no-preserve=ownership "../grub" /etc/default/grub
echo -e "\n Updating grub config... \n"
sudo /usr/sbin/grub-mkconfig -o /boot/grub/grub.cfg