#!/bin/bash
# Guest monitor with clipboard and file sync

SHARED_DIR="$HOME/.shared-vm-data/clipboard"
FILES_DIR="$HOME/.shared-vm-data/files"
mkdir -p "$SHARED_DIR"
mkdir -p "$FILES_DIR"

# Clipboard tracking
LAST_HASH=""
LAST_HOST_HASH=""

# File tracking
declare -A GUEST_FILE_HASHES
declare -A HOST_FILE_HASHES

# Initialize guest file hashes
init_guest_files() {
    for file in "$FILES_DIR"/*; do
        if [[ -f "$file" ]]; then
            filename=$(basename "$file")
            GUEST_FILE_HASHES["$filename"]=$(md5sum "$file" | cut -d' ' -f1)
        fi
    done
}

# Sync file to host
sync_file_to_host() {
    local file="$1"
    local filename=$(basename "$file")

    echo "→ Host: $filename"
    scp -q "$file" "are-debian:~/.shared-vm-data/files/$filename" 2>/dev/null
    if [[ $? -eq 0 ]]; then
        GUEST_FILE_HASHES["$filename"]=$(md5sum "$file" | cut -d' ' -f1)
    else
        echo "  Failed to send $filename to host"
    fi
}

# Check and sync files from host
sync_files_from_host() {
    # Get list of files from host
    ssh are-debian "find ~/.shared-vm-data/files/ -maxdepth 1 -type f -exec basename {} \;" 2>/dev/null | while read filename; do
        if [[ -n "$filename" ]]; then
            local host_file="/tmp/host_$filename"

            # Download file from host
            scp -q "are-debian:~/.shared-vm-data/files/$filename" "$host_file" 2>/dev/null
            if [[ $? -eq 0 ]]; then
                local host_hash=$(md5sum "$host_file" | cut -d' ' -f1)
                local guest_file="$FILES_DIR/$filename"

                # Check if file is new or modified
                if [[ ! -f "$guest_file" ]] || \
                   [[ "$host_hash" != "${HOST_FILE_HASHES["$filename"]}" ]]; then

                    # Skip if same as guest version
                    if [[ -f "$guest_file" ]]; then
                        local guest_hash=$(md5sum "$guest_file" | cut -d' ' -f1)
                        if [[ "$host_hash" == "$guest_hash" ]]; then
                            HOST_FILE_HASHES["$filename"]="$host_hash"
                            rm -f "$host_file"
                            continue
                        fi
                    fi

                    # Copy to guest files directory
                    cp "$host_file" "$guest_file"
                    echo "← Host: $filename"
                    HOST_FILE_HASHES["$filename"]="$host_hash"
                    GUEST_FILE_HASHES["$filename"]="$host_hash"
                fi
                rm -f "$host_file"
            fi
        fi
    done
}

init_guest_files

while true; do
    # 1. CLIPBOARD: Host -> Guest
    if [[ -f "$SHARED_DIR/to-guest.txt" ]]; then
        HOST_CONTENT=$(cat "$SHARED_DIR/to-guest.txt" 2>/dev/null || echo "")
        HOST_HASH=$(echo -n "$HOST_CONTENT" | md5sum | cut -d' ' -f1)
        
        if [[ -n "$HOST_CONTENT" && "$HOST_HASH" != "$LAST_HOST_HASH" ]]; then
            # Set to KDE
            qdbus org.kde.klipper /klipper setClipboardContents "$HOST_CONTENT" 2>/dev/null
            echo "$HOST_CONTENT" | xclip -selection primary 2>/dev/null
            LAST_HOST_HASH="$HOST_HASH"
        fi
        rm -f "$SHARED_DIR/to-guest.txt" 2>/dev/null
    fi
    
    # 2. CLIPBOARD: Guest -> Host
    CURRENT=$(qdbus org.kde.klipper /klipper getClipboardContents 2>/dev/null || echo "")
    if [[ -z "$CURRENT" ]]; then
        CURRENT=$(xclip -selection primary -o 2>/dev/null || echo "")
    fi
    
    CURRENT_HASH=$(echo -n "$CURRENT" | md5sum | cut -d' ' -f1)
    
    if [[ -n "$CURRENT" && "$CURRENT_HASH" != "$LAST_HASH" ]]; then
        echo "$CURRENT" > "$SHARED_DIR/to-host.txt"
        LAST_HASH="$CURRENT_HASH"
    fi

    # 3. FILES: Check for new/modified guest files
    for file in "$FILES_DIR"/*; do
        if [[ -f "$file" ]]; then
            filename=$(basename "$file")
            current_hash=$(md5sum "$file" | cut -d' ' -f1)

            # If file is new or modified
            if [[ ! "${GUEST_FILE_HASHES["$filename"]}" ]] || \
               [[ "$current_hash" != "${GUEST_FILE_HASHES["$filename"]}" ]]; then
                sync_file_to_host "$file"
            fi
        fi
    done

    # 4. FILES: Check for files from host (every 2 seconds)
    if [[ $((SECONDS % 2)) -eq 0 ]]; then
        sync_files_from_host
    fi

    # 5. Clean up deleted files from tracking
    for filename in "${!GUEST_FILE_HASHES[@]}"; do
        if [[ ! -f "$FILES_DIR/$filename" ]]; then
            unset GUEST_FILE_HASHES["$filename"]
        fi
    done

    sleep 0.5
done