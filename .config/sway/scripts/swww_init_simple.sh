#!/usr/bin/env bash

wallpaper="$HOME/.config/backgrounds/03. Abyssal Wave.png"

if command -v swww-daemon >/dev/null 2>&1 && command -v swww >/dev/null 2>&1; then
    pgrep -x swww-daemon >/dev/null || swww-daemon >/dev/null 2>&1 &
    for _ in {1..20}; do
        swww query >/dev/null 2>&1 && break
        sleep 0.1
    done
    swww img "$wallpaper" --transition-type any --transition-step 63 \
        --transition-angle 0 --transition-duration 2 --transition-fps 60
else
    pkill -x swaybg 2>/dev/null || true
    swaybg --output '*' --mode fill --image "$wallpaper" &
fi
