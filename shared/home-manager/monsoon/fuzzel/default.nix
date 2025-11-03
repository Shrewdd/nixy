{ config, lib, ... }:

let
  theme = import ../../../theme/everforest.nix;
in
{
  # ===================================
  # FUZZEL APPLICATION LAUNCHER
  # ===================================

  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "JetBrains Mono:size=12";
        dpi-aware = "no";
        icon-theme = "Papirus-Dark";
        terminal = "ghostty";
        prompt = "❯ ";
      };
      colors = {
        background = "${theme.base}ff";
        text = "${theme.text}ff";
        match = "${theme.green}ff";
        selection = "${theme.surface1}ff";
        selection-text = "${theme.text}ff";
        border = "${theme.overlay1}ff";
      };
      border = {
        width = 2;
        radius = 8;
      };
    };
  };
}