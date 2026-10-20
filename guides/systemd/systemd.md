# Systemd

Systemd is an init system. It is the first process that runs. It's job is to manage all other processes, system services and background processes

A `unit` is anything systemd is able to manage.

## Systemd unit files

Systemd unit files can be stored in multiple directories. Files in a higher directory take priority:
```
/etc/systemd/system/
/run/systemd/system/
/lib/systemd/system/
```

## Systemctl

`systemctl` stands for system control

### Systemctl commands

`systemctl status UNIT-NAME` - Find out if a systemd unit is running and if it autostarts on boot

`sudo systemctl start UNIT-NAME` - Start a unit

`sudo systemctl stop UNIT-NAME` - Stop a unit

`sudo systemctl restart UNIT-NAME` - Restart a unit. Needed after changing config files

`sudo systemctl enable UNIT-NAME` - Set a unit to autostart on boot

`sudo systemctl disable UNIT-NAME` - Stop a unit from auto-starting on boot

`sudo systemctl edit UNIT-FILE` - Edit a systemd file. Any edits must be made inside the correct section or they will be discarded.

Only the contents inside the file will be written. To copy the entire file, use the `--full` flag.

The file will be saved in `/etc/systemd/system/` directory

To cause systemd to read the updated unit files, run `sudo systemctl daemon-reload`