#!/usr/bin/env bash
# Outputs integer memory usage percent (MemAvailable aware if present)
read -r mem_total mem_free mem_avail <<< $(awk '/MemTotal:/ {t=$2} /MemFree:/ {f=$2} /MemAvailable:/ {a=$2} END {print t,f,a}' /proc/meminfo)
if [ -n "$mem_avail" ] && [ "$mem_avail" -gt 0 ]; then
  used=$((mem_total-mem_avail))
else
  # fallback
  used=$((mem_total-mem_free))
fi
printf '%s' $((100*used/mem_total))
