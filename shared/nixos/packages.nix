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
  ];
}
