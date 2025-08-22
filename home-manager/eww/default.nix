{ pkgs, ... }:
{
  programs.eww = {
    enable = true;
    package = pkgs.eww-wayland;
    configDir = null; # managing files via xdg.configFile below
  };

  xdg.configFile."eww/eww.yuck".text = ''
(defwidget sep [] (box :class "sep" :width 6 ""))

(defpoll clock :interval "5s" "date '+%a %d %b %H:%M'")
(defpoll cpu_temp :interval "10s" "~/.config/eww/scripts/cpu_temp.sh")
(defpoll gpu_temp :interval "15s" "~/.config/eww/scripts/gpu_temp.sh")
(defpoll weather :interval "900s" "~/.config/eww/scripts/weather.sh print")

(defwidget workspace-btn [id]
  (button :onclick (str "hyprctl dispatch workspace " id) id))
(defwidget workspaces [] (box :class "workspaces" :spacing 4 (workspace-btn :id "1") (workspace-btn :id "2") (workspace-btn :id "3") (workspace-btn :id "4") (workspace-btn :id "5")))

(defwidget bar []
  (centerbox :class "bar" :space-evenly "false"
    (box :class "left" :spacing 8 (workspaces))
    (box :class "center" (label :class "clock" :text clock))
  (box :class "right" :spacing 10 (label :class "gpu" :text "󰢮 ''${gpu_temp}°C") (label :class "cpu" :text " ''${cpu_temp}°C") (label :class "weather" :text weather)))
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

  # External scripts now tracked directly in repo under home-manager/eww/scripts
  xdg.configFile."eww/scripts/weather.sh" = { source = ./scripts/weather.sh; executable = true; };
  xdg.configFile."eww/scripts/cpu_temp.sh" = { source = ./scripts/cpu_temp.sh; executable = true; };
  xdg.configFile."eww/scripts/gpu_temp.sh" = { source = ./scripts/gpu_temp.sh; executable = true; };
}
