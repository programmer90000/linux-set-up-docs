#!/bin/bash

ENVIRONMENT="labwc/environment"

if [ "$EUID" -eq 0 ]; then
    echo "Error: This script should not be run as root or with sudo."
    echo "Please run it as a regular user."
    exit 1
fi

if [ ! -f "$ENVIRONMENT" ]; then
    echo "Configuration file '$ENVIRONMENT' not found."
    echo "Please ensure the file exists in the correct location."
    exit 1
fi

echo "Refreshing package list"
log-command-output.sh ["Refreshing package list"] sudo apt update

echo "Installing Labwc"
log-command-output.sh ["Installing Labwc"] sudo apt install -y labwc

echo "Setting keyboard layout"
log-command-output.sh ["Making directory"] mkdir ~/.config/labwc/
log-command-output.sh ["Copying environment file"] cp $ENVIRONMENT ~/.config/labwc/

echo "Starting Labwc"
log-command-output.sh ["Starting Labwc"] labwc