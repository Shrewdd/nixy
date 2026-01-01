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
      show-icons = true;
      icon-theme = "Papirus-Dark";
      drun-display-format = "{name}";
      matching = "fuzzy";
      sort = true;
      sorting-method = "fzf";
      disable-history = true;
      steal-focus = true;
      dpi = 0;
      prompt = ">";
    };

    # Stylix provides the palette. This only tweaks layout/shape.
    theme = {
      window = {
        width = 600;
        padding = 8;
        border = 1;
        border-radius = 4;
        transparency = "real";
      };

      mainbox = {
        spacing = 6;
      };

      inputbar = {
        padding = 8;
        border-radius = 2;
      };

      prompt = {
        padding = 4;
      };

      entry = {
        padding = 4;
      };

      textbox-prompt-colon = {
        padding = 4;
      };

      listview = {
        lines = 7;
        fixed-height = false;
        spacing = 3;
        scrollbar = false;
      };

      element = {
        padding = 8;
        border-radius = 2;
        spacing = 10;
      };

      "element selected" = {
        border = 1;
        border-radius = 2;
      };

      "element-icon" = {
        size = 24;
      };
    };
  };
}
