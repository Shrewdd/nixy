{ config, pkgs, ... }: let
  # Import Catppuccin Macchiato theme
  theme = import ../../themes/catppuccin-macchiato.nix;
  fontMain = "SF Pro Display, Inter, JetBrainsMono Nerd Font";
in {
  imports = [
  ];

  programs.waybar = {
    enable = true;
    settings.mainBar = {
      spacing = 2;
      margin-bottom = -3;
      height = 35;
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
        swap-icon-label = false;
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
        swap-icon-label = false;
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
        swap-icon-label = false;
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

    # Load CSS from separate file
    style = builtins.readFile ./style.css;

  };

}