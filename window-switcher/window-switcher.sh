#!/bin/bash

# Create temporary file to store window list
temp_file=$(mktemp)

# Get window list from wlrctl and format as "title|app_id"
wlrctl window list 2>/dev/null | while IFS=: read -r app_id title; do
    app_id=$(echo "$app_id" | xargs)
    title=$(echo "$title" | xargs)
    
    if [ -n "$title" ] && [ "$title" != "title" ]; then
        echo "$title|$app_id"
    fi
done > "$temp_file"

if [ ! -s "$temp_file" ]; then
    echo "No windows found" >&2
    rm -f "$temp_file"
    exit 0
fi

# Extract titles for display
display_list=$(cat "$temp_file" | cut -d'|' -f1)

selected=$(echo "$display_list" | fuzzel --dmenu --prompt="Window: ")

rm -f "$temp_file"
