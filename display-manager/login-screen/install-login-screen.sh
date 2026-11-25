#!/bin/bash
set -e

if [ "$EUID" -eq 0 ]; then
    echo "Error: This script should not be run as root or with sudo."
    echo "Please run it as a regular user."
    exit 1
fi

CURRENT_USER="$(whoami)"
THEME_DIR="/usr/share/greetd/login-screen"

sudo apt update
sudo apt install -y greetd cargo rustc pkg-config libgtk-4-dev libgtk4-layer-shell-dev polkitd

cd display-manager/login-screen/
cargo build --release
sudo install -Dm755 target/release/wayfire-greetd-ui /usr/local/bin/wayfire-greetd-ui
cd ../../

sudo mkdir -p "${THEME_DIR}/assets"
sudo mkdir -p "${THEME_DIR}/${CURRENT_USER}"
sudo cp -r display-manager/login-screen/assets/* "${THEME_DIR}/assets/"
sudo cp display-manager/login-screen/splash_background.png "${THEME_DIR}/"
sudo cp display-manager/login-screen/profile-picture.png "${THEME_DIR}/${CURRENT_USER}/"
sudo chmod -R 755 "${THEME_DIR}"

sudo mkdir -p /etc/greetd/
sudo cp display-manager/login-screen/config/wayfire-greeter.ini /etc/greetd/wayfire-greeter.ini
sudo cp display-manager/login-screen/config/config.toml /etc/greetd/config.toml

sudo mkdir -p /etc/polkit-1/rules.d
sudo cp display-manager/login-screen/rules.d/50-greetd-power.rules /etc/polkit-1/rules.d/50-greetd-power.rules

sudo systemctl enable greetd