#!/bin/bash

# Prompt user for a process name
read -rp "Enter process name to check (exact match): " PROCESS

# Exit if input is empty
if [ -z "$PROCESS" ]; then
    echo "No process name entered. Exiting."
    exit 1
fi

# Check if process is running
if pgrep -x "$PROCESS" > /dev/null; then
    echo "Process '$PROCESS' is running."
    exit 0
else
    echo "Process '$PROCESS' is NOT running."
    exit 1
fi
