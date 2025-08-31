#!/usr/bin/env bash
set -euo pipefail
temp_mC=""
for path in /sys/class/hwmon/hwmon*/temp*_input; do
  labelFile=${path%_*}_label
  if [[ -r "$labelFile" ]] && grep -qiE 'package|cpu' "$labelFile"; then
    temp_mC=$(cat "$path")
    break
  fi
done
if [[ -z "${temp_mC:-}" ]]; then
  temp_mC=$(for f in /sys/class/thermal/thermal_zone*/temp; do [[ -r "$f" ]] && cat "$f"; done | sort -nr | head -n1 || true)
fi
if [[ -z "${temp_mC:-}" ]]; then
  echo '{"text":"CPU ?°C","class":"temp cpu"}'
  exit 0
fi
temp_C=$(( temp_mC / 1000 ))
printf '{"text":" %s°C","class":"temp cpu","tooltip":"CPU temp: %s°C"}\n' "$temp_C" "$temp_C"
