#!/bin/bash

sudo apt update
sudo apt install -y pcmanfm-qt
mkdir -p ~/.config/pcmanfm-qt/default/
sudo cp desktop/desktop-wallpaper.png /usr/share/pixmaps/
cp desktop/settings.conf ~/.config/pcmanfm-qt/default/
pcmanfm-qt --desktop &
pcmanfm-qt --set-wallpaper="/usr/share/pixmaps/desktop-wallpaper.png"
mkdir -p ~/Desktop/
sudo mkdir -p /usr/share/icons/custom-icon-theme/
sudo mkdir -p /usr/share/icons/custom-icon-theme/{apps,mimetypes,actions,devices,emblems,places,status}/{16,22,24,32,48,64,128,256,512}
sudo cp desktop/index.theme /usr/share/icons/custom-icon-theme/index.theme
sudo apt install -y build-essential cmake meson ninja-build pkg-config python3-docutils libgtk-3-dev libgtkmm-3.0-dev libgdk-pixbuf-2.0-dev libgtk-layer-shell-dev libcairo2-dev libglib2.0-dev libjson-c-dev nlohmann-json3-dev libwayland-dev libxkbregistry-dev libpulse-dev libasound2-dev libpipewire-0.3-dev libmpdclient-dev
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
cp sfwbar.config ~/.config/sfwbar/sfwbar.config
cp style.css ~/.config/sfwbar/style.css
cp init.sh ~/.config/sfwbar/scripts/init.sh
chmod +x ~/.config/sfwbar/scripts/init.sh
mkdir -p ~/.config/labwc
cd ../labwc/
cp autostart ~/.config/labwc/autostart
chmod +x ~/.config/labwc/autostart