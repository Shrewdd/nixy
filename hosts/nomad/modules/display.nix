{ config, pkgs, ... }:

{
  # ===================================
  # DISPLAY MANAGEMENT & GNOME DESKTOP
  # ===================================

  # Enable the X11 windowing system
  services.xserver.enable = true;

  # Enable the GNOME Display Manager (GDM)
  services.displayManager.gdm.enable = true;

  # Enable the GNOME Desktop Environment
  services.desktopManager.gnome.enable = true;

  # Exclude unwanted GNOME apps
  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    epiphany
  ];

  # ===================================
  # INPUT CONFIGURATION
  # ===================================
  # Keyboard layout settings for X11 and console
  services.xserver.xkb = {
    layout = "pl";
    variant = "";
  };

  console.keyMap = "pl2";

}
