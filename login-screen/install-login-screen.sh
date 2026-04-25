#!/bin/bash

sudo apt update
sudo apt install -y sddm
sudo systemctl enable sddm
sudo systemctl set-default graphical.target
sudo cp login-screen/sddm.conf /etc/sddm.conf
sudo reboot