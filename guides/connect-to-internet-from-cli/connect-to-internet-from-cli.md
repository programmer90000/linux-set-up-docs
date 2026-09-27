# Connect to the internet via the CLI

### Check if Linux recognised your network adapter

Run:
```
lspci -nnk | grep -iA3 net
```

If this doesn't return anything, run:
```
lsusb
```

Find your network adapter

### Connect to the WiFi temporarily using an Ethernet cable or USB tethering from a phone or different device

Run:
```
sudo ip link
```

This should show connections. If connected via phone USB tethering, look for one beginning with
```
enp
```
or
```
enx
```

Run:
```
sudo dhcpcd NAME-OF-THE-NETWORK-CONNECTION
```

Run:
```
sudo nano /etc/apt/sources.list
```

Remove all of the text and replace it with the following:
```
deb http://deb.debian.org/debian/ trixie main contrib non-free-firmware non-free
deb-src http://deb.debian.org/debian/ trixie main contrib non-free-firmware non-free

deb http://security.debian.org/debian-security trixie-security main contrib non-free-firmware non-free
deb-src http://security.debian.org/debian-security trixie-security main contrib non-free-firmware non-free

deb http://deb.debian.org/debian/ trixie-updates main contrib non-free-firmware non-free
deb-src http://deb.debian.org/debian/ trixie-updates main contrib non-free-firmware non-free
```

Run:
```
sudo apt update
sudo apt install -y git build-essential dkms linux-headers-$(uname -r) network-manager
```

The next steps are dependant on your WiFi card. For my card, run:
```
git clone https://github.com/Mange/rtl8192eu-linux-driver.git
cd rtl8192eu-linux-driver
sudo dkms add .
sudo dkms install rtl8192eu/1.0
echo "blacklist rtl8xxxu" | sudo tee /etc/modprobe.d/rtl8xxxu.conf
sudo modprobe 8192eu
ip link
sudo systemctl start NetworkManager
```

> Note: For safety, ensure you use an official repository. If an official repository doesn't exist, use a repository with a large number of stars and forks

After this, run:
```
sudo nmcli device wifi list
```

Find your network SSID

Run:
```
sudo nmcli device wifi connect "Your_SSID" password "Your_Password"
```