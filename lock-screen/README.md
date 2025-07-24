Create a new directory titled `lock-screen`

Copy the `Main.qml` and `theme.conf` files into it

Copy the `background.jpg` and `user-icon.png` files into the `assets` directory

Copy the `lock-screen` directory to `/usr/share/sddm/themes/lock-screen` and `~/.local/share/sddm/themes/lock-screen` by running:
```
sudo cp -r lock-screen/ /usr/share/sddm/themes/
cp -r lock-screen/ ~/.local/share/sddm/themes/
```

Run:
```
sudo nano /etc/sddm.conf
```

Copy the `sddm.conf` file into it

Run:
```
sudo systemctl restart sddm
```
