#!/usr/bin/env bash
set -euo pipefail
if command -v nvidia-smi >/dev/null 2>&1; then
  t=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits 2>/dev/null | head -n1 || true)
  if [[ -n "${t:-}" ]]; then
    printf '{"text":"󰢮 %s°C","class":"temp gpu nvidia","tooltip":"NVIDIA GPU temp: %s°C"}\n' "$t" "$t"
    exit 0
  fi
fi
for hw in /sys/class/drm/card*/device/hwmon/hwmon*/temp1_input; do
  if [[ -r "$hw" ]]; then
    t_mC=$(cat "$hw")
    t=$(( t_mC / 1000 ))
    printf '{"text":"󰢮 %s°C","class":"temp gpu amd","tooltip":"GPU temp: %s°C"}\n' "$t" "$t"
    exit 0
  fi
done
echo '{"text":"GPU --","class":"temp gpu","tooltip":"GPU temperature unavailable"}'