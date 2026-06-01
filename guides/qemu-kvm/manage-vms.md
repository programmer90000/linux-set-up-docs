Run:
```
virt-install --name debian-13 --memory 2048 --vcpus 1 --disk size=3,format=qcow2 --os-variant=debian13 --cdrom /home/abdul/Downloads/debian-13.5.0-amd64-netinst.iso --network default --graphics vnc,listen=127.0.0.1,port=5901 --noautoconsole
```

Change the name, memory, vcpus, disk size, OS variant, cdrom and listen appropriately
