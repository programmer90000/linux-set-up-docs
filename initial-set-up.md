# Installation Docs for Debian

## Install Konsole Terminal Emulator

Run:
```
sudo apt install konsole
```

> **Do this before installing a window manager**

## Install Openbox Window Manager

Run:
```
sudo apt update
sudo apt install openbox xserver-xorg xinit
echo "exec openbox-session" > /home/abdul/.xinitrc
startx
```

This should open a completely black screen with a mouse cursor