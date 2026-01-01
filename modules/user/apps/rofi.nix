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
      prompt = "Search";
    };

    # Stylix provides the palette. This only tweaks layout/shape.
    theme = {
      window = {
        width = 700;
        padding = 18;
        border = 2;
        border-radius = 16;
        transparency = "real";
      };

      mainbox = {
        spacing = 12;
      };

      inputbar = {
        padding = 12;
        border-radius = 14;
      };

      entry = {
        padding = 6;
      };

      listview = {
        lines = 9;
        fixed-height = false;
        spacing = 6;
        scrollbar = false;
      };

      element = {
        padding = 12;
        border-radius = 12;
      };

      "element selected" = {
        border = 2;
        border-radius = 12;
      };
    };
  };
}
