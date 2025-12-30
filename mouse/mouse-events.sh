#!/bin/bash

MOUSE_DEVICE="/dev/input/event7" # Your mouse device path
LOG_FILE="$HOME/.local/log/middleclick.log"
USERNAME=$(whoami)

mkdir -p "$LOG_DIR"

middle_click_action() {
    export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"
    export XDG_RUNTIME_DIR="/run/user/$(id -u)"

    /usr/bin/notify-send "Middle Click" "Button pressed at $(date '+%H:%M:%S')"
    echo "$(date): Middle click detected - action executed by $USERNAME" >> "$LOG_FILE"
}

# Check if already running
if pidof -x "$(basename "$0")" -o $$ >/dev/null 2>&1; then
    echo "$(date): Script already running. Exiting." >> "$LOG_FILE"
    exit 1
fi

# Log start
echo "=== $(date): Starting middle click monitor on $MOUSE_DEVICE ===" >> "$LOG_FILE"
echo "Running as user: $USERNAME, UID: $(id -u)" >> "$LOG_FILE"

# Main monitoring loop
/usr/bin/evtest "$MOUSE_DEVICE" 2>> "$LOG_FILE" | while read -r line; do
    # Detect middle button PRESS (value 1)
    if echo "$line" | grep -q "code 274 (BTN_MIDDLE), value 1"; then
        echo "$(date): Middle button PRESSED" >> "$LOG_FILE"
        su "$USERNAME" -c "source $HOME/.bashrc; $HOME/middleclick-handler.sh --action" &
    fi
done