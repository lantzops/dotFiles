#!/usr/bin/env bash

# Disable the laptop display only when the lid is closed AND an external
# output is connected. Otherwise keep eDP-1 enabled so the laptop is usable
# on its own.

lid_state=$(awk '{print $2}' /proc/acpi/button/lid/LID/state)
external_count=$(swaymsg -t get_outputs | jq '[.[] | select(.name != "eDP-1")] | length')

if [[ "$lid_state" == "closed" ]] && (( external_count > 0 )); then
    swaymsg output eDP-1 disable
else
    swaymsg output eDP-1 enable
fi
