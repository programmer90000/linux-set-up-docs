#!/bin/bash
set -e

cargo build --release
sudo cp target/release/window-switcher /usr/local/bin/
sudo chmod +x /usr/local/bin/window-switcher
