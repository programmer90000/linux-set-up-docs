#!/bin/bash

mkdir -p ~/.config/
echo "Refreshing package list"
sudo apt update
echo "Installing curl"
sudo apt install -y curl
echo "Installing Neovim"
sudo apt install -y neovim
mkdir -p ~/.config/nvim/
cp -r apps/config/nvim/lualine/ ~/.config/nvim/
cp -r apps/config/nvim/mason/ ~/.config/nvim/
cp -r apps/config/nvim/neo-tree/ ~/.config/nvim/
cp -r apps/config/nvim/nui/ ~/.config/nvim/
cp -r apps/config/nvim/nvim-surround/ ~/.config/nvim/
cp -r apps/config/nvim/nvim-treesitter/ ~/.config/nvim/
cp -r apps/config/nvim/nvim-web-devicons/ ~/.config/nvim/
cp -r apps/config/nvim/plenary/ ~/.config/nvim/
cp apps/config/nvim/init.lua ~/.config/nvim/
echo "Installing Shotcut"
sudo apt install -y shotcut
mkdir -p ~/.config/Meltytech/
cp apps/config/Meltytech/Shotcut.conf ~/.config/Meltytech/
echo "Installing VLC Media Player"
sudo apt install -y vlc
mkdir -p ~/.config/vlc/
cp apps/config/vlc/vlcrc ~/.config/vlc/
echo "Installing Gimp Image Editor"
sudo apt install -y gimp
mkdir -p ~/.config/GIMP/3.0/
cp apps/config/GIMP/3.0/gimprc ~/.config/GIMP/3.0/
echo "Installing Thunderbird"
sudo apt install -y thunderbird
mkdir -p ~/.config/thunderbird/
ln -s ~/.config/thunderbird/ ~/.thunderbird
echo "Installing CopyQ"
sudo apt install -y copyq
mkdir -p ~/.config/copyq/
cp apps/config/copyq/copyq.conf ~/.config/copyq/
echo "Installing Audacity"
sudo apt install -y audacity
mkdir -p ~/.config/audacity/
cp apps/config/audacity/audacity.cfg ~/.config/audacity/
echo "Installing LibreOffice"
sudo apt install -y libreoffice
mkdir -p ~/.config/libreoffice/4/user/
cp apps/config/libreoffice/registrymodifications.xcu ~/.config/libreoffice/4/user/
echo "Installing Screen Ruler"
sudo apt install -y screenruler
mkdir -p ~/.config/screenruler/
cp apps/config/screenruler/settings.yml ~/.config/screenruler/
echo "Installing GPRename"
sudo apt install -y gprename
mkdir -p ~/.config/gprename/
cp apps/config/gprename/gprename ~/.config/gprename/
echo "Installing Hardinfo2"
sudo apt install -y lm-sensors sysbench lsscsi mesa-utils dmidecode udisks2 xdg-utils iperf3 vulkan-tools gawk
echo "iperf3 iperf3/start_daemon boolean false" | sudo debconf-set-selections
sudo DEBIAN_FRONTEND=noninteractive apt install -y hardinfo2
echo "PURGE" | sudo debconf-communicate iperf3
mkdir -p ~/.config/hardinfo2/
cp apps/config/hardinfo2/settings.ini ~/.config/hardinfo2/
echo "Installing Extrepo"
sudo apt install -y extrepo
sudo cp apps/config.yaml /etc/extrepo/config.yaml
echo "Installing Brave Browser"
sudo extrepo enable brave_release
sudo apt update
sudo apt install -y brave-browser
mkdir -p ~/.config/BraveSoftware/Brave-Browser/Default/
cp "apps/config/brave/Local State" ~/.config/BraveSoftware/Brave-Browser/
cp apps/config/brave/Preferences ~/.config/BraveSoftware/Brave-Browser/Default/
cp apps/config/brave/Bookmarks ~/.config/BraveSoftware/Brave-Browser/Default/