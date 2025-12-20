#!/bin/bash
TARGET="are-debian-vm.local"
MAX_PINGS=10 # Set to 0 for continuous ping

echo "=== mDNS Ping Monitor ==="
echo "Target: $TARGET"
echo "Number Of Target Pings: $MAX_PINGS"
echo "Started: $(date)"
echo "---------------------"

# Continuous or limited ping
if [ "$MAX_PINGS" -eq 0 ]; then
    echo "Continuous ping (Ctrl+C to stop)..."
    ping "$TARGET"
else
    ping -c "$MAX_PINGS" "$TARGET" | while IFS= read -r line; do
        echo "$(date '+%H:%M:%S') - $line"
    done

    echo "---------------------"
    echo "Completed $MAX_PINGS ping attempts"
fi