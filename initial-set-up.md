# Installation Docs for Debian

## Log-in

Set the `Desktop Session` in the bottom left corner to `Plasma (Wayland)`

## Enable Sudo Access For Your Account

Run:
```
sudo su
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

## Enable apt
Run:
```
sudo nano /etc/apt/sources.list
```

Remove all of the lines which already exist

Add the following lines to this file:
```
# Debian Bookworm Main Repositories
deb http://deb.debian.org/debian bookworm main contrib non-free non-free-firmware
deb-src http://deb.debian.org/debian bookworm main contrib non-free non-free-firmware

# Debian Bookworm Updates
deb http://deb.debian.org/debian bookworm-updates main contrib non-free non-free-firmware
deb-src http://deb.debian.org/debian bookworm-updates main contrib non-free non-free-firmware

# Debian Bookworm Security Updates
deb http://security.debian.org/debian-security bookworm-security main contrib non-free non-free-firmware
deb-src http://security.debian.org/debian-security bookworm-security main contrib non-free non-free-firmware
```

Run:
```
sudo apt update
sudo apt upgrade
```

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

## Configure the Application Launcher

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

- In the Search Menu, type `start-here-kde-plasma`

- Select the `start-here-kde-plasma` icon

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

Add the following widgets: `Peek at Desktop`, `Digital Clock`, `System Tray`, `Activities`, `Notifications`, `Margins Separator`, `Icons-only Task Manager`, `Application Dashboard`

Right-click on the Application Launcher

Select `Enter Edit Mode`

Select `Add Spacer`

Move the Panel Spacer to the left side of all widgets except for the `Application Dashboard` and `Icons-only Task Manager`

### Add Apps To Application Dashboard

Follow the docs in the [Application Dashboard directory](./application-dashboard/README.md)

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

Open the Dolphin File Manager

Go to your user profile directory

Replace both the `.face` and `.face.icon` images with [this image](./images/profile-picture.jpg)

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

Select `Configure Desktop and Wallpaper`

Set the `Layout` to `Desktop`

Set the `Wallpaper type` to `Image`

Set the `Positioning` to `Scaled and Cropped`

Select `+ Add Image`

Select the image you downloaded

Select the image in the Settings Window

---

## Change Lock Screen Apperance

Follow the docs found in the [Lock Screen directory](./lock-screen)

---

## Add Apps To Dash

Open the `All Applications` menu

Select the `All Applications` tab

Find the application you want to add to the taksbar

Right-click on the application

Select `Add to Panel (Widget)`


## Changing file icons

Right click on the application

Select `Properties`

Click on the Icon

Select an icon

Close the window

## Installing Custom Fonts

Follow the docs found in the [Fonts directory](./fonts)

## Change Sound Device Names

Run:
```
sudo apt install wireplumber pipewire pipewire-pulse
systemctl --user enable pipewire
systemctl --user start wireplumber
systemctl --user enable wireplumber
systemctl --user status wireplumber
```

This should output something like:
```
wireplumber.service - Multimedia Service Session Manager
Loaded: loaded (/usr/lib/systemd/user/wireplumber.service; enabled; preset: enabled)
Active: active (running) since Fri 2025-08-01 16:38:25 BST; 3min 20s ago
Main PID: 1045 (wirepLumber)
Tasks: 4 (Limit: 2279)
Memory: 8.4
CPU: 118ms
CGroup: /user.slice/user-1000.slice/user@1000.service/session.slice/wireplumber .service
        1015 /usr/bin/wireplumber
```

> Note: It may contain extra information

Run:
```
pw-cli list-objects | grep -E "node\.name|node\.description"
```

This should display the name and description of your audio devices

Copy the name of the audio device you want to rename

Run:
```
mkdir -p ~/.config/wireplumber/main.lua.d/
nano ~/.config/wireplumber/main.lua.d/50-rename-devices.lua
```

Add the following code to the file:
```lua
-- Rename Audio Device - AUDIO DEVICE NAME 1
rule1 = {
  matches = {
    {
      { "node.name", "equals", "AUDIO-DEVICE-NAME" },
    },
  },
  apply_properties = {
    ["node.description"] = "Speakers (Custom Name)",
  },
}

-- Rename Audio Device - AUDIO DEVICE NAME 2
rule2 = {
  matches = {
    {
      { "node.name", "equals", "alsa_output.usb-Device_Name-00.analog-stereo" },
    },
  },
  apply_properties = {
    ["node.description"] = "Headphones (Custom Name)",
  },
}

-- Rename Audio Device - AUDIO DEVICE NAME 3
rule3 = {
  matches = {
    {
      { "node.name", "equals", "alsa_input.usb-Microphone_Device-00.mono-fallback" },
    },
  },
  apply_properties = {
    ["node.description"] = "USB Microphone",
  },
}

table.insert(alsa_monitor.rules, rule1)
table.insert(alsa_monitor.rules, rule2)
table.insert(alsa_monitor.rules, rule3)
```

Run:
```
systemctl --user restart pipewire wireplumber pipewire-pulse
```

To see the updated name, run:
```
pw-cli list-objects | grep -E "node\.name|node\.description"
```

Hovering over the correct audio device in the volume menu should now display this updated name

## Keep Window In Focus After Opening New Window

Run:
```
nano ~/.config/kwinrc
```

Find the following section:
```
[Windows]
```

Add or modify the following lines in this section:
```
FocusPolicy=ClickToFocus
FocusStealingPreventionLevel=4
DelayFocusInterval=0
```

## Add Keyboard Shortcuts

### Add Keyboard Shortcut For Mute

Go to System Settings

Under `Workspace`, select `Shortcuts`

Select `Add Command`

Set the command to:
```
pactl set-sink-mute @DEFAULT_SINK@ toggle
```

Select `+ Add Custom Shortcut`

Set the command to `Mute` or a custom shortcut

### Add Keyboard Shortcut For Volume Up

Go to System Settings

Under `Workspace`, select `Shortcuts`

Select `Add Command`

Set the command to:
```
pactl set-sink-volume @DEFAULT_SINK@ +1%
```

Select `+ Add Custom Shortcut`

Set the command to `Volume Up` or a custom shortcut

### Add Keyboard Shortcut For Volume Down

Go to System Settings

Under `Workspace`, select `Shortcuts`

Select `Add Command`

Set the command to:
```
pactl set-sink-volume @DEFAULT_SINK@ -1%
```

Select `+ Add Custom Shortcut`

Set the command to `Volume Down` or a custom shortcut

### Add Keyboard Shortcut For Lock Session

Go to System Settings

Under `Workspace`, select `Shortcuts`

Select `Session Management`

Find the `Lock Session` command

Set it to `Super + L` or a custom shortcut

### Add Keyboard Shortcut For Renaming Files

Go to System Settings

Under `Workspace`, select `Shortcuts`

Select `File`

Find the `Rename` command

Set it to `F2` or a custom shortcut

### Add Keyboard Shortcuts For Cut, Copy, Paste

Go to System Settings

Under `Workspace`, select `Shortcuts`

Select `Edit`

#### Copy

Find the `Copy` command

Set it to `Ctrl + C` or a custom shortcut

#### Cut

Find the `Cut` command

Set it to `Ctrl + X` or a custom shortcut

#### Paste

Find the `Paste` command

Set it to `Ctrl + V` or a custom shortcut

### Add Keyboard Shortcuts For Undo, Redo

Go to System Settings

Under `Workspace`, select `Shortcuts`

Select `Edit`

#### Undo

Find the `Undo` command

Set it to `Ctrl + Z` or a custom shortcut

#### Redo

Find the `Redo` command

Set it to `Ctrl + Y` or a custom shortcut

## Set Mouse Wheel To Auto-Scroll When Clicked

Run:
```
sudo apt update
sudo apt install evtest ydotool libinput-tools
```

Run:
```
sudo evtest
```

Find the path to the mouse you want to configure

Run:
```
sudo nano /usr/local/bin/mouse-events.sh
```

Paste the code from [mouse-events.sh](./mouse/mouse-events.sh) into this file

Run:
```
chmod +x /usr/local/bin/mouse-events.sh
```

Run:
```
nano ~/start-mouse-events.sh
```

Paste the code from [start-mouse-events.sh](./mouse/start-mouse-events.sh) into this file

Make executable:
```bash
chmod +x ~/start-mouse-events.sh
```

### Create a sudoers rule for your mouse

Run:
```
sudo nano /etc/sudoers.d/evtest-mouse
```

Paste the code from [evtest-mouse](./mouse/evtest-mouse) into this file

Run:
```
sudo chmod 440 /etc/sudoers.d/evtest-mouse
```

### Test If The File Recognises The Middle Button Click

Run:
```
sudo evtest /dev/input/event5
```

With the file running, press the middle mouse button. You should see output similar to:
```
Event: time 170000.000000, type 1 (EV_KEY), code 274 (BTN_MIDDLE), value 1
```

### Configure Passwordless Sudo For Evtest

Run:
```
sudo visudo -f /etc/sudoers.d/evtest
```

Add the code from [evtest](./mouse/evtest) into this file. Replace the `/dev/input/event5` path with the correct path

### Test The Script

In a terminal, run the following command, replacing the path with the correct path:
```
sudo evtest /dev/input/event7
```

With this command running, in another terminal, run:
```
sudo ~/middleclick-handler.sh
```

Press the middle mouse button. A notification should appear when you press the middle mouse button

### Create Systemd Service (Autostart)

Run the following commands to create the service file:
```
mkdir ~/.config/systemd/user/
nano ~/.config/systemd/user/middleclick-handler.service
```

Add the code from [mouse-events-handler.service](./mouse/mouse-events-handler.service) into this file

Run the following commands to enable the files:
```
systemctl --user daemon-reload
systemctl --user enable middleclick-handler.service
systemctl --user start middleclick-handler.service
systemctl --user status middleclick-handler.service
journalctl --user -u middleclick-handler.service -f
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

## View logs shown during boot-up
Run:
```
journalctl -b > ~/boot_log_current.txt
sudo dmesg > ~/kernel_boot_log.txt
nano ~/kernel_boot_log.txt
```

To view only problems from the logs, run:
```
sudo journalctl -b -p err..warning --no-pager
```

> **Note: The logs will disappear after shutdown, unless they are saved using these commands**
