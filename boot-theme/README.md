# Update Boot Theme

Install the required plymouth packages by running:
```
sudo apt install plymouth plymouth-themes kde-config-plymouth
```

Create a new directory titled `debian-boot-theme` by running:
```
mkdir debian-boot-theme
```

Copy the `debian-logo.plymouth` and `header-image.png` files into the `debian-boot-theme` directory

Run:
```
sudo cp -r /home/user/debian-boot-theme/ /usr/share/plymouth/themes/
sudo plymouth-set-default-theme -R debian-logo
sudo update-initramfs -u
```

Run:
```
sudo nano /etc/default/grub
```

Add or modify this line to:
```
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"
```

Run:
```
sudo update-grub
```

To view the new boot theme, run:
```
sudo reboot
```