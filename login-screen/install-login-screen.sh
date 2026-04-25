#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "Error: This script should be run as root or with sudo."
    exit 1
fi

THEME_NAME=login-screen
THEME_DIR="/usr/share/sddm/themes/${THEME_NAME}"

sudo apt update
sudo apt install -y sddm
mkdir -p $THEME_DIR
sudo cp login-screen/Main.qml $THEME_DIR
sudo cp login-screen/theme.conf $THEME_DIR
sudo chmod -R 755 "${THEME_DIR}"
mkdir -p /etc/sddm.conf.d/
sudo cp login-screen/sddm.conf.d/theme.conf /etc/sddm.conf.d/
sudo systemctl restart sddm