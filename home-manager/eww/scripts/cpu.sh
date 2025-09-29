#!/usr/bin/env bash
# Outputs integer CPU usage percent
PREV=$(grep '^cpu ' /proc/stat)
sleep 0.5
CURR=$(grep '^cpu ' /proc/stat)
prev_idle=$(echo $PREV | awk '{print $5+$6}')
prev_total=$(echo $PREV | awk '{sum=0; for (i=2;i<=NF;i++) sum+=$i; print sum}')
curr_idle=$(echo $CURR | awk '{print $5+$6}')
curr_total=$(echo $CURR | awk '{sum=0; for (i=2;i<=NF;i++) sum+=$i; print sum}')
delta_total=$((curr_total-prev_total))
delta_idle=$((curr_idle-prev_idle))
usage=$((100*(delta_total-delta_idle)/delta_total))
printf '%s' "$usage"
