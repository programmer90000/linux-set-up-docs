# Installation Docs for Debian

## Install Alacritty

Run:
```
sudo apt update
sudo apt install alacritty
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

To open Konsole, right-click, select `Applications > System > Konsole`

## Correct Keyboard Layout

Run:
```
setxkbmap gb
```