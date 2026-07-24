#!/bin/bash

# Debug mode (set to 1 for verbose output)
DEBUG=0

debug_log() {
    if [ "$DEBUG" -eq 1 ]; then
        echo "DEBUG: $*" >&2
    fi
}

# Function to build display list with different sort orders
build_display_list() {
    local sort_order="$1"
    local display_list=""
    
    case "$sort_order" in
        "Newest Created")
            # Sort apps by newest creation timestamp first
            sorted_apps=()
            for app_id in "${!app_latest_creation[@]}"; do
                sorted_apps+=("${app_latest_creation[$app_id]}|$app_id")
            done
            IFS=$'\n' sorted_apps=($(sort -rn <<<"${sorted_apps[*]}"))
            unset IFS
            
            for entry in "${sorted_apps[@]}"; do
                app_id=$(echo "$entry" | cut -d'|' -f2)
                count=${window_counts[$app_id]}
                
                if [ $count -eq 1 ]; then
                    first_title="${app_first_window[$app_id]}"
                    display_list+="$app_id: $first_title\n"
                else
                    display_list+="$app_id ($count windows)\n"
                fi
            done
            ;;
            
        "Oldest Created")
            # Sort apps by oldest creation timestamp first
            sorted_apps=()
            for app_id in "${!app_creation_timestamps[@]}"; do
                sorted_apps+=("${app_creation_timestamps[$app_id]}|$app_id")
            done
            IFS=$'\n' sorted_apps=($(sort -n <<<"${sorted_apps[*]}"))
            unset IFS
            
            for entry in "${sorted_apps[@]}"; do
                app_id=$(echo "$entry" | cut -d'|' -f2)
                count=${window_counts[$app_id]}
                
                if [ $count -eq 1 ]; then
                    first_title="${app_first_window[$app_id]}"
                    display_list+="$app_id: $first_title\n"
                else
                    display_list+="$app_id ($count windows)\n"
                fi
            done
            ;;
            
        *) # Default: Alphabetical
            for app_id in $(echo "${!window_counts[@]}" | tr ' ' '\n' | sort); do
                count=${window_counts[$app_id]}
                
                if [ $count -eq 1 ]; then
                    first_title="${app_first_window[$app_id]}"
                    display_list+="$app_id: $first_title\n"
                else
                    display_list+="$app_id ($count windows)\n"
                fi
            done
            ;;
    esac
    
    echo -e "$display_list"
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

# Build the display list and window counts using arrays
declare -A window_counts
declare -A app_first_window
declare -A app_all_windows
declare -A app_creation_timestamps  # Oldest creation timestamp per app
declare -A app_latest_creation      # Most recent creation timestamp per app

# Read the temp file and build arrays
while IFS='|' read -r creation_timestamp app_id title; do
    if [ -z "${window_counts[$app_id]}" ]; then
        window_counts[$app_id]=0
        app_first_window[$app_id]="$title"
        app_all_windows[$app_id]=""
        app_creation_timestamps[$app_id]=$creation_timestamp  # Initialize with first window
        app_latest_creation[$app_id]=$creation_timestamp
    fi
    
    window_counts[$app_id]=$((window_counts[$app_id] + 1))
    
    # Track oldest creation (minimum timestamp)
    if [ $creation_timestamp -lt ${app_creation_timestamps[$app_id]} ]; then
        app_creation_timestamps[$app_id]=$creation_timestamp
    fi
    
    # Track latest creation (maximum timestamp)
    if [ $creation_timestamp -gt ${app_latest_creation[$app_id]} ]; then
        app_latest_creation[$app_id]=$creation_timestamp
    fi
    
    if [ -z "${app_all_windows[$app_id]}" ]; then
        app_all_windows[$app_id]="$title"
    else
        app_all_windows[$app_id]="${app_all_windows[$app_id]}\n$title"
    fi
done < "$temp_file"

debug_log "Built arrays. Found ${#window_counts[@]} applications"

# Initial display with alphabetical sorting
current_sort="Alphabetical"
display_list=$(build_display_list "$current_sort")

echo -e "$display_list" | fuzzel --dmenu --prompt="Window: "

rm -f "$temp_file"
