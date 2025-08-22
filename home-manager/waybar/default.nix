{ pkgs, lib, ... }:
let
  weatherScript = pkgs.writeShellScript "waybar-weather" ''
    #!/usr/bin/env bash
    set -euo pipefail
    CACHE="''${XDG_CACHE_HOME:-$HOME/.cache}/waybar-weather.json"
    QUERY="Lubniany"

    case "''${1:-print}" in
      update)
        mkdir -p "$(dirname "$CACHE")"
        curl -sS "https://wttr.in/''${QUERY}?format=j1" > "$CACHE.tmp" && mv "$CACHE.tmp" "$CACHE"
        ;;
    esac

    if [[ -f "$CACHE" ]]; then
      temp=$(jq -r '.current_condition[0].temp_C' "$CACHE" 2>/dev/null || echo "?")
      icon=$(jq -r '.current_condition[0].weatherDesc[0].value' "$CACHE" 2>/dev/null | tr '[:upper:]' '[:lower:]' || echo "")
      sym="󰖙" # sunny
      case "$icon" in
        *snow*) sym="󰖘" ;;                 # snowy
        *rain*|*drizzle*) sym="󰖖" ;;       # pouring
        *cloud*|*overcast*) sym="󰖕" ;;     # cloudy
        *fog*|*mist*|*haze*) sym="󰙿" ;;    # fog
        *thunder*) sym="󰖓" ;;              # lightning
        *clear*|*sun*) sym="󰖙" ;;          # sunny
        *partly*|*broken*) sym="󰖗" ;;      # partly cloudy
      esac
      printf '{"text":"%s %s°C","tooltip":"%s • click to refresh","class":"weather"}\n' "$sym" "$temp" "$icon"
    else
      printf '{"text":"󰖙 --","tooltip":"Click to fetch weather","class":"weather"}\n'
    fi
  '';

  cpuTempScript = pkgs.writeShellScript "waybar-cpu-temp" ''
    #!/usr/bin/env bash
    set -euo pipefail
    temp_mC=""
    for path in /sys/class/hwmon/hwmon*/temp*_input; do
      labelFile=''${path%_*}_label
      if [[ -r "$labelFile" ]] && grep -qiE 'package|cpu' "$labelFile"; then
        temp_mC=$(cat "$path")
        break
      fi
    done
    if [[ -z "''${temp_mC:-}" ]]; then
      temp_mC=$(for f in /sys/class/thermal/thermal_zone*/temp; do [[ -r "$f" ]] && cat "$f"; done | sort -nr | head -n1 || true)
    fi
    if [[ -z "''${temp_mC:-}" ]]; then
      echo '{"text":"CPU ?°C","class":"temp cpu"}'
      exit 0
    fi
    temp_C=$(( temp_mC / 1000 ))
    printf '{"text":" %s°C","class":"temp cpu","tooltip":"CPU temp: %s°C"}\n' "$temp_C" "$temp_C"
  '';

  gpuTempScript = pkgs.writeShellScript "waybar-gpu-temp" ''
    #!/usr/bin/env bash
    set -euo pipefail
    if command -v nvidia-smi >/dev/null 2>&1; then
      t=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits 2>/dev/null | head -n1 || true)
      if [[ -n "''${t:-}" ]]; then
        printf '{"text":"󰢮 %s°C","class":"temp gpu nvidia","tooltip":"NVIDIA GPU temp: %s°C"}\n' "$t" "$t"
        exit 0
      fi
    fi
    for hw in /sys/class/drm/card*/device/hwmon/hwmon*/temp1_input; do
      if [[ -r "$hw" ]]; then
        t_mC=$(cat "$hw")
        t=$(( t_mC / 1000 ))
        printf '{"text":"󰢮 %s°C","class":"temp gpu amd","tooltip":"GPU temp: %s°C"}\n' "$t" "$t"
        exit 0
      fi
    done
    echo '{"text":"GPU --","class":"temp gpu","tooltip":"GPU temperature unavailable"}'
  '';
in
{
  programs.waybar = {
    enable = false; # temporarily disabled (keeping config for later)
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
          exec = "${cpuTempScript}";
          interval = 10;
          return-type = "json";
        };

        "custom/gpu_temp" = {
          exec = "${gpuTempScript}";
          interval = 10;
          return-type = "json";
        };

        "custom/weather" = {
          exec = "${weatherScript} print";
          interval = 300;
          signal = 5;
          return-type = "json";
          on-click = "${weatherScript} update && pkill -SIGRTMIN+5 waybar";
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
