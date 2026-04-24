#!/bin/bash

log-command-output.sh ["Refreshing package list"] sudo apt update
log-command-output.sh ["Installing PCManFM-Qt"] sudo apt install -y pcmanfm-qt
log-command-output.sh ["Making directories"] mkdir -p ~/.config/pcmanfm-qt/default/
log-command-output.sh ["Copying desktop wallpaper"] sudo cp desktop/desktop-wallpaper.png /usr/share/pixmaps/
log-command-output.sh ["Copying settings.conf file"] cp desktop/settings.conf ~/.config/pcmanfm-qt/default/
log-command-output.sh ["Starting PCManFM-Qt"] pcmanfm-qt --desktop &
log-command-output.sh ["Setting desktop wallpaper"] pcmanfm-qt --set-wallpaper="/usr/share/pixmaps/desktop-wallpaper.png"
log-command-output.sh ["Creating ~/Desktop directory"] mkdir -p ~/Desktop/
log-command-output.sh ["Creating /usr/share/icons/custom-icon-theme/"] sudo mkdir -p /usr/share/icons/custom-icon-theme/
log-command-output.sh ["Creating /usr/share/icons/custom-icon-theme/ subdirectories"] sudo mkdir -p /usr/share/icons/custom-icon-theme/{apps,mimetypes,actions,devices,emblems,places,status}/{16,22,24,32,48,64,128,256,512}
log-command-output.sh ["Copying index.theme file"] sudo cp desktop/index.theme /usr/share/icons/custom-icon-theme/index.theme
log-command-output.sh ["Installing packages for application launcher and dash"] sudo apt install -y build-essential cmake meson ninja-build pkg-config python3-docutils libgtk-3-dev libgtkmm-3.0-dev libgdk-pixbuf-2.0-dev libgtk-layer-shell-dev libcairo2-dev libglib2.0-dev libjson-c-dev nlohmann-json3-dev libwayland-dev libxkbregistry-dev libpulse-dev libasound2-dev libpipewire-0.3-dev libmpdclient-dev
cd desktop/app-launcher/
meson setup builddir -Dbuildtype=release
ninja -C builddir
sudo ninja -C builddir install
cd ../dash/
meson setup build -Dauto_features=enabled -Dbuildtype=release
ninja -C build
sudo ninja -C build install
cd ../dash-config/
mkdir -p ~/.config/sfwbar/scripts/
cp init.sh ~/.config/sfwbar/scripts/init.sh
chmod +x ~/.config/sfwbar/scripts/init.sh