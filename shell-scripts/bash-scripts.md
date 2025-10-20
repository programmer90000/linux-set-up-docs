# Adding Bash Scripts to Debian Docs

## Check Internet Connection

Run:
```
cd /usr/local/bin/
sudo touch check-internet-connection.sh
sudo nano check-internet-connection.sh
```

Paste the contents of [check-internet-connection](check-internet-connection.sh) into this file and save the file

Run:
```
sudo chmod +x check-internet-connection.sh
```

To run the file, run:
```
check-internet-connection.sh
```

This will prompt you to enter a ping target, such as `8.8.8.8` or `google.com`

## Check If Process Is Running

Run:
```
cd /usr/local/bin/
sudo touch check-if-process-running.sh
sudo nano check-if-process-running.sh
```

Paste the contents of [check-if-process-running.sh](check-if-process-running.sh) into this file and save the file

Run:
```
sudo chmod +x check-if-process-running.sh
```

To run the file, run:
```
check-if-process-running.sh
```

This will prompt you to enter a process name, such as `bash`

## Network Ping Scan Script

This script is used to troubleshoot connectivity issues by verifying which devices respond.


Run:
```
cd /usr/local/bin/
sudo touch network-ping.sh
sudo nano network-ping.sh
```

Paste the contents of [network-ping.sh](network-ping.sh) into this file and save the file

Run:
```
sudo chmod +x network-ping.sh
```

To run the script, use:
```
network-ping.sh
```

This will prompt you to enter a ping target, such as `192.168.1` or `10.0.0`

The script will ping every avaliable host from `NETWORK_PREFIX.1` to `NETWORK_PREFIX.254` and print a message for each host that is up:
```
Host 192.168.1.5 is up
Host 192.168.1.12 is up
```

## Check Disk Space

Run:
```
cd /usr/local/bin/
sudo touch check-disk-space.sh
sudo nano check-disk-space.sh
```

Paste the contents of [check-disk-space.sh](check-disk-space.sh) into this file and save the file

Run:
```
sudo chmod +x check-disk-space.sh
```

To run the file, run:
```
check-disk-space.sh
```