{ pkgs, lib, ... }:
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;

    settings = [
      {
        layer = "top";
        position = "top";
        height = 24;
        margin = "2 8 0 8";
        spacing = 3;

        modules-left = [
          "hyprland/workspaces" "hyprland/window"
        ];
        modules-center = [ "clock" ];
        modules-right = [
          "custom/gpu_temp" "custom/cpu_temp"
          "pulseaudio" "backlight" "battery" "network"
          "custom/weather" "tray"
        ];

        "hyprland/workspaces" = {
          on-scroll-up = "hyprctl dispatch workspace e-1";
          on-scroll-down = "hyprctl dispatch workspace e+1";
          format = "{icon}";
          format-icons = {
            "1" = ""; "2" = ""; "3" = ""; "4" = ""; "5" = "";
            "urgent" = ""; "default" = ""; "active" = "";
          };
        };

        "hyprland/window".max-length = 50;

        clock = {
          format = "{:%a %d %b  %H:%M}";
          tooltip-format = "{:%A, %d %B %Y}";
        };

        backlight = {
          format = "{icon} {percent}%";
          format-icons = [ "󰃞" "󰃟" "󰃠" ];
          on-scroll-up = "brightnessctl set 5%+";
          on-scroll-down = "brightnessctl set 5%-";
        };

        battery = {
          format = "{icon} {percent}%";
          format-icons = [ "" "" "" "" "" ];
          states = { warning = 25; critical = 10; };
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = "󰝟 mute";
          format-bluetooth = "{icon} {volume}% ";
          format-icons = {
            default = [ "󰕿" "󰖀" "󰕾" ]; # low → high
            headphone = "";
          };
          on-click = "pavucontrol";
        };

        network = {
          format-wifi = "{icon} {signalStrength}%";
          format-ethernet = "󰈀";
          format-disconnected = "󰤮";
          tooltip = true;
          format-icons = [ "󰤯" "󰤟" "󰤢" "󰤥" "󰤨" ]; # wifi strength ramp
        };

        "custom/cpu_temp" = {
          exec = "/home/km/nixy/home-manager/waybar/scripts/cpu_temp.sh";
          interval = 10;
          return-type = "json";
        };

        "custom/gpu_temp" = {
          exec = "/home/km/nixy/home-manager/waybar/scripts/gpu_temp.sh";
          interval = 10;
          return-type = "json";
        };

        "custom/weather" = {
          exec = "/home/km/nixy/home-manager/waybar/scripts/weather.sh print";
          interval = 300;
          signal = 5;
          return-type = "json";
          on-click = "/home/km/nixy/home-manager/waybar/scripts/weather.sh update && pkill -SIGRTMIN+5 waybar";
          tooltip = true;
        };

        tray = { spacing = 4; };
      }
    ];

    style = ''
      /* Pure dark theme (no glass), subtle purple accents */
      @define-color fg        rgba(230,230,236,0.98);
      @define-color fg-muted  rgba(190,192,204,0.85);
      @define-color bg        #0b0c10;
      @define-color bg-alt    #12131a;
      @define-color accent    #7c3aed;   /* Hyprland purple */
      @define-color accent-2  #a78bfa;
      @define-color warn      #ffd479;
      @define-color err       #ff9580;

      * {
        font-family: Inter, Noto Sans, Cantarell, DejaVu Sans, "JetBrainsMono Nerd Font", sans-serif;
        font-size: 11.5px;
        color: @fg;
      }

      window#waybar {
        background: @bg;
        border-bottom: 1px solid rgba(167,139,250,0.12);
      }

      .modules-left, .modules-center, .modules-right { margin: 0 4px; }

      /* Text-first modules (no boxes) */
      #window, #clock, #backlight, #battery, #pulseaudio, #network, #tray,
      #custom-cpu_temp, #custom-gpu_temp, #custom-weather {
        background: transparent;
        padding: 1px 6px;
        margin: 0 3px;
        border: none;
      }

      /* Underline only on hover for a modern, non-distracting cue */
      #window:hover, #clock:hover, #backlight:hover, #battery:hover, #pulseaudio:hover,
      #network:hover, #custom-cpu_temp:hover, #custom-gpu_temp:hover, #custom-weather:hover {
        background: rgba(255,255,255,0.04);
        border-radius: 6px;
        box-shadow: inset 0 -2px 0 0 rgba(124,58,237,0.35);
      }

      /* Workspaces: skinny underline for active (no filled pills) */
      #workspaces { padding: 0 2px; }
      #workspaces button {
        color: @fg-muted;
        padding: 1px 8px;
        margin: 0 2px;
        background: transparent;
        border: none;
        border-bottom: 2px solid transparent;
        border-radius: 6px;
      }
      #workspaces button:hover {
        background: rgba(255,255,255,0.04);
      }
      #workspaces button.active {
        color: @fg;
        border-bottom-color: rgba(167,139,250,0.85);
      }
      #workspaces button.urgent {
        color: @fg;
        border-bottom-color: @err;
      }

      #window { color: @fg-muted; }
      #battery.warning, #network.disconnected { color: @warn; }
      #battery.critical { color: @err; }

      tooltip {
        background: @bg-alt;
        color: @fg;
        border: 1px solid rgba(167,139,250,0.20);
        border-radius: 8px;
      }
    '';
  };
}
