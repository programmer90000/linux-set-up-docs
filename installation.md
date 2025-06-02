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

---

## Set Lock Screen Background

### 1. Prepare your background image
Use a PNG or JPG image, ideally 1920x1080 or higher resolution.

Copy the image to a system-wide location accessible by GDM:
```
sudo cp yourimage.jpg /usr/share/backgrounds/gdm-background.jpg
sudo chmod 644 /usr/share/backgrounds/gdm-background.jpg
sudo chown root:root /usr/share/backgrounds/gdm-background.jpg
```

### 2. Install required tools
```
sudo apt update
sudo apt install libglib2.0-dev-bin
```

### 3. Create working directory and copy original GDM theme resource
```
mkdir ~/gdm-theme-edit && cd ~/gdm-theme-edit
sudo cp /usr/share/gnome-shell/gnome-shell-theme.gresource ./original.gresource
```

### 4. Extract the original CSS
```
gresource extract original.gresource /org/gnome/shell/theme/gnome-shell.css > gnome-shell.css
```

### 5. Edit the CSS to set your background image
```
nano gnome-shell.css
```

Locate the section starting with `#lockDialogGroup {` and modify it to:
```
#lockDialogGroup {
  background: #2c001e url(file:///usr/share/backgrounds/gdm-background.jpg);
  background-repeat: no-repeat;
  background-size: cover;
  background-position: center;
}
```
Save and exit (`Ctrl+O`, `Enter`, `Ctrl+X`).

### 6. Extract all original resources into folders
```
mkdir files
cd files
```
> **🔥 Run each of the lines in the following code block individually. Do not copy and paste the entire block:**
```
gresource list ../original.gresource | while read -r resource; do
  local_path="./${resource#/}"
  mkdir -p "$(dirname "$local_path")"
  gresource extract ../original.gresource "$resource" > "$local_path"
done
```

### 7. Replace the original CSS with your edited version
```
cp ../gnome-shell.css ./org/gnome/shell/theme/gnome-shell.css
```

### 8. Prepare the XML manifest for the resource compiler
```
cd org/gnome/shell/
```
Create or edit gnome-shell.gresource.xml:
```
nano gnome-shell.gresource.xml
```
Paste the full list of files extracted, like this example (make sure it includes all files from the original):
```
<?xml version="1.0" encoding="UTF-8"?>
<gresources>
  <gresource prefix="/org/gnome/shell/theme">
    <file>gnome-shell.css</file>
    <file>calendar-today-light.svg</file>
    <file>calendar-today.svg</file>
    <file>checkbox-focused.svg</file>
    <file>checkbox-off-focused-light.svg</file>
    <file>checkbox-off-focused.svg</file>
    <file>checkbox-off-light.svg</file>
    <file>checkbox-off.svg</file>
    <file>checkbox.svg</file>
    <file>gnome-shell-high-contrast.css</file>
    <file>gnome-shell-start.svg</file>
    <file>pad-osd.css</file>
    <file>process-working.svg</file>
    <file>toggle-off-hc.svg</file>
    <file>toggle-off-light.svg</file>
    <file>toggle-off.svg</file>
    <file>toggle-on-hc.svg</file>
    <file>toggle-on-light.svg</file>
    <file>toggle-on.svg</file>
    <file>workspace-placeholder.svg</file>
  </gresource>
</gresources>
```
Make sure this list exactly matches the output of:
```
gresource list ../../original.gresource
```

### 9. Recompile the resource
Return to your working directory:
```
cd ~/gdm-theme-edit
```
Run the compilation:
```
glib-compile-resources ./files/org/gnome/shell/gnome-shell.gresource.xml --target=gnome-shell-theme.gresource --sourcedir=files/org/gnome/shell/theme
```

### 10. Backup the original and replace the system theme
```
sudo cp /usr/share/gnome-shell/gnome-shell-theme.gresource /usr/share/gnome-shell/gnome-shell-theme.gresource.bak
sudo cp gnome-shell-theme.gresource /usr/share/gnome-shell/gnome-shell-theme.gresource
```

### 11. Restart GDM to apply changes
Warning: this will close all GUI sessions and log you out.
```
sudo systemctl restart gdm
```
Alternatively, reboot your system:
```
sudo reboot
```

## Taskbar Settings

Find the shell version you are using:
```
gnome-shell --version
```

Visit the: (Dash To Panel Extension)[https://extensions.gnome.org/extension/1160/dash-to-panel/] page

Install the latest version of the correct shell package (Click Install, do not open the automatically installed package)

Click Install in the new window that pops up

Open the Extensions Manager

Click Settings next to the newly added Dash to Panel extension

Configure the Settings for the extension

## Add Clipboard
Run:
```
sudo apt install gpaste-2
```

Run:
```
find /usr/share/applications/ ~/.local/share/applications/ -iname '*gpaste*'
```

Run the following command replacing `/path/to/gpaste-preferences.desktop` with the path to `gpaste-preferences.desktop`
```
sudo rm /path/to/gpaste-preferences.desktop
```

To open the GPate, click the icon in the Applications window or run:
```
gpaste-client ui
```

Configure the settings for GPaste