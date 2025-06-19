#!/bin/bash

# Usage: ./check_internet.sh <target>
# Example: ./check_internet.sh 8.8.8.8 or ./check_internet.sh google.com

if [ $# -ne 1 ]; then
    echo "Usage: $0 <target> (e.g. 8.8.8.8 or google.com)"
    exit 1
fi

PING_TARGET="$1"

if ping -c 1 -W 2 "$PING_TARGET" > /dev/null; then
    echo "Internet is up (reachable: $PING_TARGET)."
    exit 0
else
    echo "Internet is DOWN (unreachable: $PING_TARGET)."
    exit 1
fi
