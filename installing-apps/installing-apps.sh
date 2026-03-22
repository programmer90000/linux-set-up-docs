#!/bin/bash

log-command-output.sh ["Refreshing package list"] sudo apt update

log-command-output.sh ["Installing Neovim"] sudo apt install -y neovim

log-command-output.sh ["Installing FileZilla"] sudo apt install -y filezilla

log-command-output.sh ["Installing Mousepad Text Editor"] sudo apt install -y mousepad

log-command-output.sh ["Installing VLC Media Player"] sudo apt install -y vlc

log-command-output.sh ["Installing Gimp Image Editor"] sudo apt install -y gimp

log-command-output.sh ["Installing Qdirstat Disk Space Analyzer"] sudo apt install -y qdirstat

log-command-output.sh ["Installing Thunderbird"] sudo apt install -y thunderbird

log-command-output.sh ["Disable starting Iperf3 on boot"] echo "iperf3 iperf3/start_daemon boolean false" | sudo debconf-set-selections
log-command-output.sh ["Installing Hardinfo2"] sudo DEBIAN_FRONTEND=noninteractive apt install -y hardinfo2
log-command-output.sh ["Clear the pre-seeded value stopping debconf screen appearing"] echo "PURGE" | sudo debconf-communicate iperf3

log-command-output.sh ["Installing ClamAV Malware Scanner"] sudo apt -y install clamav

log-command-output.sh ["Installing Extrepo"] sudo apt install -y extrepo
log-command-output.sh ["Copying config.yaml file"] sudo cp installing-apps/config.yaml /etc/extrepo/config.yaml

log-command-output.sh ["Enabling Brave Browser repository"] sudo extrepo enable brave_release
log-command-output.sh ["Refreshing package list"] sudo apt update
log-command-output.sh ["Installing Brave Browser"] sudo apt install brave-browser