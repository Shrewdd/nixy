{ pkgs, lib, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      "$mainMod" = "SUPER";
      "$terminal" = "ghostty";
      "$fileManager" = "thunar";
      "$menu" = "rofi -show drun";


      "exec-once" = [
        "systemctl --user start hyprpolkitagent"
      ];


      monitor = [
        "desc:Samsung Electric Company LS24C33xG H9TX501846, 1920x1080@100, 0x0, 1"
        "desc:Samsung Electric Company LS24C33xG H9TX501795, 1920x1080@100, 1920x0, 1"
      ];

      general = {
        layout = "dwindle";
        border_size = 3;

        # Border colors live in `general` as `col.*`
        "col.active_border" = "rgba(167,139,250,1.0) rgba(124,58,237,1.0) 135deg"; # soft purple gradient
        "col.inactive_border" = "rgba(58,48,73,0.85)"; # muted, low-contrast purple
      };

      dwindle = {
        preserve_split = true;
      };

      animations = {
        enabled = true;
        bezier = [
          "fast, 0.7, 0.9, 0.2, 1.0"
        ];
        animation = [
          "windows, 1, 5, fast, slide"
          "windowsOut, 1, 5, fast, slide"
          "border, 1, 5, fast"
          "fade, 1, 5, fast"
          "workspaces, 1, 5, fast, slide"
        ];
      };

      # Remove the invalid keys from `decoration` (keep empty or add blur/rounding later)
      decoration = { };

      bind = [
        "$mainMod, RETURN, exec, $terminal"
        "$mainMod, Q, killactive,"
        "$mainMod, M, exit,"
        "$mainMod, E, exec, $fileManager"
        "$mainMod, V, togglefloating,"
        "$mainMod, A, exec, $menu"
        "$mainMod, P, pseudo"
        "$mainMod, J, togglesplit"
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"
        "$mainMod, W, exec, ~/.local/bin/set-wall.sh random all"
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
        # Screenshot keybinds
        "$mainMod, Print, exec, bash -c 'f=~/Downloads/screenshot-$(date +%Y%m%d-%H%M%S).png; grimblast save screen --freeze \"$f\" && notify-send -i \"$f\" \"Screenshot Saved\" \"$f\"'"
        ", Print, exec, bash -c 'f=~/Downloads/screenshot-$(date +%Y%m%d-%H%M%S).png; grimblast save area --freeze \"$f\" && notify-send -i \"$f\" \"Screenshot Saved\" \"$f\"'"
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      bindel = [
        # Volume Up
        ",XF86AudioRaiseVolume, exec, bash -c 'wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+ && notify-send -r 9991 \"Volume Up\" \"$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk \"{print int(\$2*100) \\\"%\\\"}\")\"'"
        # Volume Down
        ",XF86AudioLowerVolume, exec, bash -c 'wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- && notify-send -r 9991 \"Volume Down\" \"$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk \"{print int(\$2*100) \\\"%\\\"}\")\"'"
        # Volume Mute
        ",XF86AudioMute, exec, bash -c 'wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && notify-send -r 9991 \"Volume Mute\" \"$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk \"{print (\$3==\"MUTED\"?\"Muted\":int(\$2*100) \\\"%\\\")}\")\"'"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
        ",XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
      ];

      bindl = [
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
      ];

      windowrule = [
        "suppressevent maximize, class:.*"
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
      ];
    };
  };
}
