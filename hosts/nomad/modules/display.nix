{ config, pkgs, ... }:

{
  ####################################
  # DISPLAY MANAGEMENT & GNOME DESKTOP
  ####################################

  # Enable the X11 windowing system
  services.xserver.enable = true;

  # Enable the GNOME Display Manager (GDM)
  services.xserver.displayManager.gdm.enable = true;

  # Enable the GNOME Desktop Environment
  services.xserver.desktopManager.gnome.enable = true;

  # Exclude unwanted GNOME apps
  environment.gnome.excludePackages = with pkgs.gnome; [
    gnome-tour
  ];

  # Keyboard layout settings for X11 and console
  services.xserver.xkb = {
    layout = "pl";
    variant = "";
  };
  
  console.keyMap = "pl2";
}
