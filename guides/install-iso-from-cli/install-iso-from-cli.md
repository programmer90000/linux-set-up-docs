Run:
```
wget <URL-to-ISO-file>
```

Before inserting the USB drive, run:
```
lsblk
```

Insert the USB drive. The run the same command again:
```
lsblk
```

The new entry is your USB drive

Run:
```
sudo umount /dev/*
```

Write the iso file to the USB:
```
sudo dd if=debian-13.0.0-amd64-netinst.iso of=/dev/sdX bs=4M status=progress oflag=sync
sync
```

If you want to remove the USB, run:
```
sudo eject /dev/sdX
```

You can now restart your computer and boot into the USB drive