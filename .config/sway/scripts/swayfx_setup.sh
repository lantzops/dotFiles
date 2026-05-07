#!/bin/bash
# Proper SwayFX enhancements script after researching docs and forums

# Wait for Sway to fully initialize
sleep 3

# Initialize awww properly
pkill awww-daemon 2>/dev/null || true
sleep 1
awww-daemon &
sleep 2

# Set the wallpaper
if [ -f "$HOME/Pictures/Wallpaper-4k.jpg" ]; then
    awww img "$HOME/Pictures/Wallpaper-4k.jpg" --transition-type fade --transition-duration 1
fi

# Attempt to set rounded corners if supported (this is version-dependent)
# We'll use a more reliable approach by setting it through swaymsg in a way that won't cause errors
# For rounded corners, we'll try to set it via the config file rather than a command that might fail