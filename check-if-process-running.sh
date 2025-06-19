#!/bin/bash

PROCESS="$1"

if pgrep -x "$PROCESS" > /dev/null; then
    echo "Process '$PROCESS' is running."
    exit 0
else
    echo "Process '$PROCESS' is NOT running."
    exit 1
fi
