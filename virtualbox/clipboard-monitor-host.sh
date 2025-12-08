#!/bin/bash
SHARED_DIR="$HOME/.shared-vm-data/clipboard"
FILES_DIR="$HOME/.shared-vm-data/files"
mkdir -p "$SHARED_DIR"
mkdir -p "$FILES_DIR"

echo "Host monitor starting (CopyQ compatible) - Now with file sync"

# Clipboard tracking
LAST_HASH=""
LAST_GUEST_HASH=""

# File tracking
declare -A HOST_FILE_HASHES
declare -A GUEST_FILE_HASHES

# Initialize host file hashes
init_host_files() {
    for file in "$FILES_DIR"/*; do
        if [[ -f "$file" ]]; then
            filename=$(basename "$file")
            HOST_FILE_HASHES["$filename"]=$(md5sum "$file" | cut -d' ' -f1)
        fi
    done
}

# Sync file to guest
sync_file_to_guest() {
    local file="$1"
    local filename=$(basename "$file")
    
    echo "📁 → Guest: $filename"
    scp -q "$file" "vm:~/.shared-vm-data/files/$filename" 2>/dev/null
    if [[ $? -eq 0 ]]; then
        HOST_FILE_HASHES["$filename"]=$(md5sum "$file" | cut -d' ' -f1)
    else
        echo "  Failed to send $filename to guest"
    fi
}

# Check and sync files from guest
sync_files_from_guest() {
    # Get list of files from guest
    ssh vm "find ~/.shared-vm-data/files/ -maxdepth 1 -type f -exec basename {} \;" 2>/dev/null | while read filename; do
        if [[ -n "$filename" ]]; then
            local guest_file="/tmp/guest_$filename"
            
            # Download file from guest
            scp -q "vm:~/.shared-vm-data/files/$filename" "$guest_file" 2>/dev/null
            if [[ $? -eq 0 ]]; then
                local guest_hash=$(md5sum "$guest_file" | cut -d' ' -f1)
                local host_file="$FILES_DIR/$filename"
                
                # Check if file is new or modified
                if [[ ! -f "$host_file" ]] || \
                   [[ "$guest_hash" != "${GUEST_FILE_HASHES["$filename"]}" ]]; then
                    
                    # Skip if same as host version
                    if [[ -f "$host_file" ]]; then
                        local host_hash=$(md5sum "$host_file" | cut -d' ' -f1)
                        if [[ "$guest_hash" == "$host_hash" ]]; then
                            GUEST_FILE_HASHES["$filename"]="$guest_hash"
                            rm -f "$guest_file"
                            continue
                        fi
                    fi
                    
                    # Copy to host files directory
                    cp "$guest_file" "$host_file"
                    echo "📁 ← Guest: $filename"
                    GUEST_FILE_HASHES["$filename"]="$guest_hash"
                    HOST_FILE_HASHES["$filename"]="$guest_hash"
                fi
                rm -f "$guest_file"
            fi
        fi
    done
}

# Initialize
init_host_files

while true; do
    # 1. CLIPBOARD: Host -> Guest
    CURRENT=$(timeout 0.5 xclip -selection clipboard -o 2>/dev/null || echo "")
    CURRENT_HASH=$(echo -n "$CURRENT" | md5sum | cut -d' ' -f1)

    if [[ -n "$CURRENT" && "$CURRENT_HASH" != "$LAST_HASH" ]]; then
        echo "$CURRENT" > "$SHARED_DIR/to-guest.txt"
        scp -q "$SHARED_DIR/to-guest.txt" vm:~/.shared-vm-data/clipboard/ 2>/dev/null
        LAST_HASH="$CURRENT_HASH"
        echo "📋 → Guest: $(echo "$CURRENT" | head -c 30)..."
    fi

    # 2. CLIPBOARD: Guest -> Host
    if scp -q vm:~/.shared-vm-data/clipboard/to-host.txt "$SHARED_DIR/" 2>/dev/null; then
        GUEST_CONTENT=$(cat "$SHARED_DIR/to-host.txt" 2>/dev/null || echo "")
        GUEST_HASH=$(echo -n "$GUEST_CONTENT" | md5sum | cut -d' ' -f1)

        if [[ -n "$GUEST_CONTENT" && "$GUEST_HASH" != "$LAST_GUEST_HASH" ]]; then
            echo "📋 ← Guest: $(echo "$GUEST_CONTENT" | head -c 30)..."
    
            # CRITICAL: Add to CopyQ FIRST using stdin method
            echo "$GUEST_CONTENT" | copyq copy - 2>/dev/null || echo "CopyQ add failed"

            # Also set system clipboard (for non-CopyQ apps)
            echo "$GUEST_CONTENT" | xclip -selection clipboard 2>/dev/null

            LAST_GUEST_HASH="$GUEST_HASH"
        fi
        rm -f "$SHARED_DIR/to-host.txt" 2>/dev/null
    fi

    # 3. FILES: Check for new/modified host files
    for file in "$FILES_DIR"/*; do
        if [[ -f "$file" ]]; then
            filename=$(basename "$file")
            current_hash=$(md5sum "$file" | cut -d' ' -f1)
            
            # If file is new or modified
            if [[ ! "${HOST_FILE_HASHES["$filename"]}" ]] || \
               [[ "$current_hash" != "${HOST_FILE_HASHES["$filename"]}" ]]; then
                sync_file_to_guest "$file"
            fi
        fi
    done

    # 4. FILES: Check for files from guest (every 2 seconds)
    if [[ $((SECONDS % 2)) -eq 0 ]]; then
        sync_files_from_guest
    fi

    # 5. Clean up deleted files from tracking
    for filename in "${!HOST_FILE_HASHES[@]}"; do
        if [[ ! -f "$FILES_DIR/$filename" ]]; then
            unset HOST_FILE_HASHES["$filename"]
        fi
    done

    sleep 0.5
done