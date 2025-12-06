#!/bin/bash
SHARED_DIR="$HOME/.shared-vm-data/clipboard"
mkdir -p "$SHARED_DIR"

echo "Host monitor starting (CopyQ compatible)"

LAST_HASH=""
LAST_GUEST_HASH=""

while true; do
    # 1. Host -> Guest
    CURRENT=$(timeout 0.5 xclip -selection clipboard -o 2>/dev/null || echo "")
    CURRENT_HASH=$(echo -n "$CURRENT" | md5sum | cut -d' ' -f1)

    if [[ -n "$CURRENT" && "$CURRENT_HASH" != "$LAST_HASH" ]]; then
        # Skip if it contains script patterns
        if echo "$CURRENT" | grep -q -E "(#!/bin/bash|SHARED_DIR=|log_msg|CYCLE=|LAST_)" || \
           [[ $(echo "$CURRENT" | wc -l) -gt 10 ]]; then
            LAST_HASH="$CURRENT_HASH"
            continue
        fi

        echo "$CURRENT" > "$SHARED_DIR/to-guest.txt"
        scp -q "$SHARED_DIR/to-guest.txt" vm:~/.shared-vm-data/clipboard/ 2>/dev/null
        LAST_HASH="$CURRENT_HASH"
        echo "→ Guest: $(echo "$CURRENT" | head -c 30)..."
    fi

    # 2. Guest -> Host
    if scp -q vm:~/.shared-vm-data/clipboard/to-host.txt "$SHARED_DIR/" 2>/dev/null; then
        GUEST_CONTENT=$(cat "$SHARED_DIR/to-host.txt" 2>/dev/null || echo "")
        GUEST_HASH=$(echo -n "$GUEST_CONTENT" | md5sum | cut -d' ' -f1)

        if [[ -n "$GUEST_CONTENT" && "$GUEST_HASH" != "$LAST_GUEST_HASH" ]]; then
            echo "← Guest: $(echo "$GUEST_CONTENT" | head -c 30)..."
    
            # CRITICAL: Add to CopyQ FIRST using stdin method
            echo "$GUEST_CONTENT" | copyq copy - 2>/dev/null || echo "CopyQ add failed"

            # Also set system clipboard (for non-CopyQ apps)
            echo "$GUEST_CONTENT" | xclip -selection clipboard 2>/dev/null

            LAST_GUEST_HASH="$GUEST_HASH"
        fi
        rm -f "$SHARED_DIR/to-host.txt" 2>/dev/null
    fi

    sleep 0.5
done