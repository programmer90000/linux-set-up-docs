#!/bin/bash
# Ultra-simple guest clipboard monitor

SHARED_DIR="$HOME/.shared-vm-data/clipboard"
mkdir -p "$SHARED_DIR"

LAST_HASH=""
LAST_HOST_HASH=""

while true; do
    # 1. Host -> Guest
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
    
    # 2. Guest -> Host
    CURRENT=$(qdbus org.kde.klipper /klipper getClipboardContents 2>/dev/null || echo "")
    if [[ -z "$CURRENT" ]]; then
        CURRENT=$(xclip -selection primary -o 2>/dev/null || echo "")
    fi
    
    CURRENT_HASH=$(echo -n "$CURRENT" | md5sum | cut -d' ' -f1)
    
    if [[ -n "$CURRENT" && "$CURRENT_HASH" != "$LAST_HASH" ]]; then
        # CRITICAL: Skip script content
        if echo "$CURRENT" | grep -q -E "(#!/bin/bash|SHARED_DIR=|log_msg|CYCLE=|LAST_)" || \
           [[ $(echo "$CURRENT" | wc -l) -gt 10 ]]; then
            LAST_HASH="$CURRENT_HASH"
            continue
        fi
        
        echo "$CURRENT" > "$SHARED_DIR/to-host.txt"
        LAST_HASH="$CURRENT_HASH"
    fi
    
    sleep 0.5
done