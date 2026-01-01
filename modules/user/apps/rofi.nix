{ lib, pkgs, ... }:
{
  programs.rofi = {
    enable = true;

    # minimal
    modes = [ "drun" ];
    location = "center";
    xoffset = 0;
    yoffset = 0;
    font = lib.mkForce "JetBrainsMono Nerd Font 12";
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
