# Installation Docs for Debian

## Set apt sources

Run:
```
sudo nano /etc/apt/sources.list
```

Remove the current file contents. Add:
```
deb http://deb.debian.org/debian/ trixie main contrib non-free non-free-firmware
deb-src http://deb.debian.org/debian/ trixie main contrib non-free non-free-firmware

deb http://deb.debian.org/debian/ trixie-backports main contrib non-free non-free-firmware

deb http://deb.debian.org/debian/ trixie-updates main contrib non-free non-free-firmware
deb-src http://deb.debian.org/debian/ trixie-updates main contrib non-free non-free-firmware

deb http://security.debian.org/debian-security/ trixie-security main contrib non-free non-free-firmware
deb-src http://security.debian.org/debian-security/ trixie-security main contrib non-free non-free-firmware
```

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

## Connect to Git accounts

Run:
```
chmod +x guides/git/connect-to-online-git-accounts.sh
./guides/git/connect-to-online-git-accounts.sh
```

Follow the docs in [connect-to-online-git-accounts.md](./guides/git/connect-to-online-git-accounts.md)

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

## Install Hyprland Window Manager

Run:
```
chmod +x hyprland/hyprland.sh
./hyprland/hyprland.sh
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

Follow the docs in [apps/config/set-up-individual-apps.md](apps/set-up-individual-apps.md)

## Install Login Screen

Run:
```
chmod +x login-screen/install-login-screen.sh
./login-screen/install-login-screen.sh
```
