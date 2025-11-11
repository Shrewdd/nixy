{ config, pkgs, ... }:

{
  # GNOME desktop and display manager
  services.displayManager.gdm.enable = true;
  services.displayManager.gdm.wayland = true;
  services.displayManager.gdm.autoSuspend = true;

  # Enable GNOME desktop environment
  services.desktopManager.gnome.enable = true;

  # GNOME-related helpers (appindicator support is added via packages)
  environment.gnome.excludePackages = with pkgs; [ epiphany gnome-tour ];

  # GNOME-specific packages
  environment.systemPackages = with pkgs; [
    gnomeExtensions.appindicator
  ];
}
