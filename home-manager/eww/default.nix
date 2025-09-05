{ config, pkgs, ... }: let
  palette = {
    bg = "1a1b26";          # sophisticated dark background
    surface = "24283b";     # elevated professional surface
    text = "c0caf5";        # crisp professional white
    subtext = "a9b1d6";     # refined secondary text
    accent = "bb9af7";      # premium purple accent
    accentDark = "565f89";  # professional contrast
    border = "414868";      # refined borders
  };
  fontMain = "SF Pro Display, Inter, JetBrainsMono Nerd Font";
in {
  programs.eww = {
    enable = true;
    configDir = ./eww-config;
  };
}
