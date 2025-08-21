{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hyprland/default.nix
    ./waybar/default.nix
    ./zen-browser/default.nix
    ./git/default.nix
    ./spicetify-nix/default.nix
    ./dunst/default.nix
  ];

  home.username = "km";
  home.homeDirectory = "/home/km";
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    vscode
    hyprpolkitagent
  ];

  programs.home-manager.enable = true;

  # Enable Mako notification daemon for Wayland/Hyprland
  services.mako = {
    enable = true;
    settings = {
      background = "#222222E6";
      border_color = "#888888E6";
      text_color = "#FFFFFF";
      border_radius = 12;
      width = 350;
      height = 120;
      margin = "20,20,20,20";
      padding = "16";
      font = "JetBrains Mono 12";
      icons = true;
      animations = true;
      animation = "slide";
      fade_in = 0.3;
      fade_out = 0.3;
      slide_in = 0.2;
      slide_out = 0.2;
    };
  };
