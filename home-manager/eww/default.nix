{ config, pkgs, ... }: let
  ewwYuck = ''
(defvar bg "1a1b26")
(defvar surface "24283b")
(defvar text "c0caf5")
(defvar subtext "a9b1d6")
(defvar accent "bb9af7")
(defvar accentDark "565f89")
(defvar border "414868")
(defvar fontMain "SF Pro Display, Inter, JetBrainsMono Nerd Font")

(defwidget bar []
  (centerbox :orientation "h"
    :class "bar"
    (box :class "left"
      (workspaces)
      (window))
    (box :class "center")
    (box :class "right"
      (network)
      (bluetooth)
      (wireplumber)
      (systray)
      (clock))))

(defwidget workspaces []
  (box :class "workspaces"
    (for workspace in (hyprland/workspaces)
      (button :class "workspace ''${workspace.active ? 'active' : 'inactive'}"
        :onclick "hyprctl dispatch workspace ''${workspace.id}"
        "''${workspace.name}"))))

(defwidget window []
  (box :class "window"
    (label :text (hyprland/window :format "{}"
                                  :rewrite {"^(.*?)[[:space:]]*[-—|].*?$" "$1"}
                                  :icon true
                                  :icon-size 20
                                  :max-length 30))))

(defwidget network []
  (box :class "network"
    (label :text (network :format-wifi "󰤨 {signalStrength}%"
                          :format-ethernet "󰈀 {bandwidthDownBytes}"
                          :format-disconnected "󰤭 offline"
                          :tooltip-format "{ifname}: {ipaddr}"
                          :tooltip-format-wifi "{essid} ({signalStrength}%): {ipaddr}"
                          :tooltip-format-ethernet "{ifname}: {ipaddr}"
                          :interval 5))))

(defwidget bluetooth []
  (box :class "bluetooth"
    (label :text (bluetooth :format "󰂯 {status}"
                            :format-disabled "󰂲"
                            :format-off "󰂲"
                            :format-on "󰂯"
                            :format-connected "󰂱 {device_alias}"
                            :format-connected-battery "󰂱 {device_alias} {device_battery_percentage}%"
                            :tooltip-format "{controller_alias}\t{controller_address}"
                            :tooltip-format-connected "{controller_alias}\t{controller_address}\n\n{device_enumerate}"
                            :tooltip-format-enumerate-connected "{device_alias}\t{device_address}"
                            :tooltip-format-enumerate-connected-battery "{device_alias}\t{device_address}\t{device_battery_percentage}%"
                            :on-click "bluetoothctl power toggle"
                            :max-length 30))))

(defwidget wireplumber []
  (box :class "wireplumber"
    (label :text (wireplumber :format "{icon} {volume}%"
                              :format-muted "󰖁 muted"
                              :format-icons ["󰕿" "󰖀" "󰕾"]
                              :on-click "sound-toggle"
                              :scroll-step 2
                              :tooltip-format "Volume: {volume}%"))))

(defwidget systray []
  (box :class "tray"
    (systray :icon-size 16
             :spacing 8
             :show-passive-items true)))

(defwidget clock []
  (box :class "clock"
    (label :text (date :timezone "Europe/Paris"
                       :interval 60
                       :max-length 25
                       :format "{:%H:%M  %d/%m}"
                       :format-alt "{:%A, %d %B %Y}"))))

(defwindow bar
  :monitor 0
  :geometry (geometry :x "0%"
                      :y "0%"
                      :width "100%"
                      :height "36px"
                      :anchor "top center")
  :stacking "fg"
  :windowtype "dock"
  :wm-ignore false
  (bar))
'';

  ewwScss = ''
* {
  font-family: ''${fontMain}, sans-serif;
  font-weight: 600;
  font-size: 12px;
}

window#bar {
  background: transparent;
  box-shadow: inset 0 -2px 4px rgba(0,0,0,0.1);
}

.workspaces {
  background: transparent;
  margin: 2px 6px 2px 12px;
}

.workspace {
  background: #''${surface};
  color: #''${text};
  border: 2px solid #''${border};
  padding: 2px 12px;
  margin: 0 3px 0 0;
  border-radius: 12px;
  font-size: 11px;
  font-weight: 700;
  letter-spacing: 0.5px;
}

.workspace.inactive {
  opacity: 0.3;
}

.workspace.active {
  background: #''${surface};
  color: #''${accent};
  border: 2px solid #''${accent};
  padding: 3px 14px;
}

.workspace:hover {
  background: #''${surface};
  color: #''${accent};
  border-color: #''${accent};
}

.clock {
  background: #''${surface};
  border: 2px solid #89b4fa;
  color: #89b4fa;
  font-weight: 700;
}

.window {
  background: #''${surface};
  border: 2px solid #fab387;
  color: #fab387;
  font-weight: 600;
}

.wireplumber, .wireplumber.muted {
  background: #''${surface};
  color: #''${accent};
  border: 2px solid #''${accent};
  font-weight: 800;
}

.wireplumber.muted {
  opacity: 0.6;
  color: #''${subtext};
  border-color: #''${accentDark};
}

.network {
  background: #''${surface};
  border: 2px solid #a6e3a1;
  color: #a6e3a1;
  font-weight: 700;
}

.network.disconnected {
  background: #''${surface};
  border: 2px solid #f38ba8;
  color: #f38ba8;
  font-weight: 700;
}

.bluetooth, .bluetooth.connected, .bluetooth.connected-battery {
  background: #''${surface};
  border: 2px solid #cba6f7;
  color: #cba6f7;
  font-weight: 700;
  padding: 2px 10px;
  border-radius: 12px;
}

.bluetooth.disabled, .bluetooth.off {
  background: #''${surface};
  border: 2px solid #''${accentDark};
  color: #''${subtext};
  opacity: 0.5;
}

.tray {
  background: #''${surface};
  border: 2px solid #f9e2af;
  color: #f9e2af;
  font-weight: 700;
}

.window, .clock, .wireplumber, .network, .bluetooth, .tray {
  background: #''${surface};
  color: #''${text};
  padding: 2px 12px;
  margin: 2px 3px 2px 0;
  font-size: 11px;
  font-weight: 600;
  border-radius: 12px;
  letter-spacing: 0.3px;
  box-shadow: 0 0 8px rgba(65, 72, 104, 0.3);
}
'';
in {
  programs.eww = {
    enable = true;
    configDir = pkgs.runCommand "eww-config" {} ''
      mkdir -p $out
      echo '${ewwYuck}' > $out/eww.yuck
      echo '${ewwScss}' > $out/eww.scss
      cp ${../waybar/modules/cpu_temp.sh} $out/cpu_temp.sh
      cp ${../waybar/modules/gpu_temp.sh} $out/gpu_temp.sh
      chmod +x $out/*.sh
    '';
  };
}