#!/bin/bash
# Wrapper to start mouse events handler with sudo permissions

# Create log directory
mkdir -p ~/.local/log

# Export DBUS session for GUI
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"
export XDG_RUNTIME_DIR="/run/user/$(id -u)"
export DISPLAY=:0
export WAYLAND_DISPLAY=wayland-0

# Start the monitor with sudo for evtest
sudo /home/abdul/.mouse/mouse-events.sh