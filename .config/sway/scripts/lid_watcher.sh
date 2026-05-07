#!/bin/bash
# Monitor lid events and lock accordingly

# Function to handle lid events
handle_lid_event() {
    while IFS= read -r event; do
        if [[ "$event" =~ LID\ [0-9]+.*open ]]; then
            echo "Lid opened" >> /tmp/lid_events.log
            # You could add wake actions here if needed
        elif [[ "$event" =~ LID\ [0-9]+.*closed ]]; then
            echo "Lid closed - locking screen" >> /tmp/lid_events.log
            # Lock the screen using hyprlock
            swaymsg exec "hyprlock"
        fi
    done < <(stdbuf -oL -eL acpi_listen)
}

# Kill any existing lid watcher processes
pkill -f "lid_watcher.sh" || true

# Start monitoring
handle_lid_event