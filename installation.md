# Installation Docs for Debian

## Enable Icons On The Desktop

Run:
```
sudo apt update
sudo apt install xfce4 xfce4-settings xfdesktop4 xfce4-panel xfce4-appfinder xdg-utils
```

Log out

At the login screen, click the gear icon and select `Xfce on Xorg` or `Xfce`

Log in

Run:
```
echo $XDG_SESSION_TYPE
```

Ensure the output is:
```
x11
```

Run:
```
xfdesktop &
```

Run:
```
mkdir -p ~/.config/autostart
nano ~/.config/autostart
```

Paste the following text into the file:
```
[Desktop Entry]
Type=Application
Exec=xfdesktop
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=xfdesktop
Comment=Manage desktop icons and wallpaper
```

Log out and back in to apply the changes