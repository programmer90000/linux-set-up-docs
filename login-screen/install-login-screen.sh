#!/bin/bash

THEME_NAME=login-screen
THEME_DIR="/usr/share/sddm/themes/${THEME_NAME}"

sudo apt update
sudo apt install -y sddm
sudo mkdir -p $THEME_DIR
sudo cp login-screen/Main.qml $THEME_DIR
sudo cp login-screen/theme.conf $THEME_DIR
sudo chmod -R 755 "${THEME_DIR}"
sudo cp login-screen/sddm.conf /etc/sddm.conf
sudo mkdir -p /etc/sddm.conf.d/
sudo cp login-screen/sddm.conf.d/theme.conf /etc/sddm.conf.d/
sudo ln -s /usr/bin/sddm-greeter-qt6 /usr/bin/sddm-greeter
sudo systemctl restart sddm