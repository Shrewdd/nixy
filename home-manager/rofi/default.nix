{ pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    location = "center";
    font = "Maple Mono NF 10.5";
    extraConfig = {
      modi = "drun";
      show-icons = true;
      icon-theme = "Catppuccin-SE";
      matching = "normal";
    };
    theme = ./theme.rasi;
  };
}
