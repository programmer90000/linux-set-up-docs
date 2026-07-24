#!/bin/bash

# Debug mode (set to 1 for verbose output)
DEBUG=0

debug_log() {
    if [ "$DEBUG" -eq 1 ]; then
        echo "DEBUG: $*" >&2
    fi
}

build_window_submenu() {
    local app_id="$1"
    local sort_method="$2"
    local temp_file="$3"
    local sorted_windows=""
    
    debug_log "Building submenu with sort: $sort_method"
    
    case "$sort_method" in
        "Creation (Oldest First)")
            sorted_windows=$(grep "|$app_id|" "$temp_file" 2>/dev/null | sort -n -t'|' -k1)
            ;;
        "Creation (Newest First)")
            sorted_windows=$(grep "|$app_id|" "$temp_file" 2>/dev/null | sort -rn -t'|' -k1)
            ;;
        "Alphabetical")
            sorted_windows=$(grep "|$app_id|" "$temp_file" 2>/dev/null | sort -t'|' -k4)
            ;;
        *)
            sorted_windows=$(grep "|$app_id|" "$temp_file" 2>/dev/null | sort -n -t'|' -k1)
            ;;
    esac
    
    debug_log "Found $(echo "$sorted_windows" | grep -c '|' || echo 0) windows"
    echo "$sorted_windows"
}

# Function to build display list with different sort orders
build_display_list() {
    local sort_order="$1"
    local display_list=""
    
    # Add sort options as a special entry that opens a submenu
    display_list="[Sort Options]\n---\n"
    
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

# Function to show sort options submenu
show_sort_menu() {
    local sort_options="Alphabetical\nNewest Created\nOldest Created\n---\nBack to main menu"
    local selected=$(echo -e "$sort_options" | fuzzel --dmenu --prompt="Sort by: " --lines=15 --width=50 --font="Monospace:size=16" --background=282a36ff --text=f8f8f2ff)
    
    case "$selected" in
        "Alphabetical"|"Newest Created"|"Oldest Created")
            current_sort="$selected"
            return 0
            ;;
        "Back to main menu"|"")
            return 1
            ;;
        *)
            return 1
            ;;
    esac
}

# Function to show window sort options submenu
show_window_sort_menu() {
    local sort_options="Creation (Oldest First)\nCreation (Newest First)\nAlphabetical\n---\nBack to window list"
    local selected=$(echo -e "$sort_options" | fuzzel --dmenu --prompt="Sort windows by: " --lines=15 --width=50 --font="Monospace:size=16" --background=282a36ff --text=f8f8f2ff)
    
    case "$selected" in
        "Creation (Oldest First)"|"Creation (Newest First)"|"Alphabetical")
            echo "$selected"
            return 0
            ;;
        "Back to window list"|"")
            return 1
            ;;
        *)
            return 1
            ;;
    esac
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

# Main loop - keep showing menu until user selects a window or cancels
while true; do
    selected=$(echo -e "$display_list" | fuzzel --dmenu --prompt="Window Switcher: " --lines=15 --width=50 --font="Monospace:size=16" --background=282a36ff --text=f8f8f2ff)
    
    # Exit if nothing selected
    if [ -z "$selected" ]; then
        break
    fi
    
    # Check if user selected sort options
    if [[ "$selected" == "[Sort Options]" ]]; then
        if show_sort_menu; then
            # Sort option was changed, rebuild display list
            display_list=$(build_display_list "$current_sort")
        fi
        continue
    fi
    
    # Check if selected is the separator
    if [[ "$selected" == "---" ]]; then
        continue
    fi
    
    # User selected a window - process it
    # Extract app_id from selection
    app_id=$(echo "$selected" | cut -d':' -f1 | xargs)
    app_id=$(echo "$app_id" | cut -d'(' -f1 | xargs)
    
    # Check if this app has multiple windows
    count=${window_counts[$app_id]}
    
    if [ -z "$count" ] || [ $count -eq 0 ]; then
        app_id=$(echo "$selected" | awk '{print $1}')
        count=${window_counts[$app_id]}
    fi
    
    if [ $count -eq 1 ]; then
        # Only one window, focus it directly
        title="${app_first_window[$app_id]}"
        if wlrctl window focus app-id:"$app_id" 2>/dev/null || \
           wlrctl window focus title:"$title" 2>/dev/null; then
            # Focus successful
            true
        fi
        break
    elif [ $count -gt 1 ]; then
        # Multiple windows - show submenu with sorting options
        submenu_sort="Creation (Oldest First)"  # Default sort for submenu
        
        # Build initial sorted window list
        sorted_windows=$(build_window_submenu "$app_id" "$submenu_sort" "$temp_file")
        
        while true; do
            # Build submenu display with sort indicator
            submenu_list="--- Sort: $submenu_sort ---\n"
            
            # Add windows to list with proper escaping
            if [ -n "$sorted_windows" ]; then
                while IFS='|' read -r creation_timestamp a_id title; do
                    # Properly escape special characters for display
                    title_escaped=$(printf "%s" "$title" | sed 's/&/\\&/g; s/"/\\"/g')
                    submenu_list+="$title_escaped\n"
                done < <(echo "$sorted_windows")
            fi
            
            # Add controls
            submenu_list+="---\n[Sort Windows]\n---\nBack to main menu"
            
            # Show submenu
            selected_window=$(echo -e "$submenu_list" | fuzzel --dmenu --prompt="$app_id ($count windows): " --lines=15 --width=50 --font="Monospace:size=16" --background=282a36ff --text=f8f8f2ff | head -1)
            
            # Handle selection
            if [ -z "$selected_window" ]; then
                # User cancelled
                break 2  # Break out of both loops
            fi
            
            # Check if user selected sort option
            if [[ "$selected_window" == "[Sort Windows]" ]]; then
                new_sort=$(show_window_sort_menu)
                if [ $? -eq 0 ] && [ -n "$new_sort" ] && [ "$new_sort" != "$submenu_sort" ]; then
                    submenu_sort="$new_sort"
                    # Rebuild sorted windows with new sort
                    sorted_windows=$(build_window_submenu "$app_id" "$submenu_sort" "$temp_file")
                fi
                continue  # Rebuild submenu with new sort
            fi
            
            # Check if user selected back
            if [[ "$selected_window" == "Back to main menu" ]]; then
                break  # Go back to main menu
            fi
            
            # Check if selected is the separator
            if [[ "$selected_window" == "---" ]]; then
                continue
            fi
            
            # User selected a specific window - clean it up
            selected_window_clean=$(printf "%s" "$selected_window" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
            
            debug_log "Attempting to focus: app_id='$app_id', title='$selected_window_clean'"
            
            # Try to focus with exact title match
            if wlrctl window focus app-id:"$app_id" title:"$selected_window_clean" 2>/dev/null; then
                debug_log "Focused using app-id and title"
                break 2  # Exit both loops
            fi
            
            # Try focusing by title only (for cases where app-id might not match)
            if wlrctl window focus title:"$selected_window_clean" 2>/dev/null; then
                debug_log "Focused using title only"
                break 2
            fi
            
            # Fallback: try to focus by app_id only
            if wlrctl window focus app-id:"$app_id" 2>/dev/null; then
                debug_log "Focused using app-id only (fallback)"
                break 2
            fi
            
            debug_log "Failed to focus window"
            # If we get here, focusing failed - show a message and continue
            echo "Failed to focus window" >&2
        done
    else
        # Fallback: try to focus by app_id
        if wlrctl window focus app-id:"$app_id" 2>/dev/null; then
            true
        fi
        break
    fi
done

rm -f "$temp_file"
