#!/usr/bin/env bash

# Simple random wallpaper script using awww
set -euo pipefail

BACKGROUND_DIR="$HOME/.config/backgrounds"

if [[ ! -d "$BACKGROUND_DIR" ]]; then
    notify-send "Random Background" "Directory not found: $BACKGROUND_DIR"
    exit 1
fi

# Determine mode: if arg is "random", use random, otherwise cycle
MODE="cycle"
if [ "$1" = "random" ]; then
    MODE="random"
fi

if [ "$MODE" = "random" ]; then
    # pick a random file for random mode
    background=$(find "$BACKGROUND_DIR" -type f \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.gif' -o -iname '*.webp' \) | shuf -n 1)

    if [[ -z "$background" ]]; then
        notify-send "Random Background" "No images found in $BACKGROUND_DIR"
        exit 1
    fi
else
    # For cycling mode - get current wallpaper from awww_init_simple.sh
    current_file=$(grep -oP "(?<=awww img \")[^\"]*(?=\"\s+--transition-type)" "$HOME/.config/sway/scripts/awww_init_simple.sh" 2>/dev/null | head -n1)

    if [ -z "$current_file" ]; then
        # If not found in awww script, start with a random image
        background=$(find "$BACKGROUND_DIR" -type f \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.gif' -o -iname '*.webp' \) | shuf -n 1)
    else
        # The grep result might be a relative path, ensure it's a full path
        if [[ ! "$current_file" =~ ^/ ]]; then
            current_file="$BACKGROUND_DIR/$current_file"
        fi

        # Get all background files and find the current one
        background_files=()
        while IFS= read -r -d '' file; do
            background_files+=("$file")
        done < <(find "$BACKGROUND_DIR" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.webp" \) -print0)

        # Sort the array to ensure consistent ordering
        IFS=$'\n' sorted_files=($(sort <<<"${background_files[*]}"))
        unset IFS

        # Find current file index and get next file
        current_index=0
        for i in "${!sorted_files[@]}"; do
            if [[ "${sorted_files[$i]}" == "$current_file" ]]; then
                current_index=$i
                break
            fi
        done

        # Calculate next index (cycling)
        next_index=$(( (current_index + 1) % ${#sorted_files[@]} ))
        background="${sorted_files[$next_index]}"
    fi
fi

# Set the background using swww
if command -v swww &>/dev/null; then
    swww img "$background" --transition-type any --transition-step 63 --transition-angle 0 --transition-duration 2 --transition-fps 60
else
    # Fallback to swaybg if swww is not available
    killall swaybg 2>/dev/null || true
    swaybg --output '*' --mode fill --image "$background" &
fi

# Send a notification with the new background name
notify-send -i "$background" "Background changed" "$(basename "$background") - $MODE mode"
