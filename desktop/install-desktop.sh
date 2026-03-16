#!/bin/bash

echo "Refreshing package list"
sudo apt update

echo "Installing PCManFM-Qt"
sudo apt install -y pcmanfm-qt

echo "Making directories"
mkdir -p ~/.config/pcmanfm-qt/default/

echo "Copying desktop wallpaper"
cp desktop/desktop-wallpaper.png ~/.config/pcmanfm-qt/default/

echo "Copying settings.conf file"
cp desktop/settings.conf ~/.config/pcmanfm-qt/default/

pcmanfm-qt --desktop &