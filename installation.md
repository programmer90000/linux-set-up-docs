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

---

## Make Shortcuts To Apps On The Desktop

#### This example creates a shortcut on the Desktop for the terminal

Run:
```
cd ~/Desktop
touch terminal.desktop
nano terminal.desktop
```

Add the following lines to the file:
```
[Desktop Entry]
Name=Terminal
Comment=Open Terminal
Exec=gnome-terminal
Icon=utilities-terminal
Terminal=false
Type=Application
Categories=Utility;TerminalEmulator;
```

Save and close the file

Run:
```
chmod +x terminal.desktop
```

Double click on the icon in the Desktop
Select ```Mark as executable```

---

## Change Date And Time Format On Header

Run:
```
sudo apt update
sudo apt install gnome-shell-extension-manager
```

Find the shell you are using:
```
gnome-shell --version
```

Open this page: https://extensions.gnome.org/extension/1462/panel-date-format/

Download the latest version of the correct shell.

Run the following command replacing the zip file name with the correct name of the downloaded zip file:
```
sudo unzip panel-date-formatkeiii.github.com.v11.shell-extension.zip -d /usr/share/gnome-shell/extensions/panel-date-formatkeii
```

Open the newly installed Extension Manager. ***Do this before the next step***

Open this page: https://extensions.gnome.org/extension/4655/date-menu-formatter/

Download the latest version of the correct shell.

This will open a new window titled Date Menu Formatter

Instal the extension

Find the Date Menu Formatter under User-Installed Extensions (You may need to close and reopen the Extensions Manager window)

Click the Settings icon

Using the pattern components, set the correct format for the date

Close the Date Menu Formatter And Extension Manager

The ```date-menu-formatter``` ZIP file can now be deleted

---

## Set Desktop Background

Run:
```
xrandr | grep '*'
```

This will tell you the screen resolution

Find an image with that resolution or a similar resolution for the Desktop background

Download it to:
```
/home/user/backgrounds/
```
***(Note: You may need to make this directory)***

Right Click on the Desktop

Select `Desktop Settings`

Select the `Folder option > Other > Select the backgrounds directory`

Select the correct image

---

## Set Overview Background

(Note: The overview is the view when switching between desktops)

Go to `Settings > Appearance > Add Picture`

Add the correct picture