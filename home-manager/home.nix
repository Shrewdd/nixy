{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hyprland/default.nix
    ./waybar/default.nix
  ./zen-browser/default.nix
  ];

  home.username = "km";
  home.homeDirectory = "/home/km";
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    playerctl
    vscode
    hyprpolkitagent
  ];

  programs.home-manager.enable = true;
}
