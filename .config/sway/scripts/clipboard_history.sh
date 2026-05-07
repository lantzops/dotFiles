#!/bin/sh
# ~/.config/sway/scripts/clipboard_history.sh

# Get clipboard history from cliphist, then select with fuzzel
selected=$(cliphist list | fuzzel --dmenu -p "Clipboard: ")

# If an item was selected, decode it from cliphist and copy to clipboard
if [ -n "$selected" ]; then
    echo "$selected" | cliphist decode | wl-copy
fi