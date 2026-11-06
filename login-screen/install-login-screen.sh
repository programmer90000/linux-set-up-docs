#!/bin/bash

sudo apt update
sudo apt install -y greetd gtkgreet cage
sudo cp login-screen/config.toml /etc/greetd/config.toml
sudo cp login-screen/environments /etc/greetd/environments
sudo useradd -r -s /bin/false greeter
sudo usermod -aG video,input greeter
sudo systemctl enable greetd
sudo systemctl start greetd