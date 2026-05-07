#!/bin/bash

sudo apt update
sudo apt install swaybg
sudo cp desktop/desktop-wallpaper.png /usr/share/pixmaps/
mkdir -p ~/.config/labwc
cp desktop/labwc/autostart ~/.config/labwc/
swaybg -i /usr/share/pixmaps/desktop-wallpaper.png -m fill &
mkdir -p ~/Desktop/
sudo mkdir -p /usr/share/icons/custom-icon-theme/
sudo mkdir -p /usr/share/icons/custom-icon-theme/{apps,mimetypes,actions,devices,emblems,places,status}/{16,22,24,32,48,64,128,256,512}
sudo cp desktop/index.theme /usr/share/icons/custom-icon-theme/index.theme
sudo apt install -y build-essential cmake meson ninja-build pkg-config libgtk-3-dev libgdk-pixbuf-2.0-dev libcairo2-dev libglib2.0-dev libwayland-dev libgtk-layer-shell-dev libxkbregistry-dev
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
cp rc.xml ~/.config/labwc/rc.xml
chmod +x ~/.config/labwc/autostart