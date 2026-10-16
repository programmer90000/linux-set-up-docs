#!/bin/bash

vol_raw=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}')
# Cap the value at 100 to prevent scale errors
[ "$vol_raw" -gt 100 ] && vol_raw=100

new_vol=$(yad --scale --title="Volume" --text="Adjust Volume" --value="$vol_raw" --min-value=0 --max-value=100 2>/dev/null)
if [ -n "$new_vol" ]; then
    wpctl set-volume @DEFAULT_AUDIO_SINK@ "${new_vol}%"
fi
