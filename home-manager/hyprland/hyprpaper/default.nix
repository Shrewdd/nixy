{ config, pkgs, ... }:
let
  wallDir = "${config.home.homeDirectory}/Pictures/wallpapers";
  primaryMon = "desc:Samsung Electric Company LS24C33xG H9TX501846";
  secondaryMon = "desc:Samsung Electric Company LS24C33xG H9TX501795";
  mainWall = "${wallDir}/cutiepatootie.png";
in {
  home.file."Pictures/wallpapers/cutiepatootie.png".source = ./wallpapers/cutiepatootie.png;

  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
      preload = [ mainWall ];
      wallpaper = [
        "${primaryMon},${mainWall}"
        "${secondaryMon},${mainWall}"
      ];
    };
  };

  home.file.".local/bin/set-wall.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      set -euo pipefail
      WALL_DIR="${wallDir}"
      PRIMARY="${primaryMon}"
      SECONDARY="${secondaryMon}"
      pick_random() { find "${wallDir}" -maxdepth 4 -type f -iregex '.*\.(png|jpe?g|webp)$' | shuf -n1; }
      REQ_IMG="${1:-random}"
      TARGETS="${2:-all}"
      if [ "$REQ_IMG" = "random" ]; then IMG="$(pick_random || true)" || true; else IMG="$REQ_IMG"; fi
      if [ -z "${IMG:-}" ] || [ ! -f "$IMG" ]; then echo "Invalid image: $IMG" >&2; exit 1; fi
      IMG="$(readlink -f "$IMG")"
      hyprctl hyprpaper preload "$IMG" >/dev/null 2>&1 || true
      apply_wall() { hyprctl hyprpaper wallpaper "$1","$IMG" >/dev/null 2>&1 || true; }
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
      echo "Set $IMG"
    '';
  };
}
