#!/bin/bash
# Simple awww initialization script

# Kill any existing awww daemon
pkill awww-daemon 2>/dev/null || true

# Wait a moment
sleep 1

# Start the awww daemon
awww-daemon &

# Wait for daemon to start
sleep 2

# Set the wallpaper
awww img "/home/lantzops/.config/backgrounds/03. Abyssal Wave.png" --transition-type any --transition-step 63 --transition-angle 0 --transition-duration 2 --transition-fps 60