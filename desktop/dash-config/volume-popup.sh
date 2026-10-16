#!/bin/bash

vol_raw=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}')
# Cap the value at 100 to prevent scale errors
[ "$vol_raw" -gt 100 ] && vol_raw=100

# Extract available audio sinks using pactl
sinks=$(pactl list sinks | grep -E 'Description:' | cut -d':' -f2- | xargs -I{} echo "{}" | paste -sd '!' -)
[ -z "$sinks" ] && sinks="Default Audio Sink"

yad --form --title="Volume" --text="Adjust Volume" --field="Audio Device:CB" "$sinks" --field="Volume:SCL" "$vol_raw!0..100!1" --print-partial --no-buttons --undecorated --close-on-unfocus 2>/dev/null | while IFS='|' read -r device vol; do
    if [ -n "$device" ]; then
        sink_name=$(pactl list sinks | grep -B 2 -F "Description: $device" | grep 'Name:' | awk '{print $2}')
        [ -n "$sink_name" ] && wpctl set-default "$sink_name"
    fi
    
    # Adjust volume immediately when the slider moves
    if [ -n "$vol" ]; then
        wpctl set-volume @DEFAULT_AUDIO_SINK@ "${vol}%"
    fi
done
