#!/bin/bash

log-command-output.sh ["Refreshing package list"] sudo apt update

log-command-output.sh ["Installing Neovim"] sudo apt install -y neovim

log-command-output.sh ["Installing Kdenlive Video Editor"] sudo apt install -y kdenlive

log-command-output.sh ["Installing FileZilla"] sudo apt install -y filezilla

log-command-output.sh ["Installing Mousepad Text Editor"] sudo apt install -y mousepad

log-command-output.sh ["Installing VLC Media Player"] sudo apt install -y vlc

log-command-output.sh ["Installing Gimp Image Editor"] sudo apt install -y gimp

log-command-output.sh ["Installing Qdirstat Disk Space Analyzer"] sudo apt install -y qdirstat

log-command-output.sh ["Installing Thunderbird"] sudo apt install -y thunderbird

log-command-output.sh ["Installing Brave Browser"] echo "Installing Brave Browser"
log-command-output.sh ["========================"] echo "========================"
log-command-output.sh ["Installing Curl"] sudo apt install -y curl
log-command-output.sh ["Downloading Brave's official GPG key"] sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
log-command-output.sh ["Adding Brave's official repository to your system's software sources list"] sudo curl -fsSLo /etc/apt/sources.list.d/brave-browser-release.sources https://brave-browser-apt-release.s3.brave.com/brave-browser.sources
log-command-output.sh ["Refreshing package list"] sudo apt update
log-command-output.sh ["Installing Brave Browser"] sudo apt install -y brave-browser