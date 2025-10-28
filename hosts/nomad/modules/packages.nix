{ pkgs, ... }:

{
  # ===================================
  # SYSTEM PACKAGES
  # ===================================
  environment.systemPackages = with pkgs; [
    librewolf                  # browser
    vscode                     # code editor
    ghostty                    # terminal
    gnomeExtensions.appindicator # system tray extension
  ];

  # ===================================
  # PROGRAMS WITH OPTIONS
  # ===================================
  programs.localsend = {
    enable = true;
    openFirewall = true;
  };

  programs.git = {
    enable = true;
  };

  programs.zoom-us = {
    enable = true;
  };

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/km/nixy";
  };

}