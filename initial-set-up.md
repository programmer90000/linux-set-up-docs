# Installation Docs for Debian

## Log-in

Set the `Desktop Session` in the bottom left corner to `Plasma (Wayland)`

## Enable Sudo Access For Your Account

Run:
```
su -
usermod -aG sudo YOURUSERNAME
exit
```

Run:
```
groups yourusername
```

Ensure that sudo appears in the list of groups. 

Log out and back in

Run:
```
sudo whoami
```
This should return ```root```

> **Note: If `sudo whoami` doesn't return `root` after logging out and back in, restart the PC**

## Configure the Application Launcher

### Edit Applications

Right-click on the Application Launcher

Select `Edit Applications`

Right-click on each application submenu and delete it

Create the following submenus: `Internet`, `Image & Video`, `Development`, `LibreOffice`, `Utilities`, `Settings`, `System`

Right-click on each submenu and select `New Item`

Enter the name of the application to be added to this submenu

Add a description, icon and select the program to launch

Enable `Enable launch feedback`

Disable `Only show when logged into a Plasma session`

### Configure Application Dashboard

Right-click on the Application Launcher

Select `Configure Application Dashboard`

Select the `Icon`

Select `Choose...`

Set the types of icons to `All`

In the Search Menu, type `show-grid`

Select the `show-grid` icon

Set `Show application as` to `Name only`

Disable `Sort applications alphabetically`

Under `Show Categories`, enable `Often used applications`

Under `Show Categories`, disable `Often used files` and `Often used contacts`

Set `Sort items in categories by:` to `Often used`

Enable `Expand search to bookmarks, files and emails`

In the right-hand menu, select `Keyboard Shortcuts`

Delete any keyboard shortcuts

### Change Application Launcher View

Right-click on the Application Launcher

Select `Show Alternatives`

Select `Application Dashboard`

Select `Switch`

### Add Widgets

Right-click on the Application Launcher

Select `Add Widgets`

Add the following widgets from right to left: `Peek at Desktop`, `Digital Clock`, `System Tray`, `Activities`, `Window List`, `Notifications`, `Clipboard`, `Margins Separator`, `Panel Spacer`, `Application Dashboard`

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
Exec=konsole
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
---

## Set Profile Picture

Open the System Settings app

Select `Users` from the sidebar

Click the profile picture

Select `Choose a File`

Select your profile picture

Select `Apply`

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

Select `Change Background`

Select `+ Add Picture` in the Settings Window

Select the image you downloaded

Select the image in the Settings Window

---

## Change Lock Screen Apperance

### 1. Prepare your background image
Use a PNG or JPG image, ideally 1920x1080 or higher resolution.

### 2. Install Flatpak

Run:
```
sudo apt install flatpak
```

### 3. Install the Software Flatpak plugin

Run:
```
sudo apt install gnome-software-plugin-flatpak
```

### 4. Add the Flathub repository

Run:
```
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
```

### 5. Restart your computer

> Note: The `flatpak` command wil be usable but may result in errors until you restart your computer

### 6. Install GDM Settings

Run:
```
flatpak install flathub io.github.realmazharhussain.GdmSettings
```

### 7. Run GDM Settings

Run:
```
flatpak run io.github.realmazharhussain.GdmSettings
```

### 8. Configure the lock screen apperance

> Note: All of the options in **all** tabs are to configure the lock screen apperance

### 9. Apply Changes

Click the `Apply` button in the top left hand side of the window

### 9. Restart the computer to apply changes

> Note: Logging out may apply the changes but it is better to restart

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

## Add Apps To Taskbar

Visit the: (Favourites In AppGrid Extension)[https://extensions.gnome.org/extension/4485/favourites-in-appgrid/] page

Install the latest version of the correct shell package (Click Install, do not open the automatically installed package)

Click Install in the new window that pops up

Open the `All Applications` view

Right-click on an application

Select `Pin to Dash`

## Add Mute Volume Button To System Menu

Visit the (Mute/Unmute Extension)[https://extensions.gnome.org/extension/5088/muteunmute/] page

Install the latest version of the correct shell package (Click Install, do not open the automatically installed package)

Click Install in the new window that pops up

Open the System Menu

Click the volume icon to mute

## Enable Dark Mode

Click on the Power, Sound and WiFi icon

Enable Dark Mode

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

## Add Close, Maximize, Minimize buttons to every window
Run:
```
sudo apt install gnome-tweaks
gnome-tweaks
```

Go to the `Window Titlebars` tab
Enable the `Maximize`, `Minimize` buttons

## Install Nemo File Manager
Run:
```
sudo apt update
sudo apt install -y nemo
```

Open nemo by typing `nemo` into the terminal or clicking the nemo app icon
Click `Edit > Perferences`
Set your preferences for nemo

### Install bat

The `bat` command allows you to view files in the terminal, similar to the `cat` command but with syntax highlighting

Run:
```
sudo apt install bat
```

To use bat, run:
```
batcat file-name
```

## Install tree

The `tree` command is similar to the `ls` commands but displays all sub-directories and files in a tree diagram

Run:
```
sudo apt update
sudo apt install tree
```

To use `tree`, run:
```
tree
```

## Install duf

The `duf` command allows you to view the amount of space used and the amount of free space on your drives

Run:
```
sudo apt update
sudo apt install duf
```

To use `duf`, run:
```
duf
```

## Changing file icons

Right click on the application

Select `Properties`

Click on the Icon

Select an icon

Close the window

## Install Custom Fonts

### Install Custom Font File
Supported font formats: `.ttf` or `.otf`

Copy the font to a system directory:
```
sudo mkdir -p /usr/local/share/fonts/custom
sudo cp /path/to/your/fontfile.ttf /usr/local/share/fonts/custom/
sudo chmod 644 /usr/local/share/fonts/custom/*.ttf
```

Update font cache:
```
sudo fc-cache -fv
```

Confirm installation:
```
fc-list | grep "Your Custom Font"
```

### Set as Default for GNOME Applications
This affects GTK-based apps, menus, and desktop UI.

Set the general interface font:
```
gsettings set org.gnome.desktop.interface font-name 'Your Custom Font 11'
```

Set the monospace font (used in terminals, editors):
```
gsettings set org.gnome.desktop.interface monospace-font-name 'Your Custom Font Mono 11'
```

Verify settings:
```
gsettings get org.gnome.desktop.interface font-name
gsettings get org.gnome.desktop.interface monospace-font-name
```

### Window Title Font (Titlebars)
Modern GNOME Shell does not allow changing the titlebar font via gsettings.

Identify the GTK theme you use:
```
gsettings get org.gnome.desktop.interface gtk-theme
```

Open the theme’s CSS file:
```
sudo nano /usr/share/themes/<ThemeName>/gnome-shell/gnome-shell.css
```
Find the section like:

```css
.title {
  font-family: "Sans";
  font-size: 11pt;
}
```

Change it to:
```css
font-family: "Your Custom Font";
```

You may need to restart GNOME Shell or reboot.

### Set Font for Console (TTY)
Virtual consoles (Ctrl+Alt+F3, etc.) use bitmap .psf fonts only.

Set font temporarily:
```
sudo setfont /usr/share/consolefonts/YourFont.psf
```

Set font permanently:
Edit `/etc/default/console-setup` and set:
```
FONTFACE="YourFontFace"
FONTSIZE="YourFontSize"
```

Then run:
```
sudo setupcon
```

Use `dpkg-reconfigure console-setup` to see available fonts interactively.

### Set as Default Font in Xorg (All Applications)
This method forces your font system-wide across all X11 apps (Xorg), including GTK and Qt apps.

⚠️ Use with caution — may break apps that depend on specific fonts or language scripts.
Create `/etc/fonts/local.conf`:
```
sudo nano /etc/fonts/local.conf
```

Add:
```xml
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
  <match>
    <edit name="family" mode="assign" binding="strong">
      <string>Your Custom Font</string>
    </edit>
  </match>
</fontconfig>
```

Rebuild font cache:
```
sudo fc-cache -fv
```

Reboot:

```bash
sudo reboot
```

## Change Auto-Start programs
Run:
```
systemctl list-unit-files --type=service --state=enabled
```

This will show the list of services that can start on boot and wether they start on boot or not
> **The State field determines if the service starts on boot or not**

### Stop a service starting on boot
Run:
```
sudo systemctl disable name-of-service.service
```

### Add a new service to start at boot
Create the service unit file:
```
sudo nano /etc/systemd/system/myservice.service
```
Add this template:
```
[Unit]
Description=My Custom Program
After=network.target

[Service]
ExecStart=/path/to/your/script.sh
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

`multi-user.target` means it starts during the regular boot runlevel (like rc3 in SysVinit).

Enable and start it:
```
sudo systemctl daemon-reload
sudo systemctl enable myservice.service
sudo systemctl start myservice.service
```

Verify status:
```
systemctl status myservice.service
```

### Enable a previously disabled service

Run:
```
sudo systemctl enable <service>.service
```
Confirm it's enabled:
```
systemctl is-enabled <service>.service
```
It should return:
```
enabled
```

## Change the position of notifications

Open the Extension Manager

Find the `Notification Banner Reloaded` extension by `Marcin Jakubowski`.

Install it

Customize the notification positioning to your preferences

## View logs shown during boot-up
Run:
```
journalctl -b > ~/boot_log_current.txt
sudo dmesg > ~/kernel_boot_log.txt
nano ~/kernel_boot_log.txt
```

> **Note: The logs will disappear after shutdown, unless they are saved using these commands**

## Change boot theme

The boot theme is the theme displayed between the option for selecting which UI to use and the lock screen. The boot theme is also displayed when the OS is shutting down

Run:
```
sudo apt update
sudo apt install plymouth plymouth-themes
```

Run:
```
sudo reboot
```

> Run `sudo reboot` in order to allow plymouth to run correctly

List avaliable themes using:
```
sudo plymouth-set-default-theme --list
```

To select a theme, run:
```
sudo plymouth-set-default-theme emerald
```

> **Replace `emerald` with your selected theme**

Run:
```
sudo update-initramfs -u
```

Run:
```
sudo nano /etc/default/grub
```

Look for a line like:
```
GRUB_CMDLINE_LINUX_DEFAULT="quiet"
```

Change it to:
```
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"
```

Run:
```
sudo update-grub
```

Create a new file to test the boot theme:
```
nano test-boot-theme.sh
```

Paste the following lines into this file and then save it:
```
sudo plymouthd
sudo plymouth --show-splash
sleep 5
sudo plymouth quit
```

Run:
```
chmod +x test-boot-theme.sh
./test-boot-theme.sh
```

> **If a black screen appears, you may need to run `sudo reboot` and then preview each theme using this method**

Reboot the system to view the theme:
```
sudo reboot
```
