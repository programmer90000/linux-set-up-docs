NOTE: I DON'T KNOW IF THE UPDATE TO THE APT INSTALL COMMAND NEEDS UPDATING

1. Start the VM and login.
2. Shutdown the VM. NOTE: I DON'T KNOW IF THIS IS REQUIRED BUT IT SHOULD BE DONE ANYWAY FOR SAFETY
2. Run: ```
virt-xml debian-13 --add-device --audio type=pipewire,id=1
virt-xml debian-13 --add-device --sound model=ich9,audio.id=1
```



NOTE: I ORIGINALLY RAN: `virt-xml debian-13 --edit id=1 --audio type=pipewire`. THIS DIDN'T WORK. THE ABOVE TWO COMMANDS WORKED. I NEED TO TEST IF IT WORKS