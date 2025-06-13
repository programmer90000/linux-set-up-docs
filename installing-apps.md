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