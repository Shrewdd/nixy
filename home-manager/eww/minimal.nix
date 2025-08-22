{ pkgs, ... }:
{
  programs.eww = {
    enable = true;
    package = pkgs.eww;
    configDir = null;
  };

  xdg.configFile."eww/eww.yuck".text = ''
;; Minimal floating pills - productivity focused
(defpoll clock :interval "5s" "date '+%H:%M'")
(defpoll cpu_temp :interval "10s" "~/.config/eww/scripts/cpu_temp.sh")
(defpoll weather :interval "900s" "~/.config/eww/scripts/weather.sh print")

(defwidget workspace-dot [id]
  (button :class "ws-dot" :onclick (str "hyprctl dispatch workspace " id) ""))

(defwidget workspaces []
  (box :class "ws-container" :spacing 6
    (workspace-dot :id "1")
    (workspace-dot :id "2") 
    (workspace-dot :id "3")
    (workspace-dot :id "4")
    (workspace-dot :id "5")))

(defwidget floating-bar []
  (centerbox :class "floating-bar"
    (box :class "pill ws-pill" (workspaces))
    (box :class "pill time-pill" (label :class "time" :text clock))
    (box :class "pill info-pill" :spacing 8
      (label :class "temp" :text (str cpu_temp "°"))
      (label :class "weather-icon" :text ""))))

(defwindow topbar
  :monitor 0
  :geometry (geometry :x 0 :y 12 :width "100%" :height 36 :anchor "top center")
  :exclusive false :stacking "fg" :focusable false
  (floating-bar))
'';

  xdg.configFile."eww/eww.scss".text = ''
$bg: #0a0a0f;
$glass: rgba(20, 20, 26, 0.75);
$fg: #e8e8f0;
$fg-dim: #9ca3af;
$accent: #8b5cf6;
$accent-dim: #a78bfa;

* { all: unset; font-family: "Inter", "SF Pro Display", system-ui; font-size: 11px; }

/* Main container - invisible background */
.floating-bar { 
  background: transparent; 
  padding: 0 24px; 
}

/* Pills - minimal rounded shapes */
.pill { 
  background: $glass;
  backdrop-filter: blur(20px) saturate(120%);
  -webkit-backdrop-filter: blur(20px) saturate(120%);
  border: 1px solid rgba(139, 92, 246, 0.15);
  border-radius: 18px;
  padding: 6px 12px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.4);
  transition: all 0.2s cubic-bezier(0.23, 1, 0.32, 1);
}

.pill:hover {
  border-color: rgba(139, 92, 246, 0.3);
  transform: translateY(-1px);
  box-shadow: 0 6px 16px rgba(0, 0, 0, 0.5);
}

/* Workspace dots */
.ws-container { }
.ws-dot {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background: $fg-dim;
  transition: all 0.15s ease;
}

.ws-dot:hover {
  background: $accent;
  transform: scale(1.2);
}

/* Time display */
.time {
  color: $fg;
  font-weight: 500;
  font-variant-numeric: tabular-nums;
}

/* Info section */
.info-pill {
  min-width: 60px;
}

.temp {
  color: $accent-dim;
  font-weight: 500;
}

.weather-icon {
  color: $fg-dim;
  font-size: 12px;
}

/* Subtle glow effect */
.pill {
  box-shadow: 
    0 4px 12px rgba(0, 0, 0, 0.4),
    inset 0 1px 0 rgba(255, 255, 255, 0.1);
}

/* Reduce opacity when not hovered to stay minimal */
.floating-bar:not(:hover) .pill {
  opacity: 0.85;
}
'';

  # Scripts
  xdg.configFile."eww/scripts/weather.sh" = { source = ./scripts/weather.sh; executable = true; };
  xdg.configFile."eww/scripts/cpu_temp.sh" = { source = ./scripts/cpu_temp.sh; executable = true; };
  xdg.configFile."eww/scripts/gpu_temp.sh" = { source = ./scripts/gpu_temp.sh; executable = true; };
}
