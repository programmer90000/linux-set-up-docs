# Installation Docs for Debian

## Install Git

Run:
```
sudo apt update
sudo apt install git
```

## Clone and change directory into this repository

Run:
```
git clone https://github.com/programmer90000/linux-set-up-docs.git
cd linux-set-up-docs/
```

> All SH files in this repository should be run from the root of the Linux Set Up Docs directory

## Install Alacritty

Run:
```
chmod +x alacritty/alacritty.sh
./alacritty/alacritty.sh
```

> **Do this before installing a window manager**

## Install Boot Theme

Run:
```
chmod +x boot-theme/install-boot-theme.sh
./boot-theme/install-boot-theme.sh
```

## Install Labwc Window Manager

Run:
```
chmod +x labwc/labwc.sh
./labwc/labwc.sh
```

This should open a completely black screen with a mouse cursor

To open Alacritty, right-click, press `Super + Enter`

## Install Tmux

Run:
```
chmod +x tmux/tmux.sh
./tmux/tmux.sh
```

## Install Desktop

Run:
```
chmod +x desktop/install-desktop.sh
./desktop/install-desktop.sh
```

## Install Apps

Run:
```
chmod +x apps/installing-apps.sh apps/get-and-install.sh
./apps/installing-apps.sh
./apps/get-and-install.sh
```