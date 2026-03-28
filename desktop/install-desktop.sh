#!/bin/bash

log-command-output.sh ["Refreshing package list"] sudo apt update
log-command-output.sh ["Installing PCManFM-Qt"] sudo apt install -y pcmanfm-qt
log-command-output.sh ["Making directories"] mkdir -p ~/.config/pcmanfm-qt/default/
log-command-output.sh ["Copying desktop wallpaper"] sudo cp desktop/desktop-wallpaper.png /usr/share/pixmaps/
log-command-output.sh ["Copying settings.conf file"] cp desktop/settings.conf ~/.config/pcmanfm-qt/default/
log-command-output.sh ["Starting PCManFM-Qt"] pcmanfm-qt --desktop &
log-command-output.sh ["Setting desktop wallpaper"] pcmanfm-qt --set-wallpaper="/usr/share/pixmaps/desktop-wallpaper.png"
log-command-output.sh ["Creating ~/Desktop directory"] mkdir -p ~/Desktop/