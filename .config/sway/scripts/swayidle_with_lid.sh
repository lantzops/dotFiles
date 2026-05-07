#!/bin/sh

# Terminate already running instances
pkill swayidle

# Set up swayidle with lid close hook
swayidle \
    -w \
    timeout 300 'hyprlock' \
    timeout 600 'swaymsg "output * power off"' \
    resume 'swaymsg "output * power on"' \
    before-sleep 'hyprlock' \
    lid-closed 'hyprlock' &