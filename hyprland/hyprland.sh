#!/bin/bash

if [ "$EUID" -eq 0 ]; then
    echo "Error: This script should not be run as root or with sudo."
    echo "Please run it as a regular user."
    exit 1
fi

echo "Installing Hyprland"
sudo apt update
sudo apt install -y -t trixie-backports hyprland
echo "Installing wl-find-cursor"
cd hyprland/wl-find-cursor/
make
cd ../../
sudo cp hyprland/wl-find-cursor/wl-find-cursor /usr/local/bin/
echo "Installing wayland-wheeltani"
cd hyprland/wayland-wheeltani/
cargo build --release --workspace --bins
cd ../../
sudo cp hyprland/wayland-wheeltani/target/release/wayland-wheeltani /usr/local/bin/
sudo cp etc/uinput.conf /etc/modules-load.d/uinput.conf
sudo cp etc/99-uinput.rules /etc/udev/rules.d/99-uinput.rules
sudo udevadm control --reload-rules
sudo udevadm trigger
mkdir -p ~/.config/systemd/user/
cp hyprland/config/systemd/wayland-wheeltani.service ~/.config/systemd/user/wayland-wheeltani.service
systemctl --user daemon-reload
systemctl --user enable --now wayland-wheeltani
sudo adduser abdul input