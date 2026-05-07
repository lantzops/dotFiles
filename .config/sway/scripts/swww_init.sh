#!/bin/bash

# Start awww daemon and set the wallpaper
pkill awww-daemon  # Kill any existing daemon
sleep 1
awww-daemon &
sleep 2
awww img "$HOME/Pictures/Wallpaper-4k.jpg" --transition-type fade --transition-duration 2