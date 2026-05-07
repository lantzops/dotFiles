#!/bin/bash
# Enhanced screenshot script with Fuzzel menu

# Function to show screenshot options with fuzzel
show_screenshot_menu() {
    options="Area Screenshot\nWindow Screenshot\nFull Screen Screenshot\nScreen with cursor"
    
    choice=$(echo -e "$options" | fuzzel --dmenu --prompt="Screenshot: " --lines=4)
    
    case "$choice" in
        "Area Screenshot")
            GEOMETRY="$(slurp)"
            if [ -n "$GEOMETRY" ]; then # Check if geometry is not empty (slurp was not cancelled)
                FILENAME="$HOME/Pictures/Screenshots/screenshot_area_$(date +%Y%m%d_%H%M%S).png"
                grim -g "$GEOMETRY" - | tee "$FILENAME" | wl-copy
                notify-send "Screenshot" "Area screenshot saved to $FILENAME and copied to clipboard"
            else
                notify-send "Screenshot" "Area screenshot cancelled" # Notify user of cancellation
            fi
            ;;
        "Window Screenshot")
            FILENAME="$HOME/Pictures/Screenshots/screenshot_window_$(date +%Y%m%d_%H%M%S).png"
            grim -g "$(swaymsg -t get_tree | jq -r '..|select(.type?)|select(.focused==true).rect | "\(.x),\(.y) \(.width)x\(.height)"')" - | tee "$FILENAME" | wl-copy
            notify-send "Screenshot" "Window screenshot saved to $FILENAME and copied to clipboard"
            ;;
        "Full Screen Screenshot")
            mkdir -p "$HOME/Pictures/Screenshots"
            FILENAME="$HOME/Pictures/Screenshots/screenshot_$(date +%Y%m%d_%H%M%S).png"
            grim -t png - | tee "$FILENAME" | wl-copy
            notify-send "Screenshot" "Full screen screenshot saved to $FILENAME and copied to clipboard"
            ;;
        "Screen with cursor")
            mkdir -p "$HOME/Pictures/Screenshots"
            FILENAME="$HOME/Pictures/Screenshots/screenshot_cursor_$(date +%Y%m%d_%H%M%S).png"
            grim -c -t png - | tee "$FILENAME" | wl-copy
            notify-send "Screenshot" "Full screen screenshot with cursor saved to $FILENAME and copied to clipboard"
            ;;
        *)
            # User cancelled
            exit 0
            ;;
    esac
}

# If an argument is provided, use it directly (for keybindings)
if [ -n "$1" ]; then
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
            grim -t png - | tee "$FILENAME" | wl-copy
            notify-send "Screenshot" "Full screen screenshot saved to $FILENAME and copied to clipboard"
            ;;
        "cursor")
            mkdir -p "$HOME/Pictures/Screenshots"
            FILENAME="$HOME/Pictures/Screenshots/screenshot_cursor_$(date +%Y%m%d_%H%M%S).png"
            grim -c -t png - | tee "$FILENAME" | wl-copy
            notify-send "Screenshot" "Full screen screenshot with cursor saved to $FILENAME and copied to clipboard"
            ;;
        *)
            show_screenshot_menu
            ;;
    esac
else
    # No argument - show menu
    show_screenshot_menu
fi