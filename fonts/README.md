# How to install fonts

## Install the font system-wide

Run:
```
sudo mkdir -p /usr/share/fonts/custom
sudo cp /path/to/your/custom/font.ttf /usr/share/fonts/custom/
sudo chmod 644 /usr/share/fonts/custom/*.ttf
sudo fc-cache -fv
fc-list | grep "Your Font Name"
```

## Install the font only for your user

Run:
```
mkdir -p ~/.local/share/fonts/
cp /path/to/your/custom/font.ttf ~/.local/share/fonts/
fc-cache -fv
```