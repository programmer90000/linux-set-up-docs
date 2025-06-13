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