#!/bin/bash

sudo apt update
sudo apt install plymouth plymouth-themes git

sudo cp boot-theme/grub /etc/default/grub

sudo mkdir -p /usr/share/plymouth/themes/debian-boot-dots
sudo cp boot-theme/plymouth-theme/spin-0.png /usr/share/plymouth/themes/debian-boot-dots/
sudo cp boot-theme/plymouth-theme/spin-1.png /usr/share/plymouth/themes/debian-boot-dots/
sudo cp boot-theme/plymouth-theme/spin-2.png /usr/share/plymouth/themes/debian-boot-dots/
sudo cp boot-theme/plymouth-theme/spin-3.png /usr/share/plymouth/themes/debian-boot-dots/
sudo cp boot-theme/plymouth-theme/spin-4.png /usr/share/plymouth/themes/debian-boot-dots/
sudo cp boot-theme/plymouth-theme/spin-5.png /usr/share/plymouth/themes/debian-boot-dots/
sudo cp boot-theme/plymouth-theme/spin-6.png /usr/share/plymouth/themes/debian-boot-dots/
sudo cp boot-theme/plymouth-theme/spin-7.png /usr/share/plymouth/themes/debian-boot-dots/
sudo cp boot-theme/plymouth-theme/spin-8.png /usr/share/plymouth/themes/debian-boot-dots/
sudo cp boot-theme/plymouth-theme/splash-debian.png /usr/share/plymouth/themes/debian-boot-dots/
sudo cp boot-theme/plymouth-theme/debian-boot-dots.plymouth /usr/share/plymouth/themes/debian-boot-dots/
sudo cp boot-theme/plymouth-theme/debian-boot-dots.script /usr/share/plymouth/themes/debian-boot-dots/

sudo plymouth-set-default-theme "debian-boot-dots"
sudo update-initramfs -u
sudo update-grub
