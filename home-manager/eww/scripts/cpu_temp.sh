#!/usr/bin/env bash
set -euo pipefail
# Try to find a Package/Core temp sensor (hwmon)
for p in /sys/class/hwmon/hwmon*/temp*_input; do
  [ -r "$p" ] || continue
  base="${p%%_*}"
  label="${base}_label"
  if [ -r "$label" ] && grep -qiE 'package|cpu' "$label"; then
    v=$(cat "$p")
    echo $((v/1000))
    exit 0
  fi
done
# Fallback: highest thermal zone value
best=""
for f in /sys/class/thermal/thermal_zone*/temp; do
  [ -r "$f" ] || continue
  val=$(cat "$f")
  if [ -z "$best" ] || [ "$val" -gt "$best" ]; then
    best=$val
  fi
done
if [ -n "$best" ]; then
  echo $((best/1000))
else
  echo ?
fi
