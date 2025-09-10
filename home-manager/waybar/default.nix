{ config, pkgs, ... }: let
  theme = import ../../themes/catppuccin-macchiato.nix;
  palette = {
    bg = theme.base;
    surface = theme.surface0;
    text = theme.text;
    subtext = theme.subtext1;
    accent = theme.mauve;
    accentDark = theme.overlay0;
    border = theme.surface1;
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
      height = 42;
      modules-left = ["hyprland/workspaces" "hyprland/window"];
      modules-center = ["bluetooth"];
      modules-right = [
        "custom/cpu_temp"
        "custom/gpu_temp"
        "wireplumber"
        "clock"
        "tray"
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
        format = "{name}";
        format-active = "<span background='#${theme.mauve}' color='#${theme.base}' font-weight='bold'> {name} </span>";
        all-outputs = true;
        show-special = false;
      };

      wireplumber = {
        format = "{icon} {volume}%";
        format-muted = "󰖁 muted";
        format-icons = ["󰕿" "󰖀" "󰕾"];
        on-click = "sound-toggle";
        scroll-step = 2;
        tooltip-format = "Volume: {volume}%";
      };

      bluetooth = {
        format = "󰂯 {status}";
        format-disabled = "";
        format-off = "";
        format-on = "";
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

      "custom/cpu_temp" = {
        exec = "${./modules/cpu_temp.sh}";
        return-type = "json";
        interval = 5;
        format = "{}";
        tooltip = true;
      };

      "custom/gpu_temp" = {
        exec = "${./modules/gpu_temp.sh}";
        return-type = "json";
        interval = 5;
        format = "{}";
        tooltip = true;
      };
    };

    style = ''
      * { font-family: ${fontMain}, sans-serif; font-weight: 600; font-size: 12px; }
      window#waybar { 
        background: transparent; 
        box-shadow: inset 0 -2px 4px rgba(0,0,0,0.1);
      }

      /* Clustered workspace display */
      #workspaces {
        background: #${palette.surface};
        border: 2px solid #${palette.border};
        border-radius: 12px;
        margin: 2px 6px 2px 12px;
        padding: 2px 8px;
        font-size: 11px;
        font-weight: 700;
        letter-spacing: 0.5px;
      }
      #workspaces button {
        background: transparent;
        border: none;
        color: #${palette.subtext};
        padding: 2px 6px;
        margin: 0;
        border-radius: 8px;
        font-size: 11px;
        font-weight: 700;
        min-width: 20px;
      }
      #workspaces button.active {
        background: #${theme.mauve};
        color: #${theme.base};
        font-weight: bold;
      }
      #workspaces button:hover {
        background: #${palette.surface};
        color: #${palette.text};
      }

      /* Clock with clean blue styling */
      #clock {
        background: #${palette.surface};
        border: 2px solid #${theme.blue};
        color: #${theme.blue};
        font-weight: 700;
      }

      /* Window module with clean orange styling */
      #window {
        background: #${palette.surface};
        border: 2px solid #${theme.peach};
        color: #${theme.peach};
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

      /* Bluetooth module with purple neon styling */
      /* Only shows when connected - positioned in center */
      #bluetooth, #bluetooth.connected, #bluetooth.connected-battery {
        background: #${palette.surface};
        border: 2px solid #${theme.lavender};
        color: #${theme.lavender};
        font-weight: 700;
        padding: 2px 10px;
        border-radius: 12px;
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
        border: 2px solid #${theme.yellow};
        color: #${theme.yellow};
        font-weight: 700;
      }

      /* Shared module look */
      #window, #clock, #wireplumber, #tray, #custom-cpu_temp, #custom-gpu_temp {
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
        border: 2px solid #${theme.red};
        color: #${theme.red};
        font-weight: 700;
      }
      
      #custom-gpu_temp {
        border: 2px solid #${theme.green};
        color: #${theme.green};
        font-weight: 700;
      }

      /* Clock with modern blue styling */
      #clock {
        background: #${palette.surface};
        border: 2px solid #${theme.blue};
        color: #${theme.blue};
        font-weight: 700;
      }

      /* Window module with refined styling */
      #window {
        background: #${palette.surface};
        border: 2px solid #${theme.peach};
        color: #${theme.peach};
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