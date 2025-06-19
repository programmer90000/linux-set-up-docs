#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <network-prefix> (e.g. 192.168.1)"
    exit 1
fi

NETWORK="$1"

if ! [[ "$NETWORK" =~ ^([0-9]{1,3}\.){2}[0-9]{1,3}$ ]]; then
    echo "Invalid network prefix format. Expected format like: 192.168.1"
    exit 1
fi

for i in {1..254}; do
    IP="$NETWORK.$i"
    ping -c 1 -W 1 "$IP" &>/dev/null && echo "Host $IP is up" &
done

wait
