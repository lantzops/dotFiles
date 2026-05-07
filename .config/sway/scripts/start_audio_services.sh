#!/bin/bash
# Script to set up and start audio services

# The following section is commented out because mpd is not installed.
# # Ensure MPD directory exists
# mkdir -p ~/.config/mpd/playlists
#
# # Remove PID file if it exists to prevent issues
# rm -f ~/.config/mpd/pid 2>/dev/null
#
# # Start MPD service if not already running
# if ! pgrep mpd > /dev/null; then
#     # Initialize MPD with a clean database
#     mpd
#     sleep 3
#     # Update the database
#     mpc update --wait
# fi

# Make sure playerctl is available
if ! command -v playerctl &> /dev/null; then
    echo "playerctl is not installed"
fi