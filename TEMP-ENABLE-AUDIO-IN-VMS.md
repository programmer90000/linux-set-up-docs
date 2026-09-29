NOTE: I DON'T KNOW IF THE UPDATE TO THE APT INSTALL COMMAND NEEDS UPDATING

1. Start the VM and login.
2. Shutdown the VM. NOTE: I DON'T KNOW IF THIS IS REQUIRED BUT IT SHOULD BE DONE ANYWAY FOR SAFETY
2. Run: ```
virt-xml debian-13 --edit --audio type=pipewire,id=1
virt-xml debian-13 --add-device --sound model=ich9,audio.id=1
```