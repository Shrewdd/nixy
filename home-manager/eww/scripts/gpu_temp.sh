#!/usr/bin/env bash
set -euo pipefail
# Prefer NVIDIA if present
if command -v nvidia-smi >/dev/null 2>&1; then
  t=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits 2>/dev/null | head -n1 || true)
  if [ -n "${t:-}" ]; then
    echo "$t"
    exit 0
  fi
fi
# Generic hwmon path used by AMD/Intel
for hw in /sys/class/drm/card*/device/hwmon/hwmon*/temp1_input; do
  [ -r "$hw" ] || continue
  v=$(cat "$hw")
  if [ -n "$v" ]; then
    echo $((v/1000))
    exit 0
  fi
done
echo ?
