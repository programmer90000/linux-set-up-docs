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
