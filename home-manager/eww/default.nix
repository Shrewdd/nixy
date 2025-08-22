{ pkgs, ... }:
{
  programs.eww = {
    enable = true;
    package = pkgs.eww-wayland;
    configDir = ".config/eww"; # relative under $HOME
  };

  xdg.configFile."eww/eww.yuck".text = ''
(defwidget sep [] (box :class "sep" :width 6 ""))

(defpoll clock :interval "5s" "date '+%a %d %b %H:%M'")
(defpoll cpu_temp :interval "10s" "bash -c 'for p in /sys/class/hwmon/hwmon*/temp*_input; do l=${p%_*}_label; if [ -r $l ] && grep -qi package $l; then v=$(cat $p); echo $((v/1000)); exit; fi; done; echo ?'" )
(defpoll weather :interval "900s" "bash ~/.config/eww/scripts/weather.sh print")

(defwidget workspace-btn [id] (button :onclick "hyprctl dispatch workspace ${id}" id))
(defwidget workspaces [] (box :class "workspaces" :spacing 4 (workspace-btn :id "1") (workspace-btn :id "2") (workspace-btn :id "3") (workspace-btn :id "4") (workspace-btn :id "5")))

(defwidget bar []
  (centerbox :class "bar" :space-evenly "false"
    (box :class "left" :spacing 8 (workspaces))
    (box :class "center" (label :class "clock" :text clock))
    (box :class "right" :spacing 10 (label :class "cpu" :text " ${cpu_temp}°C") (label :class "weather" :text weather)))
)

(defwindow topbar
  :monitor 0 :geometry (geometry :x 8 :y 6 :width "100%" :height 32 :anchor "top center")
  :exclusive false :stacking "fg" :focusable false
  (bar))

'';

  xdg.configFile."eww/eww.scss".text = ''
$bg: #0b0c10;
$bg-alt: #12131a;
$fg: #e6e6ec;
$accent: #7c3aed;

* { all: unset; font-family: Inter, "JetBrainsMono Nerd Font"; font-size: 12px; }

.bar { background: $bg; padding: 4px 14px; border-radius: 14px; border: 1px solid rgba(124,58,237,0.25); }
.workspaces button { padding: 2px 10px; border-radius: 8px; background: transparent; color: lighten($fg, -20%); }
.workspaces button:hover { background: rgba(255,255,255,0.05); }
.clock { color: $fg; }
.cpu { color: $accent; }
.weather { color: lighten($accent, 15%); }
.sep { }
'';

  xdg.configFile."eww/scripts/weather.sh".text = ''
#!/usr/bin/env bash
set -euo pipefail
CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/eww-weather.json"
CITY="Lubniany"
MODE="${1:-print}"
if [ "$MODE" = update ]; then
  mkdir -p "$(dirname "$CACHE")"
  curl -sS "https://wttr.in/${CITY}?format=j1" > "$CACHE.tmp" && mv "$CACHE.tmp" "$CACHE"
fi
if [ -f "$CACHE" ]; then
  t=$(jq -r '.current_condition[0].temp_C' "$CACHE" 2>/dev/null || echo "?")
  desc=$(jq -r '.current_condition[0].weatherDesc[0].value' "$CACHE" 2>/dev/null | tr '[:upper:]' '[:lower:]')
  echo "${t}°C ${desc}"
else
  echo "--°C"
fi
'';
}
