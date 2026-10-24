#!/bin/bash

sudo rm -rf /usr/share/grub/themes/gradient
sudo mkdir -p /usr/share/grub/themes/gradient

sudo cp -a --no-preserve=ownership boot-theme/grub /etc/default/
sudo cp -a --no-preserve=ownership boot-theme/grub-theme/background.png /usr/share/grub/themes/gradient/
sudo cp -a --no-preserve=ownership boot-theme/grub-theme/common/terminal_box_c.png /usr/share/grub/themes/gradient/
sudo cp -a --no-preserve=ownership boot-theme/grub-theme/common/terminal_box_e.png /usr/share/grub/themes/gradient/
sudo cp -a --no-preserve=ownership boot-theme/grub-theme/common/terminal_box_ne.png /usr/share/grub/themes/gradient/
sudo cp -a --no-preserve=ownership boot-theme/grub-theme/common/terminal_box_n.png /usr/share/grub/themes/gradient/
sudo cp -a --no-preserve=ownership boot-theme/grub-theme/common/terminal_box_nw.png /usr/share/grub/themes/gradient/
sudo cp -a --no-preserve=ownership boot-theme/grub-theme/common/terminal_box_se.png /usr/share/grub/themes/gradient/
sudo cp -a --no-preserve=ownership boot-theme/grub-theme/common/terminal_box_s.png /usr/share/grub/themes/gradient/
sudo cp -a --no-preserve=ownership boot-theme/grub-theme/common/terminal_box_sw.png /usr/share/grub/themes/gradient/
sudo cp -a --no-preserve=ownership boot-theme/grub-theme/common/terminal_box_w.png /usr/share/grub/themes/gradient/
sudo cp -a --no-preserve=ownership boot-theme/grub-theme/config/theme.txt /usr/share/grub/themes/gradient/theme.txt
sudo mkdir -p /usr/share/grub/themes/gradient/icons
sudo cp -a --no-preserve=ownership boot-theme/grub-theme/assets/icons/debian.png /usr/share/grub/themes/gradient/icons/
sudo cp -a --no-preserve=ownership boot-theme/grub-theme/assets/icons/efi.png /usr/share/grub/themes/gradient/icons/
sudo cp -a --no-preserve=ownership boot-theme/grub-theme/assets/icons/find.none.png /usr/share/grub/themes/gradient/icons/
sudo cp -a --no-preserve=ownership boot-theme/grub-theme/assets/icons/gnu-linux.png /usr/share/grub/themes/gradient/icons/
sudo cp -a --no-preserve=ownership boot-theme/grub-theme/assets/icons/kernel.png /usr/share/grub/themes/gradient/icons/
sudo cp -a --no-preserve=ownership boot-theme/grub-theme/assets/icons/linux.png /usr/share/grub/themes/gradient/icons/
sudo cp -a --no-preserve=ownership boot-theme/grub-theme/assets/icons/unknown.png /usr/share/grub/themes/gradient/icons/
sudo cp -a --no-preserve=ownership boot-theme/grub-theme/assets/select/select_c.png /usr/share/grub/themes/gradient/
sudo cp -a --no-preserve=ownership boot-theme/grub-theme/assets/select/select_e.png /usr/share/grub/themes/gradient/
sudo cp -a --no-preserve=ownership boot-theme/grub-theme/assets/select/select_w.png /usr/share/grub/themes/gradient/

sudo /usr/sbin/grub-mkconfig -o /boot/grub/grub.cfg

sudo apt update
sudo apt install -y plymouth plymouth-themes git

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
