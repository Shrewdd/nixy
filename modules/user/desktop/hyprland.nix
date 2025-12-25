{ pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;

    settings = {
      "$mod" = "SUPER";

      monitor = [
        "HDMI-A-4,1920x1080@100,0x0,1"
        "HDMI-A-5,1920x1080@100,1920x0,1"
      ];

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
    package = pkgs.rofi;
  };
}
