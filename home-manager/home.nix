{ config, pkgs, ... }:
{

  imports = [
    ./spotify/default.nix
    ./hyprland/default.nix
    ./waybar/default.nix
  ];

  home.username = "km";
  home.homeDirectory = "/home/km";
  home.stateVersion = "25.05";
  # Home Manager Applications
  home.packages = with pkgs; [
    veracrypt
    playerctl
    vscode
    hyprpolkitagent
  ];

  programs.home-manager.enable = true;
}
