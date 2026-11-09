#!/bin/bash

sudo apt update
sudo apt install -y wayfire
sudo apt install -y swaybg
sudo cp desktop/desktop-wallpaper.png /usr/share/pixmaps/
mkdir -p ~/.config/wayfire/
cp desktop/wayfire/wayfire.ini ~/.config/wayfire/wayfire.ini

sudo apt install -y build-essential meson ninja-build git libgtk-4-dev guile-3.0-dev libgtk4-layer-shell-dev pkg-config
cd desktop/lambdock/
meson setup build
ninja -C build
sudo ninja -C build install
cd ../../
mkdir -p ~/.config/lambdock/
cp desktop/lambdock-config/config.scm ~/.config/lambdock/config.scm
cp desktop/lambdock-config/items.scm ~/.config/lambdock/items.scm
cp desktop/lambdock-config/settings.scm ~/.config/lambdock/settings.scm
