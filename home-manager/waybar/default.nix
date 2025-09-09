{ config, pkgs, ... }: let
  palette = {
    bg = "1a1b26";          # sophisticated dark background
    surface = "24283b";     # elevated professional surface
    text = "c0caf5";        # crisp professional white
    subtext = "a9b1d6";     # refined secondary text
    accent = "bb9af7";      # premium purple accent
    accentDark = "565f89";  # professional contrast
    border = "414868";      # refined borders
  };
  fontMain = "SF Pro Display, Inter, JetBrainsMono Nerd Font";
in {
  imports = [
  ];


  programs.waybar = {
    enable = true;
    settings.mainBar = {
      spacing = 2;
      margin-bottom = -3;
      height = 36;
      modules-left = ["hyprland/workspaces" "hyprland/window"];
      modules-center = [];
      modules-right = [
        "network"
        "bluetooth"
        "wireplumber"
        "tray"
        "clock"
      ];

      clock = {
        timezone = "Europe/Paris";
        tooltip-format = "<span>{calendar}</span>";
        calendar = {
          mode = "month";
          format = {
            today = "<span color='#e7bbe4'><b>{}</b></span>";
            days = "<span color='#cdd6f4'><b>{}</b></span>";
            weekdays = "<span color='#7cd37c'><b>{}</b></span>";
            months = "<b>{}</b>";
          };
        };
        interval = 60;
        max-length = 25;
        format = "{:%H:%M  %d/%m}";
        format-alt = "{:%A, %d %B %Y}";
      };

      "hyprland/window" = {
        format = "{}";
        rewrite = {"^(.*?)[[:space:]]*[-—|].*?$" = "$1";};
        icon = true;
        icon-size = 20;
        max-length = 30;
      };

      "hyprland/workspaces" = {
        format = "{icon}";
        format-active = " {icon} ";
        all-outputs = true;
      };

      wireplumber = {
        format = "{icon} {volume}%";
        format-muted = "󰖁 muted";
        format-icons = ["󰕿" "󰖀" "󰕾"];
        on-click = "sound-toggle";
        scroll-step = 2;
        tooltip-format = "Volume: {volume}%";
      };

      network = {
        format-wifi = "󰤨 {signalStrength}%";
        format-ethernet = "󰈀 {bandwidthDownBytes}";
        format-disconnected = "󰤭 offline";
        tooltip-format = "{ifname}: {ipaddr}";
        tooltip-format-wifi = "{essid} ({signalStrength}%): {ipaddr}";
        tooltip-format-ethernet = "{ifname}: {ipaddr}";
        interval = 5;
      };

      bluetooth = {
        format = "󰂯 {status}";
        format-disabled = "󰂲";
        format-off = "󰂲";
        format-on = "󰂯";
        format-connected = "󰂱 {device_alias}";
        format-connected-battery = "󰂱 {device_alias} {device_battery_percentage}%";
        tooltip-format = "{controller_alias}\t{controller_address}";
        tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{device_enumerate}";
        tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
        tooltip-format-enumerate-connected-battery = "{device_alias}\t{device_address}\t{device_battery_percentage}%";
        on-click = "bluetoothctl power toggle";
        max-length = 30;
      };

      tray = {
        icon-size = 16;
        spacing = 8;
        show-passive-items = true;
      };
    };

    style = ''
      * { font-family: ${fontMain}, sans-serif; font-weight: 600; font-size: 12px; }
      window#waybar { 
        background: transparent; 
        box-shadow: inset 0 -2px 4px rgba(0,0,0,0.1);
      }

      /* Workspace pills */
      #workspaces { background: transparent; margin: 2px 6px 2px 12px; }
      #workspaces button {
        background: #${palette.surface};
        color: #${palette.text};
        border: 2px solid #${palette.border};
        padding: 2px 12px;
        margin: 0 3px 0 0;
        border-radius: 12px;
        font-size: 11px;
        font-weight: 700;
        letter-spacing: 0.5px;
      }
      #workspaces button.empty { opacity: .3; }
      #workspaces button.active { 
        background: #${palette.surface}; 
        color: #${palette.accent}; 
        border: 2px solid #${palette.accent}; 
        padding: 3px 14px; 
      }
      #workspaces button:hover { 
        background: #${palette.surface}; 
        color: #${palette.accent}; 
        border-color: #${palette.accent};
      }
      #workspaces button:active { padding: 2px 11px; }

      /* Clock with clean blue styling */
      #clock {
        background: #${palette.surface};
        border: 2px solid #89b4fa;
        color: #89b4fa;
        font-weight: 700;
      }

      /* Window module with clean orange styling */
      #window {
        background: #${palette.surface};
        border: 2px solid #fab387;
        color: #fab387;
        font-weight: 600;
      }

      #wireplumber, #wireplumber.muted { 
        background: #${palette.surface}; 
        color: #${palette.accent}; 
        border: 2px solid #${palette.accent}; 
        font-weight: 800;
      }
      #wireplumber.muted { 
        opacity: .6; 
        color: #${palette.subtext};
        border-color: #${palette.accentDark};
      }

      /* Network module with green neon styling */
      #network {
        background: #${palette.surface};
        border: 2px solid #a6e3a1;
        color: #a6e3a1;
        font-weight: 700;
      }
      #network.disconnected {
        background: #${palette.surface};
        border: 2px solid #f38ba8;
        color: #f38ba8;
        font-weight: 700;
      }

      /* Bluetooth module with purple neon styling */
      /* Ensure container and common connected states show the neon outline */
      #bluetooth, #bluetooth.connected, #bluetooth.connected-battery {
        background: #${palette.surface};
        border: 2px solid #cba6f7;
        color: #cba6f7;
        font-weight: 700;
  padding: 2px 10px;
        border-radius: 12px;
      }
      #bluetooth.disabled, #bluetooth.off {
        background: #${palette.surface};
        border: 2px solid #${palette.accentDark};
        color: #${palette.subtext};
        opacity: 0.5;
      }
      /* Inner elements should not create additional borders; inherit container look */
      #bluetooth > *, #bluetooth .text, #bluetooth .icon {
        background: transparent;
        color: inherit;
        border: none;
        padding: 0;
        margin: 0 4px 0 0;
      }

      /* System tray with yellow neon styling */
      #tray {
        background: #${palette.surface};
        border: 2px solid #f9e2af;
        color: #f9e2af;
        font-weight: 700;
      }

      /* Shared module look */
      #window, #clock, #wireplumber, #network, #bluetooth, #tray {
        background: #${palette.surface};
        color: #${palette.text};
        padding: 2px 12px;
        margin: 2px 3px 2px 0;
        font-size: 11px;
        font-weight: 600;
        border-radius: 12px;
        /* no base border here, modules set their own neon 2px borders above */
        letter-spacing: 0.3px;
        box-shadow: 0 0 8px rgba(65, 72, 104, 0.3);
      }

  /* tray child items intentionally left unstyled so background service icons stay untouched */

      /* Temperature modules with distinct modern styling */
      #custom-cpu_temp {
        background: #${palette.surface};
        border: 2px solid #f38ba8;
        color: #f38ba8;
        font-weight: 700;
      }
      
      #custom-gpu_temp {
        background: #${palette.surface};
        border: 2px solid #a6e3a1;
        color: #a6e3a1;
        font-weight: 700;
      }

      /* Clock with modern blue styling */
      #clock {
        background: #${palette.surface};
        border: 2px solid #89b4fa;
        color: #89b4fa;
        font-weight: 700;
      }

      /* Window module with refined styling */
      #window {
        background: #${palette.surface};
        border: 2px solid #fab387;
        color: #fab387;
        font-weight: 600;
      }

      #wireplumber, #wireplumber.muted { 
        background: #${palette.surface}; 
        color: #${palette.accent}; 
        border: 2px solid #${palette.accent}; 
        font-weight: 800;
      }
      #wireplumber.muted { 
        opacity: .6; 
        color: #${palette.subtext};
        border-color: #${palette.accentDark};
      }
    '';
  };
}