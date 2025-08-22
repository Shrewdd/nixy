#!/usr/bin/env bash
set -euo pipefail

WALL_DIR="$HOME/nixy/home-manager/hyprland/hyprpaper/wallpapers"
PRIMARY="desc:Samsung Electric Company LS24C33xG H9TX501846"
SECONDARY="desc:Samsung Electric Company LS24C33xG H9TX501795"
MODE=next
TARGETS=all

mkdir -p "$WALL_DIR"
LIST_TMP=$(mktemp)
find "$WALL_DIR" -maxdepth 4 -type f \
  \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.webp' \) \
  -print | sort -f > "$LIST_TMP"
COUNT=$(wc -l < "$LIST_TMP" | tr -d ' ')
if [ "$COUNT" = 0 ]; then
  echo "No images in $WALL_DIR" >&2
  rm -f "$LIST_TMP"; exit 1
fi
STATE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}"
mkdir -p "$STATE_DIR"
STATE_FILE="$STATE_DIR/hyprpaper-index"
[ -f "$STATE_FILE" ] && CUR_IDX=$(cat "$STATE_FILE" 2>/dev/null) || CUR_IDX=0
[ -z "$CUR_IDX" ] && CUR_IDX=0
case "$MODE" in
  next) IDX=$(( (CUR_IDX + 1) % COUNT )) ;;
  prev) IDX=$(( (CUR_IDX - 1 + COUNT) % COUNT )) ;;
  random) IDX=$(( RANDOM % COUNT )) ;;
  *) IMG="$MODE"; IDX=$CUR_IDX ;;
esac
if [ -z "${IMG:-}" ]; then
  LINE=$(( IDX + 1 ))
  IMG=$(sed -n "${LINE}p" "$LIST_TMP")
fi
rm -f "$LIST_TMP"
echo "$IDX" > "$STATE_FILE"
if [ -z "$IMG" ] || [ ! -f "$IMG" ]; then echo "Invalid image: $IMG" >&2; rm -f "$LIST_TMP"; exit 1; fi
IMG=$(readlink -f "$IMG")
hyprctl hyprpaper preload "$IMG" >/dev/null 2>&1 || true
apply_wall(){ hyprctl hyprpaper wallpaper "$1","$IMG" >/dev/null 2>&1 || true; }
case "$TARGETS" in
  all) apply_wall "$PRIMARY"; apply_wall "$SECONDARY" ;;
  primary) apply_wall "$PRIMARY" ;;
  secondary) apply_wall "$SECONDARY" ;;
  *) apply_wall "$TARGETS" ;;
esac
ACTIVE_SET=$(hyprctl hyprpaper list 2>/dev/null | awk '/CURRENT/ {print $2}' | sort -u || true)
hyprctl hyprpaper list 2>/dev/null | awk '/PRELOADED/ {print $2}' | while read -r cached; do
  [ "$cached" = "$IMG" ] && continue
  echo "$ACTIVE_SET" | grep -q "$cached" && continue
  hyprctl hyprpaper unload "$cached" >/dev/null 2>&1 || true
done
notify-send -r 9911 "Wallpaper" "$(basename "$IMG")" -i "$IMG" 2>/dev/null || true
