1. In the host machine and the VM, run:
```
sudo apt install pipewire pipewire-audio wireplumber
```
2. Shutdown the VM. NOTE: I DON'T KNOW IF THIS IS REQUIRED BUT IT SHOULD BE DONE ANYWAY FOR SAFETY
3. Run: ```
virt-xml debian-13 --edit --audio type=pipewire,id=1
virt-xml debian-13 --add-device --sound model=ich9,audio.id=1
```