#!/usr/bin/env bash
set -euo pipefail
CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/waybar-weather.json"
QUERY="Lubniany"

case "${1:-print}" in
  update)
    mkdir -p "$(dirname "$CACHE")"
    curl -sS "https://wttr.in/${QUERY}?format=j1" > "$CACHE.tmp" && mv "$CACHE.tmp" "$CACHE"
    ;;
esac

if [[ -f "$CACHE" ]]; then
  temp=$(jq -r '.current_condition[0].temp_C' "$CACHE" 2>/dev/null || echo "?")
  icon=$(jq -r '.current_condition[0].weatherDesc[0].value' "$CACHE" 2>/dev/null | tr '[:upper:]' '[:lower:]' || echo "")
  sym="󰖙" # sunny
  case "$icon" in
    *snow*) sym="󰖘" ;;                 # snowy
    *rain*|*drizzle*) sym="󰖖" ;;       # pouring
    *cloud*|*overcast*) sym="󰖕" ;;     # cloudy
    *fog*|*mist*|*haze*) sym="󰙿" ;;    # fog
    *thunder*) sym="󰖓" ;;              # lightning
    *clear*|*sun*) sym="󰖙" ;;          # sunny
    *partly*|*broken*) sym="󰖗" ;;      # partly cloudy
  esac
  printf '{"text":"%s %s°C","tooltip":"%s • click to refresh","class":"weather"}\n' "$sym" "$temp" "$icon"
else
  printf '{"text":"󰖙 --","tooltip":"Click to fetch weather","class":"weather"}\n'
fi
