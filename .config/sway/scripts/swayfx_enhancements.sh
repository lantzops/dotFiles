#!/bin/bash
# SwayFX enhancements setup script
# Wait for Sway to be fully loaded
sleep 3

# Initialize awww properly
pkill awww-daemon 2>/dev/null || true
sleep 1
awww-daemon &
sleep 2
awww img "$HOME/Pictures/Wallpaper-4k.jpg" --transition-type fade --transition-duration 2

# Apply SwayFX visual enhancements that are most likely supported
# Try rounded corners command (this is the correct SwayFX command)
swaymsg "default_border_radius 12" 2>/dev/null || echo "default_border_radius not supported"

# Apply window gaps (already set in config but make sure)
swaymsg "gaps inner 4" 2>/dev/null || true
swaymsg "gaps outer 4" 2>/dev/null || true

# SwayFX typically enables blur and shadows by default, no special command needed
# The visual enhancements should be active by virtue of running SwayFX