{ config, pkgs, ... }:

{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      # High-contrast autosuggestions
      set -g fish_color_autosuggestion brcyan
    '';
  };
}
