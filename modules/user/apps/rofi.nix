{ pkgs, ... }:
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;

    # Keep it minimal: one mode, centered, tight.
    modes = [ "drun" ];
    location = "center";
    xoffset = 0;
    yoffset = 0;

    font = "JetBrainsMono Nerd Font 12";
    terminal = "ghostty";

    cycle = true;

    extraConfig = {
      modi = "drun";
      show-icons = false;
      drun-display-format = "{name}";
      matching = "fuzzy";
      sort = true;
      sorting-method = "normal";
      steal-focus = true;
      dpi = 0;
    };
  };
}
