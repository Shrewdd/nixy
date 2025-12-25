{ pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;

    settings = {
      "$mod" = "SUPER";

      # Minimal, usable defaults.
      bind = [
        "$mod, Return, exec, ghostty"
        "$mod, R, exec, rofi -show drun"
        "$mod, Q, killactive"
        "$mod, M, exit"
        "$mod, F, fullscreen"
      ];

      input = {
        kb_layout = "pl";
      };

      misc = {
        disable_hyprland_logo = true;
      };
    };
  };

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
  };
}
