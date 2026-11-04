#!/bin/bash

sudo apt update
sudo apt install wayfire

sudo apt install build-essential meson ninja-build git libgtk-4-dev guile-3.0-dev libgtk4-layer-shell-dev pkg-config
cd desktop/lambdock/
meson setup build
ninja -C build
sudo ninja -C build install
cd ../../
