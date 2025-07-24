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

## Set Theme

Open the `System Settings` app

Select `Appearance` from the left-hand side menu

Select `Global Theme`

- Select `Breeze Dark`

   - Apply the changes to both `Apperance Settings` and `Desktop and window layout`

Select `Application Style`

- Set it to `Oxygen`

Select `Plasma Style`

- Set it to `Oxygen`

Select `Colours`

- Set it to `Breeze Dark`

Select `Windows Decorations`

- Set it to `Plastik`

Select `Fonts`

- Set `General` to `Noto Sans 10pt`
- Set `Fixed Width` to `Hack 10pt`
- Set `Small` to `Noto Sans 8pt`
- Set `Toolbar` to `Noto Sans 10pt`
- Set `Menu` to `Noto Sans 10pt`
- Set `Windows Title` to `Noto Sans 10pt`
- Enable `Anti-Aliasing`
- Disable `Exclude range from anti-aliasing`
- Set `Sub-pixel rendering` to `None`
- Set `Hinting` to `None`
- Disable `Force font DPI`

Select `Icons`

- Set it to `Breeze Dark`

Select `Cursors`

- Set it to `Adwaita`

Select `Splash Screen`

- Set it to `None`

## Delete Unneeded Apps

Open the `Discover` app

Select `Installed` in the left menu

Remove all unneeded apps

> ***Do not delete packages. Only delete apps found in the application launcher***

The final list of installed apps in the `Discover` app should be the same as the list in the [installed-apps-and-packages.md file](installed-apps-and-packages.md)

## Configure the Application Launcher

### Edit Applications

Right-click on the Application Launcher

Select `Edit Applications`

Right-click on each application submenu and delete it

Image & VideoCreate the following parent submenus: `Internet`, `Image & Video`, `Development`, `LibreOffice`, `Utilities`, `Settings`, `System`

Drag each submenu out so they are all parent submenus

Right-click on each submenu and select `New Item`

Enter the name of the application to be added to this submenu

Add a description, icon and select the program to launch

> To find the program executable to launch, open the terminal and run: `which PROGRAM-NAME`. The file path output is the program executable to write

Enable `Enable launch feedback`

Disable `Only show when logged into a Plasma session`

> Note: Adding applications to each submenu should be done after installing all of the apps

### Change Application Launcher View

Right-click on the Application Launcher

Select `Show Alternatives`

Select `Application Dashboard`

Select `Switch`

### Configure Application Dashboard

Right-click on the Application Launcher

Select `Configure Application Dashboard`

- Select the `Icon`

- Select `Choose...`

- Set the types of icons to `All`

- In the Search Menu, type `show-grid`

- Select the `show-grid` icon

Set `Show application as` to `Name only`

Disable `Sort applications alphabetically`

Set `Sort items in categories by:` to `Often used`

Under `Show Categories`, enable `Often used applications`

Under `Show Categories`, disable `Often used files` and `Often used contacts`

Enable `Expand search to bookmarks, files and emails`

In the right-hand menu, select `Keyboard Shortcuts`

Delete any keyboard shortcuts

### Clear Panel

Right-click on the panel

Select `Enter Edit Mode`

Right-click on each item in the panel

Select `Remove`

### Add Widgets

Right-click on the Application Launcher

Select `Add Widgets`

Add the following widgets: `Peek at Desktop`, `Digital Clock`, `System Tray`, `Activities`, `Notifications`, `Clipboard`, `Margins Separator`, `Icons-only Task Manager`, `Application Dashboard`

Right-click on the Application Launcher

Select `Enter Edit Mode`

Select `Add Spacer`

Move the Panel Spacer to the left side of all widgets except for the `Application Dashboard` and `Icons-only Task Manager`

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

> Note: If a warning sign appears above the icon, right-click on the desktop and select `Refresh Desktop`

Do this for all files on [this page](https://github.com/programmer90000/linux-set-up-docs/tree/debian/desktop)

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
> ***(Note: You may need to make this directory)***

Right Click on the Desktop

Select `Change Background`

Select `+ Add Picture` in the Settings Window

Select the image you downloaded

Select the image in the Settings Window

---

## Change Lock Screen Apperance

Follow the docs found in the [Lock Screen directory](./lock-screen)

---

## Add Apps To Taskbar

Open the `All Applications` menu

Select the `All Applications` tab

Find the application you want to add to the taksbar

Right-click on the application

Select `Add to Panel (Widget)`


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

## Changing file icons

Right click on the application

Select `Properties`

Click on the Icon

Select an icon

Close the window

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

Reboot the system to view the theme:
```
sudo reboot
```
