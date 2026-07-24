#!/bin/bash

# Debug mode (set to 1 for verbose output)
DEBUG=0

debug_log() {
    if [ "$DEBUG" -eq 1 ]; then
        echo "DEBUG: $*" >&2
    fi
}

# Create temporary file to store window list
temp_file=$(mktemp)

debug_log "Starting window discovery..."

# Get window list from wlrctl and format as "title|app_id"
wlrctl window list 2>/dev/null | while IFS=: read -r app_id title; do
    app_id=$(echo "$app_id" | xargs)
    title=$(echo "$title" | xargs)
    
    if [ -n "$title" ] && [ "$title" != "title" ]; then
        debug_log "Found window: app_id='$app_id', title='$title'"
        echo "$title|$app_id"
    fi
done > "$temp_file"

if [ ! -s "$temp_file" ]; then
    echo "No windows found" >&2
    rm -f "$temp_file"
    exit 0
fi

debug_log "Window discovery complete. Temp file contents:"
debug_log "$(cat "$temp_file")"

# Extract titles for display
display_list=$(cat "$temp_file" | cut -d'|' -f1)

selected=$(echo "$display_list" | fuzzel --dmenu --prompt="Window: ")

rm -f "$temp_file"
