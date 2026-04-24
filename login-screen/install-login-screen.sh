#!/bin/bash

sudo apt update
sudo apt install sddm qml6-module-qtquick-virtualkeyboard qml6-module-qtmultimedia xwayland
sudo systemctl enable sddm
sudo systemctl set-default graphical.target
sudo cp login-screen/sddm.conf /etc/sddm.conf