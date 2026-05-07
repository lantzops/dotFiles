#!/bin/bash
# Screenshot script with notification

case "$1" in
    "area")
        GEOMETRY="$(slurp)"
        if [ -n "$GEOMETRY" ]; then # Check if geometry is not empty (slurp was not cancelled)
            FILENAME="$HOME/Pictures/Screenshots/screenshot_area_$(date +%Y%m%d_%H%M%S).png"
            grim -g "$GEOMETRY" - | tee "$FILENAME" | wl-copy
            notify-send "Screenshot" "Area screenshot saved to $FILENAME and copied to clipboard"
        else
            notify-send "Screenshot" "Area screenshot cancelled" # Notify user of cancellation
        fi
        ;;
    "window")
        FILENAME="$HOME/Pictures/Screenshots/screenshot_window_$(date +%Y%m%d_%H%M%S).png"
        grim -g "$(swaymsg -t get_tree | jq -r '..|select(.type?)|select(.focused==true).rect | "\(.x),\(.y) \(.width)x\(.height)"')" - | tee "$FILENAME" | wl-copy
        notify-send "Screenshot" "Window screenshot saved to $FILENAME and copied to clipboard"
        ;;
    "screen")
        mkdir -p "$HOME/Pictures/Screenshots"
        FILENAME="$HOME/Pictures/Screenshots/screenshot_$(date +%Y%m%d_%H%M%S).png"
        grim -t png - | tee "$FILENAME" | wl-copy # Changed to pipe to tee/wl-copy
        notify-send "Screenshot" "Full screen screenshot saved to $FILENAME and copied to clipboard"
        ;;
    *)
        echo "Usage: $0 {area|window|screen}"
        ;;
esac