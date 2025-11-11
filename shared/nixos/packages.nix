{ config, pkgs, ... }:

{
  # Shared package groups and fonts used across hosts
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
  ];

  # Provide a small common package set; hosts can append their own packages.
  environment.systemPackages = with pkgs; [
    nixfmt
    vscode
    # gnomeExtensions.appindicator is GNOME-specific and belongs in the
    # GNOME display module rather than the shared packages list.
  ];

  # Common program settings used on multiple hosts
  programs.localsend = {
    enable = true;
    openFirewall = true;
  };

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/km/nixy";
  };

  programs.zoom-us = {
    enable = true;
  };
}
