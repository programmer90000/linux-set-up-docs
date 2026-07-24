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

# Get window list from wlrctl and format as "timestamp|app_id|title"
wlrctl window list 2>/dev/null | while IFS=: read -r app_id title; do
    app_id=$(echo "$app_id" | xargs)
    title=$(echo "$title" | xargs)
    
    if [ -n "$title" ] && [ "$title" != "title" ]; then
        debug_log "Found window: app_id='$app_id', title='$title'"
        
        # Get window PID and creation time
        pid=$(wlrctl window get-pid app-id:"$app_id" title:"$title" 2>/dev/null)
        if [ -n "$pid" ]; then
            if [ -f "/proc/$pid/stat" ]; then
                start_time=$(awk '{print $22}' "/proc/$pid/stat")
                boot_time=$(date -d "now - $(awk '{print int($1)}' /proc/uptime) seconds" +%s)
                creation_timestamp=$((boot_time + start_time / 100))
                debug_log "Got creation time from proc: $creation_timestamp"
            else
                creation_timestamp=$(stat -c %Y "/proc/$pid" 2>/dev/null || date +%s)
                debug_log "Got creation time from stat: $creation_timestamp"
            fi
        else
            creation_timestamp=$(date +%s)
            debug_log "Using current time as creation timestamp: $creation_timestamp"
        fi
        
        # Store window info with creation timestamp
        echo "${creation_timestamp}|${app_id}|${title}" >> "$temp_file"
        debug_log "Stored: ${creation_timestamp}|${app_id}|${title}"
    fi
done

if [ ! -s "$temp_file" ]; then
    echo "No windows found" >&2
    rm -f "$temp_file"
    exit 0
fi

debug_log "Window discovery complete. Temp file contents:"
debug_log "$(cat "$temp_file")"

# Extract titles for display
display_list=$(cat "$temp_file" | cut -d'|' -f3)

selected=$(echo "$display_list" | fuzzel --dmenu --prompt="Window: ")

rm -f "$temp_file"
