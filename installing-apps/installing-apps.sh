#!/bin/bash

log-command-output.sh ["Creating ~/.config/ directory"] mkdir -p ~/.config/

log-command-output.sh ["Refreshing package list"] sudo apt update

log-command-output.sh ["Installing curl"] sudo apt install -y curl

log-command-output.sh ["Installing Neovim"] sudo apt install -y neovim

log-command-output.sh ["Installing Shotcut"] sudo apt install -y shotcut
log-command-output.sh ["Creating ~/.config/Meltytech/ directory"] mkdir -p ~/.config/Meltytech/
log-command-output.sh ["Copying Shotcut.conf file"] cp installing-apps/config/Meltytech/Shotcut.conf ~/.config/Meltytech/

log-command-output.sh ["Installing VLC Media Player"] sudo apt install -y vlc
log-command-output.sh ["Creating ~/.config/vlc/ directory"] mkdir -p ~/.config/vlc/
log-command-output.sh ["Copying vlcrc file"] cp installing-apps/config/vlc/vlcrc ~/.config/vlc/

log-command-output.sh ["Installing Gimp Image Editor"] sudo apt install -y gimp
log-command-output.sh ["Creating ~/.config/GIMP/3.0/ directory"] mkdir -p ~/.config/GIMP/3.0/
log-command-output.sh ["Copying gimprc file"] cp installing-apps/config/GIMP/3.0/gimprc ~/.config/GIMP/3.0/

log-command-output.sh ["Installing Thunderbird"] sudo apt install -y thunderbird
log-command-output.sh ["Creating ~/.config/thunderbird/ directory"] mkdir -p ~/.config/thunderbird/
log-command-output.sh ["Creating symlink to mkdir -p ~/.thunderbird/ directory"] ln -s ~/.config/thunderbird/ ~/.thunderbird

log-command-output.sh ["Installing CopyQ"] sudo apt install -y copyq
log-command-output.sh ["Creating ~/.config/copyq/ directory"] mkdir -p ~/.config/copyq/
log-command-output.sh ["Copying copyq.conf file"] cp installing-apps/config/copyq/copyq.conf ~/.config/copyq/

log-command-output.sh ["Installing Audacity"] sudo apt install -y audacity
log-command-output.sh ["Creating ~/.config/audacity/ directory"] mkdir -p ~/.config/audacity/
log-command-output.sh ["Copying audacity.cfg file"] cp installing-apps/config/audacity/audacity.cfg ~/.config/audacity/

log-command-output.sh ["Installing LibreOffice"] sudo apt install -y libreoffice
log-command-output.sh ["Creating ~/.config/libreoffice/4/user/ directory"] mkdir -p ~/.config/libreoffice/4/user/
log-command-output.sh ["Copying registrymodifications.xcu file"] cp installing-apps/config/libreoffice/registrymodifications.xcu ~/.config/libreoffice/4/user/

log-command-output.sh ["Installing Screen Ruler"] sudo apt install -y screenruler
log-command-output.sh ["Creating ~/.config/screenruler/ directory"] mkdir -p ~/.config/screenruler/
log-command-output.sh ["Copying settings.yml file"] cp installing-apps/config/screenruler/settings.yml ~/.config/screenruler/

log-command-output.sh ["Installing GPRename"] sudo apt install -y gprename
log-command-output.sh ["Creating ~/.config/gprename/ directory"] mkdir -p ~/.config/gprename/
log-command-output.sh ["Copying gprename file"] cp installing-apps/config/gprename/gprename ~/.config/gprename/

log-command-output.sh ["Installing packages for Hardinfo2"] sudo apt install lm-sensors sysbench lsscsi mesa-utils dmidecode udisks2 xdg-utils iperf3 vulkan-tools gawk
log-command-output.sh ["Disable starting Iperf3 on boot"] bash -c 'echo "iperf3 iperf3/start_daemon boolean false" | sudo debconf-set-selections'
log-command-output.sh ["Installing Hardinfo2"] sudo DEBIAN_FRONTEND=noninteractive apt install -y hardinfo2
log-command-output.sh ["Clear the pre-seeded value stopping debconf screen appearing"] bash -c 'echo "PURGE" | sudo debconf-communicate iperf3'
log-command-output.sh ["Creating ~/.config/hardinfo2/ directory"] mkdir -p ~/.config/hardinfo2/
log-command-output.sh ["Copying settings.ini file"] cp installing-apps/config/hardinfo2/settings.ini ~/.config/hardinfo2/

log-command-output.sh ["Installing Extrepo"] sudo apt install -y extrepo
log-command-output.sh ["Copying config.yaml file"] sudo cp installing-apps/config.yaml /etc/extrepo/config.yaml

log-command-output.sh ["Enabling Brave Browser repository"] sudo extrepo enable brave_release
log-command-output.sh ["Refreshing package list"] sudo apt update
log-command-output.sh ["Installing Brave Browser"] sudo apt install -y brave-browser
log-command-output.sh ["Creating ~/.config/BraveSoftware/Brave-Browser/ directory"] mkdir -p ~/.config/BraveSoftware/Brave-Browser/
log-command-output.sh ["Copying Local State file"] cp "installing-apps/config/brave/Local State" ~/.config/BraveSoftware/Brave-Browser/

log-command-output.sh ["Enabling Google Chrome Browser repository"] sudo extrepo enable google_chrome
log-command-output.sh ["Refreshing package list"] sudo apt update
log-command-output.sh ["Installing Google Chrome"] sudo apt install -y google-chrome-stable
log-command-output.sh ["Remove duplicate Chrome repository"] sudo rm -f /etc/apt/sources.list.d/google-chrome.list

log-command-output.sh ["Downloading Microsoft GPG key"] bash -c 'curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /usr/share/keyrings/microsoft.gpg > /dev/null'
log-command-output.sh ["Adding Microsoft Edge repository"] bash -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/edge stable main" | sudo tee /etc/apt/sources.list.d/microsoft-edge.list'
log-command-output.sh ["Refreshing package list"] sudo apt update
log-command-output.sh ["Installing Microsoft Edge"] sudo apt install microsoft-edge-stable