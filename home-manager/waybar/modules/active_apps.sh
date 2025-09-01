#!/usr/bin/env bash
set -euo pipefail

# Get active applications from Hyprland
if command -v hyprctl >/dev/null 2>&1; then
    apps=$(hyprctl clients -j | jq -r '.[] | select(.workspace.id >= 0) | .class' | sort -u | head -8)
    count=$(echo "$apps" | wc -l)
    
    if [[ $count -gt 0 ]]; then
        tooltip=$(echo "$apps" | sed 's/^/• /' | tr '\n' '\n' | head -c -1)
        printf '{"text":"󰍉 %d","class":"app-list","tooltip":"%s"}\n' "$count" "$tooltip"
    else
        printf '{"text":"󰍉","class":"app-list","tooltip":"No active applications"}\n'
    fi
else
    printf '{"text":"󰍉","class":"app-list","tooltip":"Hyprctl not available"}\n'
fi
