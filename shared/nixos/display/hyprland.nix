{ config, pkgs, ... }:

{
  # Hyprland / Wayland-focused display module (minimal stub to enable Hyprland)
  programs.hyprland.enable = true;

  # Typical Wayland helpers; add packages here as needed per-host
  environment.systemPackages = with pkgs; [ wayland wayland-protocols ];
}
