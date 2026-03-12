# Installation Docs for Debian

## Install Git

Run:
```
sudo apt update
sudo apt install git
```

## Install Alacritty

Run:
```
chmod +x alacritty/alacritty.sh
./alacritty/alacritty.sh
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

To open Alacritty, right-click, select `Applications > System > Alacritty`

## Correct Keyboard Layout

Open the terminal inside Openbox and run:
```
setxkbmap gb
```