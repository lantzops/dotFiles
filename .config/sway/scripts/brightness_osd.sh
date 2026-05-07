#!/bin/bash
# Show brightness OSD using brightnessctl

# Get current brightness
brightness=$(brightnessctl get)
max_brightness=$(brightnessctl max)
percentage=$((brightness * 100 / max_brightness))

# Send notification with brightness percentage
notify-send -t 1000 -h string:x-canonical-private-synchronous:brightness "Brightness: ${percentage}%" -h int:value:$percentage