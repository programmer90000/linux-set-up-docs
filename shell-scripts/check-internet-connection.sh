#!/bin/bash

# Usage: ./check_internet.sh
# Usage: Enter target (e.g. 8.8.8.8 or google.com)

# Prompt user for target
read -rp "Enter ping target (e.g. 8.8.8.8 or google.com): " PING_TARGET

# Exit if input is empty
if [ -z "$PING_TARGET" ]; then
    echo "No target entered. Exiting."
    exit 1
fi

# Check if target is reachable
if ping -c 1 -W 2 "$PING_TARGET" > /dev/null; then
    echo "Internet is up (reachable: $PING_TARGET)."
    exit 0
else
    echo "Internet is DOWN (unreachable: $PING_TARGET)."
    exit 1
fi
