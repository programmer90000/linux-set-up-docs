#!/bin/bash

echo "Making directory"
mkdir ~/.config/alacritty/

echo "Refreshing package list"
sudo apt update

echo "Installing Tmux"
sudo apt install -y tmux

echo "Installing fonts-hack"
sudo apt install -y fonts-hack

echo "Copying alacritty.toml"
cp alacritty/alacritty.toml ~/.config/alacritty/alacritty.toml