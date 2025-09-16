{ pkgs, lib, ... }:
let
  theme = import ../../shared/theme/catppuccin/macchiato.nix;
in
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
        "waybar"
      ];


      monitor = [
        "desc:Samsung Electric Company LS24C33xG H9TX501846, 1920x1080@100, 0x0, 1"
        "desc:Samsung Electric Company LS24C33xG H9TX501795, 1920x1080@100, 1920x0, 1"
      ];

      general = {
        layout = "dwindle";
        border_size = 3;
        "col.active_border" = "${theme.rgb.mauve} ${theme.rgb.lavender} 135deg"; # gradient with mauve and lavender
        "col.inactive_border" = theme.rgb.base;
        gaps_in = 2;
        gaps_out = 8;
      };

      group = {
        "col.border_active" = "${theme.rgb.blue} ${theme.rgb.teal} 135deg"; # blue to teal
        "col.border_inactive" = theme.rgb.surface1;
        "col.border_locked_active" = "${theme.rgb.yellow} ${theme.rgb.peach} 135deg"; # yellow to peach
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
          color = "rgba(1a1a1a80)"; # semi-transparent dark shadow
          color_inactive = "rgba(00000060)"; # semi-transparent inactive shadow
        };
      };

      bind = [
        "$mainMod, RETURN, exec, $terminal"
        "$mainMod, Q, killactive,"
        "$mainMod, M, exit,"
        "$mainMod, E, exec, $fileManager"
        "$mainMod, V, togglefloating,"
        "$mainMod, A, exec, $menu"
        "$mainMod, P, pseudo"
        "$mainMod, J, togglesplit"
        "$mainMod, X, exec, bash /home/km/nixy/home-manager/rofi/scripts/powermenu/powermenu"
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"
        "$mainMod, W, exec, bash /home/km/nixy/home-manager/hyprland/hyprpaper/change-wallpaper.sh"
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
        "$mainMod, Print, exec, bash -c 'f=~/Downloads/screenshot-$(date +%Y%m%d-%H%M%S).png; grimblast save screen --freeze \"$f\" && wl-copy < \"$f\" && notify-send -i \"$f\" \"Screenshot Saved\" \"$f\"'"
        ", Print, exec, bash -c 'f=~/Downloads/screenshot-$(date +%Y%m%d-%H%M%S).png; grimblast save area --freeze \"$f\" && wl-copy < \"$f\" && notify-send -i \"$f\" \"Screenshot Saved\" \"$f\"'"
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      bindel = [
        # Volume Up
        ",XF86AudioRaiseVolume, exec, bash -c 'wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+ && notify-send -r 9991 \" Volume Up\" \"$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk \"{print int(\$2*100) \\\"%\\\"}\")\"'"
        # Volume Down
        ",XF86AudioLowerVolume, exec, bash -c 'wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- && notify-send -r 9991 \" Volume Down\" \"$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk \"{print int(\$2*100) \\\"%\\\"}\")\"'"
        # Volume Mute
        ",XF86AudioMute, exec, bash -c 'wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && notify-send -r 9991 \" Volume Mute\" \"$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk \"{print (\$3==\"MUTED\"?\"Muted\":int(\$2*100) \\\"%\\\")}\")\"'"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
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
        # Catppuccin-themed window rules
        "bordercolor ${theme.rgb.blue}, class:(firefox)" # blue
        "bordercolor ${theme.rgb.green}, class:(code)" # green
        "bordercolor ${theme.rgb.yellow}, class:(.*terminal.*)" # yellow
        "bordercolor ${theme.rgb.pink}, class:(.*discord.*)" # pink
        "bordercolor ${theme.rgb.teal}, class:(.*spotify.*)" # teal
      ];

      windowrulev2 = [
        # More specific window rules with Catppuccin colors
        "bordercolor ${theme.rgb.red}, class:(.*steam.*)" # red
        "bordercolor ${theme.rgb.peach}, class:(.*thunar.*)" # peach
        "opacity 0.9 0.9, class:(.*terminal.*)"
        "opacity 0.95 0.95, class:(.*)"
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
}
