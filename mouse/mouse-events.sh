#!/bin/bash

MOUSE_DEVICE="/dev/input/event7" # Your mouse device path
LOG_FILE="/tmp/middleclick.log"
USERNAME=$(whoami)

middle_click_action() {
    notify-send "Middle Click" "Button pressed at $(date '+%H:%M:%S')"
    echo "$(date): Middle click detected - action executed by $USERNAME" >> "$LOG_FILE"
}

# Check if already running
if pidof -x "$(basename "$0")" -o $$ >/dev/null; then
    echo "$(date): Script already running. Exiting." >> "$LOG_FILE"
    exit 1
fi

# Log start
echo "=== $(date): Starting middle click monitor on $MOUSE_DEVICE ===" >> "$LOG_FILE"
echo "Running as user: $USERNAME" >> "$LOG_FILE"

# Main monitoring loop
sudo evtest "$MOUSE_DEVICE" | while read -r line; do
    # Detect middle button PRESS (value 1)
    if echo "$line" | grep -q "code 274 (BTN_MIDDLE), value 1"; then
        echo "$(date): Middle button PRESSED" >> "$LOG_FILE"
        middle_click_action
    fi

done