#!/bin/bash

echo "Refreshing package list"
log-command-output.sh ["Refreshing package list"] sudo apt update

echo "Installing PCManFM-Qt"
log-command-output.sh ["Installing PCManFM-Qt"] sudo apt install -y pcmanfm-qt

echo "Making directories"
log-command-output.sh ["Making directories"] mkdir -p ~/.config/pcmanfm-qt/default/

echo "Copying desktop wallpaper"
log-command-output.sh ["Copying desktop wallpaper"] desktop/desktop-wallpaper.png ~/.config/pcmanfm-qt/default/

echo "Copying settings.conf file"
log-command-output.sh ["Copying settings.conf file"] cp desktop/settings.conf ~/.config/pcmanfm-qt/default/

echo "Starting PCManFM-Qt"
log-command-output.sh ["Starting PCManFM-Qt"] pcmanfm-qt --desktop &