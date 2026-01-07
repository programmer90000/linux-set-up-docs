#!/bin/bash

commands=(
    "check-disk-space.sh"
)

echo "Running ${#commands[@]} system checks..."

for command in "${commands[@]}"; do
    echo "=== Running $command ==="
    if ! command -v "$command" >/dev/null 2>&1; then
        echo "WARNING: $command not found, skipping..."
        continue
    fi
    "$command" || { echo "ERROR: $command failed!"; exit 1; }
done

echo "All system checks completed successfully!"
