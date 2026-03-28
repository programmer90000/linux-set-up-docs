#!/bin/bash

SSH_KEY_NAME="id_ed25519"
SSH_KEY_PATH="$HOME/.ssh/$SSH_KEY_NAME"
SSH_PUB_PATH="${SSH_KEY_PATH}.pub"
SSH_EMAIL="abdulr568programming@outlook.com"
OUTPUT_CONFIG="$HOME/.ssh/config"

log-command-output.sh ["Creating ~/.ssh/ directory"] mkdir -p ~/.ssh/
log-command-output.sh ["Setting permissions for ~/.ssh directory"] chmod 700 ~/.ssh/
if ls ~/.ssh/${SSH_KEY_NAME}* 2>/dev/null >/dev/null; then
    log-command-output.sh ["SSH key files already exist. Skipping generating new ones"] true
else
    log-command-output.sh ["No SSH key files found. Generating new one"] ssh-keygen -t ed25519 -C "$SSH_EMAIL" -f "$SSH_KEY_PATH" -N ""
fi
if [ -f "$SSH_KEY_PATH" ]; then
    log-command-output.sh ["Setting permissions for SSH key file"] chmod 600 "$SSH_KEY_PATH"
fi
if [ -f "$SSH_PUB_PATH" ]; then
    log-command-output.sh ["Setting permissions for SSH pub file"] chmod 644 "$SSH_PUB_PATH"
fi
log-command-output.sh ["Starting SSH agent"] true
eval "$(ssh-agent -s)"
if [ $? -eq 0 ]; then
    log-command-output.sh ["SSH agent started successfully"] true
else
    log-command-output.sh ["SSH agent failed to start"] true
    exit 1
fi
if [ -f "$SSH_KEY_PATH" ]; then
    log-command-output.sh ["Add SSH key file to SSH agent"] ssh-add "$SSH_KEY_PATH"
fi