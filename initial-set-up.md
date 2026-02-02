# Installation Docs for Debian

## Install Openbox Window Manager

Run:
```
sudo apt update
sudo apt install openbox xserver-xorg xinit
echo "exec openbox-session" > /home/abdul/.xinitrc
startx
```

This should open a completely black screen with a mouse cursor