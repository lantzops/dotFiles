#!/bin/bash

# Screen recording script for Sway
# Requires: wf-recorder, notify-send (libnotify), slurp

# Directory to save recordings
RECORDINGS_DIR="$HOME/Videos/Recordings"
mkdir -p "$HOME/Pictures" "$HOME/Videos" "$RECORDINGS_DIR"

# Function to start recording
start_recording() {
    local output="$1"
    local filename="$RECORDINGS_DIR/recording_$(date +%Y%m%d_%H%M%S).mp4"

    if [ "$output" = "area" ]; then
        # Record selected area
        wf-recorder -g "$(slurp -d)" -f "$filename" &
    elif [ "$output" = "window" ]; then
        # Record focused window
        local window_geometry=$(swaymsg -t get_tree | jq -r '..|select(.type?)|select(.focused==true).rect | "\(.x),\(.y) \(.width)x\(.height)"')
        wf-recorder -g "$window_geometry" -f "$filename" &
    else
        # Record entire screen
        wf-recorder -f "$filename" &
    fi

    # Store PID of recording process
    echo $! > /tmp/screenrecord.pid
    notify-send "Screen Recording" "Recording started: $(basename "$filename")"
}

# Function to stop recording
stop_recording() {
    if [ -f "/tmp/screenrecord.pid" ]; then
        PID=$(cat /tmp/screenrecord.pid)
        kill $PID 2>/dev/null
        rm -f /tmp/screenrecord.pid
        notify-send "Screen Recording" "Recording stopped"
    else
        notify-send "Screen Recording" "No active recording found"
    fi
}

# Check if recording is already in progress
if [ -f "/tmp/screenrecord.pid" ]; then
    # If PID file exists, check if process is still running
    if kill -0 $(cat /tmp/screenrecord.pid) 2>/dev/null; then
        # Recording is running, stop it
        stop_recording
    else
        # PID file exists but process is dead, remove the file and start new recording
        rm -f /tmp/screenrecord.pid
        start_recording "$1"
    fi
else
    # No recording in progress, start new one
    start_recording "$1"
fi