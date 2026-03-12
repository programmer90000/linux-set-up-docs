#!/bin/bash

echo "Refreshing package list"
sudo apt update

echo "Installing Labwc"
sudo apt install labwc

echo "Starting Labwc"
labwc