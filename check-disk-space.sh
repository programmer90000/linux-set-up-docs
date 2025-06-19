#!/bin/bash

THRESHOLD=50 # Set the threshold percentage for disk usage

echo "----- Disk usage report at $(date) -----"
df -h

echo ""
echo "Checking for partitions over $THRESHOLD% usage..."
df -h | grep -vE '^Filesystem|tmpfs|cdrom' | while read -r line; do
    usage=$(echo $line | awk '{print $5}' | sed 's/%//')
    partition=$(echo $line | awk '{print $6}')
    if [ "$usage" -ge "$THRESHOLD" ]; then
        echo -e "\e[31mWARNING: Partition $partition is ${usage}% full.\e[0m"
    fi
done
