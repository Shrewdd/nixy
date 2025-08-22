#!/usr/bin/env bash
set -euo pipefail
CITY="Lubniany"
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}"
CACHE_FILE="$CACHE_DIR/eww-weather.json"
MODE="${1:-print}"
if [ "$MODE" = update ]; then
  mkdir -p "$CACHE_DIR"
  curl -sS "https://wttr.in/${CITY}?format=j1" >"$CACHE_FILE.tmp" && mv "$CACHE_FILE.tmp" "$CACHE_FILE"
fi
if [ -f "$CACHE_FILE" ]; then
  temp=$(jq -r '.current_condition[0].temp_C' "$CACHE_FILE" 2>/dev/null || echo "?")
  desc=$(jq -r '.current_condition[0].weatherDesc[0].value' "$CACHE_FILE" 2>/dev/null | tr '[:upper:]' '[:lower:]')
  echo "${temp}°C ${desc}"
else
  echo "--°C"
fi
