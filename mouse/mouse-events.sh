#!/bin/bash

MOUSE_DEVICE="/dev/input/event7"
LOG_FILE="/tmp/middleclick-$(whoami).log"
USER_HOME="/home/abdul"
SCRIPT_PATH="$USER_HOME/middleclick-handler-fixed.sh"

middle_click_action() {
    su abdul -c "DISPLAY=:0 WAYLAND_DISPLAY=wayland-0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u abdul)/bus notify-send 'Middle Click' 'Detected!'"
    echo "$(date): Action executed" >> "$LOG_FILE"
}

echo "=== $(date): Starting middle click handler ===" >> "$LOG_FILE"
echo "Device: $MOUSE_DEVICE" >> "$LOG_FILE"
echo "User: $(whoami)" >> "$LOG_FILE"

# Main loop
evtest "$MOUSE_DEVICE" | while read -r line; do
    if echo "$line" | grep -q "code 274 (BTN_MIDDLE), value 1"; then
        echo "$(date): Middle button pressed" >> "$LOG_FILE"
        middle_click_action
    fi
done