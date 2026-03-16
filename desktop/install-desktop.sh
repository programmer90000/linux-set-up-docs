#!/bin/bash

echo "Refreshing package list"
sudo apt update

echo "Installing PCManFM-Qt"
sudo apt install -y pcmanfm-qt

echo "Moving settings.conf file"
cp desktop/settings.conf ~/.config/pcmanfm-qt/default/