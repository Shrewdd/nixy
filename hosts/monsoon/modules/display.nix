{ config, pkgs, lib, ... }:

{
  # ===================================
  # DISPLAY MANAGEMENT & GNOME DESKTOP
  # ===================================

  # Enable graphics support and NVIDIA drivers
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  # NVIDIA-specific configuration
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    prime = {
      sync.enable = true;
      nvidiaBusId = "PCI:1:0:0";
      intelBusId = "PCI:0:2:0";
    };
  };

  # Enable the COSMIC Display Manager (Cosmic greeter)
  services.displayManager.cosmic-greeter.enable = true;

  # Enable the COSMIC Desktop Environment
  services.desktopManager.cosmic.enable = true;


  # ===================================
  # INPUT CONFIGURATION
  # ===================================
  # Keyboard layout settings for X11 and console
  services.xserver.xkb.layout = "pl";
  services.xserver.xkb.variant = "";
  console.keyMap = "pl2";

}