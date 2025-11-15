{ config, lib, pkgs, ... }:

{
  options.features.desktop.gnome = {
    enable = lib.mkEnableOption "GNOME desktop environment";
  };

  config = lib.mkIf config.features.desktop.gnome.enable {
    # Display manager
    services.displayManager.gdm = {
      enable = true;
      wayland = true;
      autoSuspend = lib.mkDefault true;
    };

    # Desktop environment
    services.desktopManager.gnome.enable = true;
    
    # GNOME has built-in bluetooth management, disable blueman
    features.hardware.bluetooth.enableBlueman = lib.mkDefault false;

    # Remove unwanted packages
    environment.gnome.excludePackages = with pkgs; [
      epiphany
      gnome-tour
    ];

    # GNOME-specific packages
    environment.systemPackages = with pkgs; [
      gnomeExtensions.appindicator
      gnome-settings-daemon
    ];

    # udev packages for GNOME
    services.udev.packages = with pkgs; [
      gnomeExtensions.appindicator
    ];
  };
}
