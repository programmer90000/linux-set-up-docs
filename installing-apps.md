# Installing apps on Debian Docs

## Writing the installation script

Run the following commands:
```
mkdir -p ~/scripts
nano ~/scripts/installer.sh
```

Go to the following URL: [Linux Download Tool Bash Script](https://github.com/programmer90000/linux-download-tool/blob/main/bash-script.bash)

Copy the script and paste it into the `installer.sh` file you created

Run the following commands:
```
chmod +x ~/scripts/extractor.sh
export PATH="$HOME/scripts:$PATH"
source ~/.bashrc
```

To install apps, you can now run:
```
installer.sh
```

## How to install apps

Run the following command:
```
installer.sh
```

In the first prompt, asking for the name of the directory to create, write the name of the directory to create (e.g. /opt/program-name).

In the second prompt, write the link or absolute file path to the installation file

> **Note: If the link does not lead directly to a file, such as a `.tar.gz` file, the installation will fail. To find the correct download, run:```curl -Ls -o /dev/null -w %{url_effective} "PASTE_YOUR_DOWNLOAD_LINK_HERE"```**

Depending on which file type was installed, the app may or may not be extracted.

After installation, you may need to move the files up one directory

### Installing Visual Studio Code

Go to the [Visual Studio Code Download page](https://code.visualstudio.com/Download#)

Right click on the correct Linux `.tar.gz` file for your computer

Copy the download link

Go to the terminal

Run:
```
curl -Ls -o /dev/null -w %{url_effective} "PASTE_YOUR_DOWNLOAD_LINK_HERE
```

Copy the link to the `.tar.gz` file found in the output

Run the installation  script:
```
installer.sh
```

In the first prompt, asking for the name of the directory to create, write: `/opt/visual-studio-code`

In the second prompt, asking for the URL to the file to download, enter the link you previously copied

Wait for the installation to complete

Run the following command:
```
cd /opt/visual-studio-code
ls
```

Remove all of the sub-directories and files in this directory except for the one containing Visual Studio Code

Run:
```
sudo mv /opt/visual-studio-code/DIRECTORY-CONTAINING-VISUAL-STUDIO-CODE/ /opt/visual-studio-code/
rm -rf DIRECTORY-CONTAINING-VISUAL-STUDIO-CODE/
```

To run Visual Studio Code from anywhere, run:
```
sudo ln -s /opt/visual-studio-code/code /usr/local/bin/code
```
#### Create Desktop Shortcut
To create a Desktop shortcut to Visual Studio Code, run:
```
cd ~/Desktop
touch visual-studio-code.desktop
nano visual-studio-code.desktop
```

Add the following lines to the file:
```
[Desktop Entry]
Name=Visual Studio Code
Comment=Open Visual Studio Code
Exec=/opt/visual-studio-code/code %F
Icon=/opt/visual-studio-code/resources/app/resources/linux/code.png
Terminal=false
Type=Application
Categories=Utility;Development;IDE;
StartupNotify=true
```

#### Create All Applications Shortcut
To create an All Applications shortcut to Visual Studio Code, run:

```
ls /usr/share/applications/
```

Ensure this directory contains all of the icons visible in the All Application menu

> **Note: Some or many of the icons may not be visible in the All Applications menu**

If it does, run the following command:
```
sudo cp /home/YOUR_USERNAME/Desktop/visual-studio-code.desktop /usr/share/applications/
```

If it doesn't, you will need to find the correct location of the All Application icons and copy the file there instead

### Installing Kdenlive Video Editor

Go to this site: [Kdenlive Download page](https://kdenlive.org/download/)

Download the AppImage file for Linux

The file should be installed in the Downloads directory

Run:
```
chmod +x kdenlive-25.04.2-x86_64.AppImage
sudo mkdir -p /opt/kdenlive
sudo mv squashfs-root /opt/kdenlive/
```

#### Create Desktop Shortcut
To create a Desktop shortcut to Kdenlive Video Editor, run:
```
cd ~/Desktop
touch kdenlive.desktop
nano kdenlive.desktop
```

Add the following lines to the file:
```
[Desktop Entry]
Name=Kdenlive
Comment=Open Kdenlive Video Editor
Exec=/opt/kdenlive/usr/bin/kdenlive
Icon=/opt/kdenlive/kdenlive.png
Terminal=false
Type=Application
Categories=AudioVideo;Video;AudioVideoEditing;
StartupNotify=true
```

#### Create All Applications Shortcut
To create an All Applications shortcut to Kdenlive, run:

```
ls /usr/share/applications/
```

Ensure this directory contains all of the icons visible in the All Application menu

> **Note: Some or many of the icons may not be visible in the All Applications menu**

If it does, run the following command:
```
sudo cp /home/YOUR_USERNAME/Desktop/kdenlive.desktop /usr/share/applications/
```

If it doesn't, you will need to find the correct location of the All Application icons and copy the file there instead