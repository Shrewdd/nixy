{ config, pkgs, lib, ... }:

{
  # ===================================
  # DISPLAY MANAGEMENT
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
  
  # Enable GNOME Display Manager
  services.displayManager.gdm = {
    enable = true;
    wayland = true;
    autoSuspend = true;
  };
  # Enable GNOME Desktop Environment
  services.desktopManager.gnome.enable = true;

  # ===================================
  # INPUT CONFIGURATION
  # ===================================
  # Keyboard layout settings for X11 and console
  services.xserver.xkb.layout = "pl";
  services.xserver.xkb.variant = "";
  console.keyMap = "pl2";

}