# Installing apps on Debian Docs

### Installing Visual Studio Code

Run:
```
sudo apt update
sudo apt install -y software-properties-common apt-transport-https wget
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/code stable main"
sudo apt update
sudo apt install -y code
```

#### Create Desktop Shortcut

To create a Desktop shortcut to Visual Studio Code, run:
```
cp /usr/share/applications/code.desktop ~/Desktop/
chmod +x ~/Desktop/code.desktop
```

### Installing Kdenlive Video Editor

Run:
```
sudo apt update
sudo apt install kdenlive
```

#### Create Desktop Shortcut

To create a Desktop shortcut to Kdenlive, run:
```
cp /usr/share/applications/org.kde.kdenlive.desktop ~/Desktop/
chmod +x ~/Desktop/org.kde.kdenlive.desktop
```

### Installing FileZilla

Run:
```
sudo apt update
sudo apt install filezilla
```

To create a Desktop shortcut to FileZilla, run:
```
cp /usr/share/applications/filezilla.desktop ~/Desktop/
chmod +x ~/Desktop/filezilla.desktop
```

### Installing Google Chrome

Run:
```
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb
```

To create a Desktop shortcut to Google Chrome, run:
```
cp /usr/share/applications/google-chrome.desktop ~/Desktop/
```

### Installing Mousepad text editor

Run:
```
sudo apt update
sudo apt install mousepad
```

To create a Desktop shortcut to Mousepad, run:
```
cp /usr/share/applications/org.xfce.mousepad.desktop ~/Desktop/
```