{ config, lib, pkgs, ... }:

let
  theme = import ../../../../../assets/theme/everforest.nix;
  waybarStyle = ./waybar/style.css;
  waybarModulesDir = "${config.xdg.configHome}/waybar/modules";
in
{
  options.hm.desktop.hyprland = {
    enable = lib.mkEnableOption "Hyprland window manager user configuration";
  };

  config = lib.mkIf config.hm.desktop.hyprland.enable {
    wayland.windowManager.hyprland = {
      enable = true;

      settings = {
        "$mainMod" = "SUPER";
        "$terminal" = "ghostty";
        "$fileManager" = "nautilus";

        "exec-once" = [
          "systemctl --user start hyprpolkitagent"
          "waybar"
        ];

        monitor = [
          "desc:Samsung Electric Company LS24C33xG H9TX501846, 1920x1080@100, 0x0, 1"
          "desc:Samsung Electric Company LS24C33xG H9TX501795, 1920x1080@100, 1920x0, 1"
        ];

        general = {
          layout = "dwindle";
          border_size = 3;
          "col.active_border" = "${theme.rgb.green} ${theme.rgb.teal} 135deg";
          "col.inactive_border" = theme.rgb.surface1;
          gaps_in = 2;
          gaps_out = 8;
        };

        dwindle = {
          preserve_split = true;
        };

        group = {
          "col.border_active" = "${theme.rgb.blue} ${theme.rgb.sky} 135deg";
          "col.border_inactive" = theme.rgb.surface1;
          "col.border_locked_active" = "${theme.rgb.yellow} ${theme.rgb.peach} 135deg";
          "col.border_locked_inactive" = theme.rgb.surface1;
          groupbar = {
            font_size = 11;
            gradients = false;
          };
        };

        decoration = {
          rounding = 10;
          blur = {
            enabled = true;
            size = 3;
            passes = 1;
            new_optimizations = true;
          };
          shadow = {
            enabled = true;
            range = 4;
            render_power = 3;
            color = "rgba(1a1a1a80)";
            color_inactive = "rgba(00000060)";
          };
        };

        bind = [
          "$mainMod, RETURN, exec, $terminal"
          "$mainMod, E, exec, $fileManager"

          "$mainMod, Q, killactive,"
          "$mainMod, M, exit,"
          "$mainMod, V, togglefloating,"
          "$mainMod, P, pseudo"
          "$mainMod, J, togglesplit"

          "$mainMod, left, movefocus, l"
          "$mainMod, right, movefocus, r"
          "$mainMod, up, movefocus, u"
          "$mainMod, down, movefocus, d"

          "$mainMod, 1, workspace, 1"
          "$mainMod, 2, workspace, 2"
          "$mainMod, 3, workspace, 3"
          "$mainMod, 4, workspace, 4"
          "$mainMod, 5, workspace, 5"
          "$mainMod, 6, workspace, 6"
          "$mainMod, 7, workspace, 7"
          "$mainMod, 8, workspace, 8"
          "$mainMod, 9, workspace, 9"
          "$mainMod, 0, workspace, 10"

          "$mainMod SHIFT, 1, movetoworkspace, 1"
          "$mainMod SHIFT, 2, movetoworkspace, 2"
          "$mainMod SHIFT, 3, movetoworkspace, 3"
          "$mainMod SHIFT, 4, movetoworkspace, 4"
          "$mainMod SHIFT, 5, movetoworkspace, 5"
          "$mainMod SHIFT, 6, movetoworkspace, 6"
          "$mainMod SHIFT, 7, movetoworkspace, 7"
          "$mainMod SHIFT, 8, movetoworkspace, 8"
          "$mainMod SHIFT, 9, movetoworkspace, 9"
          "$mainMod SHIFT, 0, movetoworkspace, 10"

          "$mainMod, S, togglespecialworkspace, magic"
          "$mainMod SHIFT, S, movetoworkspace, special:magic"

          "$mainMod, mouse_down, workspace, e+1"
          "$mainMod, mouse_up, workspace, e-1"

          "$mainMod, R, focuswindow, class:robloxstudiobeta.exe,title:.* - Roblox Studio$"

          ''$mainMod, Print, exec, bash -c 'f=~/Downloads/screenshot-$(date +%Y%m%d-%H%M%S).png; grimblast save screen --freeze "$f" && wl-copy < "$f" && notify-send -i "$f" "Screenshot Saved" "$f"''
          '', Print, exec, bash -c 'f=~/Downloads/screenshot-$(date +%Y%m%d-%H%M%S).png; grimblast save area --freeze "$f" && wl-copy < "$f" && notify-send -i "$f" "Screenshot Saved" "$f"''
        ];

        bindm = [
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
        ];

        bindel = [
          ",XF86AudioRaiseVolume, exec, bash -c 'wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+ && vol=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk \"{print int(\\$2*100)}\") && notify-send -r 9991 -h int:value:$vol -a \"Volume\" \"Volume: $vol%\"'"
          ",XF86AudioLowerVolume, exec, bash -c 'wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- && vol=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk \"{print int(\\$2*100)}\") && notify-send -r 9991 -h int:value:$vol -a \"Volume\" \"Volume: $vol%\"'"
          ",XF86AudioMute, exec, bash -c 'wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && vol_info=$(wpctl get-volume @DEFAULT_AUDIO_SINK@) && if echo \"$vol_info\" | grep -q MUTED; then notify-send -r 9991 -h int:value:0 -a \"Volume\" \"Volume: Muted\"; else vol_num=$(echo \"$vol_info\" | awk \"{print int(\\$2*100)}\") && notify-send -r 9991 -h int:value:$vol_num -a \"Volume\" \"Volume: $vol_num%\"; fi'"
          ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ];

        bindl = [
          ", XF86AudioNext, exec, playerctl next"
          ", XF86AudioPause, exec, playerctl play-pause"
          ", XF86AudioPlay, exec, playerctl play-pause"
          ", XF86AudioPrev, exec, playerctl previous"
        ];

        bindr = [
          "$mainMod, SUPER_L, exec, bash -c 'qs -c dashboard ipc call dashboard toggle'"
        ];

        windowrule = [
          "suppressevent maximize, class:.*"
          "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
          "bordercolor ${theme.rgb.blue}, class:(.*zen.*)"
          "bordercolor ${theme.rgb.green}, class:(code)"
          "bordercolor ${theme.rgb.yellow}, class:(.*ghostty.*)"
          "bordercolor ${theme.rgb.mauve}, class:(.*vesktop.*)"
          "bordercolor ${theme.rgb.teal}, class:(.*spotify.*)"
        ];

        windowrulev2 = [
          "bordercolor ${theme.rgb.red}, class:(.*steam.*)"
          "bordercolor ${theme.rgb.peach}, class:(.*nautilus.*)"
          "opacity 0.9 0.9, class:(.*terminal.*)"
          "opacity 0.95 0.95, class:(.*)"
          "opacity 1.0 1.0, class:^(robloxstudiobeta.exe)$,title:(.* - Roblox Studio$|^Roblox Studio$)"
          "noblur, class:^(robloxstudiobeta.exe)$,title:(.* - Roblox Studio$|^Roblox Studio$)"
        ];

        misc = {
          force_default_wallpaper = 0;
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
          mouse_move_enables_dpms = true;
          key_press_enables_dpms = true;
        };
      };
    };

    programs.waybar = {
      enable = true;
      settings.mainBar = {
        spacing = 1;
        margin-bottom = -2;
        height = 30;
        modules-left = [ "hyprland/workspaces" "hyprland/window" ];
        modules-center = [ "bluetooth" ];
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
          max-length = 30;
          format = "{:%H:%M  %d/%m/%y}";
          format-alt = "{:%A, %d %B %Y}";
        };

        "hyprland/window" = {
          format = "{}";
          rewrite = { "^(.*?)[[:space:]]*[-—|].*?$" = "$1"; };
          icon = true;
          "icon-size" = 20;
          swap-icon-label = false;
          max-length = 30;
        };

        "hyprland/workspaces" = {
          format = "●";
          format-active = "<span background='#${theme.mauve}' color='#${theme.base}' font-weight='bold'>●</span>";
          all-outputs = true;
          show-special = false;
        };

        wireplumber = {
          format = "{icon} {volume}%";
          format-muted = "󰖁 muted";
          format-icons = [ "󰕿" "󰖀" "󰕾" ];
          scroll-step = 2;
          swap-icon-label = false;
          tooltip-format = "Volume: {volume}%";
          max-volume = 100;
          ignored-sinks = [ ];
        };

        bluetooth = {
          format = "";
          format-disabled = "";
          format-off = "";
          format-on = "";
          format-connected = "󰂱 {device_alias}";
          format-connected-battery = "󰂱 {device_alias} {device_battery_percentage}%";
          tooltip-format = "{controller_alias}\t{controller_address}";
          tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
          tooltip-format-enumerate-connected-battery = "{device_alias}\t{device_address}\t{device_battery_percentage}%";
          swap-icon-label = false;
          max-length = 30;
        };

        tray = {
          "icon-size" = 16;
          spacing = 8;
          show-passive-items = true;
        };

        "custom/cpu_temp" = {
          exec = "${waybarModulesDir}/cpu_temp.sh";
          return-type = "json";
          interval = 5;
          format = "{}";
          tooltip = true;
        };

        "custom/gpu_temp" = {
          exec = "${waybarModulesDir}/gpu_temp.sh";
          return-type = "json";
          interval = 5;
          format = "{}";
          tooltip = true;
        };

      };

      style = builtins.readFile waybarStyle;

    };

    xdg.configFile."waybar/modules/cpu_temp.sh" = {
      source = ./waybar/modules/cpu_temp.sh;
      executable = true;
    };

    xdg.configFile."waybar/modules/gpu_temp.sh" = {
      source = ./waybar/modules/gpu_temp.sh;
      executable = true;
    };

    home.packages = with pkgs; [
      hyprpolkitagent
      nautilus
    ];
  };
}
