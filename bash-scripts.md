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
check-internet-connection.sh PING_TARGET
```

Replace `PING_TARGET` with your ping target. For example:
```
check-internet-connection.sh 8.8.8.8
check-internet-connection.sh google.com
```