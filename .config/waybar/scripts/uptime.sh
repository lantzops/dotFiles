#!/bin/sh
# Simple uptime script for waybar

uptime_seconds=$(cut -d. -f1 /proc/uptime)
uptime_days=$((uptime_seconds / 86400))
uptime_hours=$(((uptime_seconds % 86400) / 3600))
uptime_minutes=$(((uptime_seconds % 3600) / 60))

if [ $uptime_days -gt 0 ]; then
    echo "${uptime_days}d ${uptime_hours}h"
elif [ $uptime_hours -gt 0 ]; then
    echo "${uptime_hours}h ${uptime_minutes}m"
else
    echo "${uptime_minutes}m"
fi