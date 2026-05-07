#!/bin/bash
# Show volume OSD using pactl and a simple notification

# Get current volume and mute status
volume=$(pactl get-sink-volume-by-name @DEFAULT_SINK@ | awk '{print $5}')
is_muted=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')

if [ "$is_muted" = "yes" ]; then
    # Send notification for muted state
    notify-send -t 1000 -h string:x-canonical-private-synchronous:audio "Volume: Muted" -h int:value:0
else
    # Extract percentage value from volume string (e.g., "45%" -> 45)
    percentage=$(echo "$volume" | sed 's/%//')
    # Send notification with volume percentage
    notify-send -t 1000 -h string:x-canonical-private-synchronous:audio "Volume: ${percentage}%" -h int:value:$percentage
fi