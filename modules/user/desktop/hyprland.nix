{ config, lib, pkgs, ... }:
let
  colors = config.lib.stylix.colors;

  stripHash = s: if lib.hasPrefix "#" s then lib.removePrefix "#" s else s;
  rgb = hex: "rgb(${stripHash hex})";
  gradient135 = a: b: "${rgb a} ${rgb b} 135deg";
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;

    settings = {
      "$mainMod" = "SUPER";
      "$terminal" = "ghostty";
      "$fileManager" = "thunar";
      "$menu" = "rofi -show drun";

      exec-once = [
        "hyprpolkitagent"
      ];

      monitor = [
        "desc:Samsung Electric Company LS24C33xG H9TX501846, 1920x1080@100, 0x0, 1"
        "desc:Samsung Electric Company LS24C33xG H9TX501795, 1920x1080@100, 1920x0, 1"
      ];

      general = {
        layout = "dwindle";
        border_size = 3;
        "col.active_border" = lib.mkDefault (gradient135 colors.base0B colors.base0C);
        "col.inactive_border" = lib.mkDefault (rgb colors.base03);
        gaps_in = 2;
        gaps_out = 8;
      };

      dwindle.preserve_split = true;

      group = {
        "col.border_active" = lib.mkDefault (gradient135 colors.base0D colors.base0C);
        "col.border_inactive" = lib.mkDefault (rgb colors.base03);
        "col.border_locked_active" = lib.mkDefault (gradient135 colors.base0A colors.base09);
        "col.border_locked_inactive" = lib.mkDefault (rgb colors.base03);
        groupbar = {
          font_size = 11;
          gradients = false;
        };
      };

      decoration = {
        rounding = lib.mkDefault 10;
        blur = {
          enabled = lib.mkDefault true;
          size = lib.mkDefault 3;
          passes = lib.mkDefault 1;
          new_optimizations = lib.mkDefault true;
        };
        shadow = {
          enabled = lib.mkDefault true;
          range = lib.mkDefault 4;
          render_power = lib.mkDefault 3;
          color = lib.mkDefault "rgba(1a1a1a80)";
          color_inactive = lib.mkDefault "rgba(00000060)";
        };
      };

      bind = [
        "$mainMod, RETURN, exec, $terminal"
        "$mainMod, E, exec, $fileManager"
        "$mainMod, A, exec, $menu"
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
      ];

      input.kb_layout = "pl";

      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
      };
    };
  };

  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
  };
}
