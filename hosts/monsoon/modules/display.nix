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

  # Enable SDDM with preset theme
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "sddm-astronaut-theme";
    package = pkgs.kdePackages.sddm;
    extraPackages = with pkgs; [
      qt6Packages.qtmultimedia
      qt6Packages.qtsvg
      qt6Packages.qtvirtualkeyboard
    ];
  };

  # Enable the COSMIC Desktop Environment
  services.desktopManager.cosmic.enable = true;
  # Enable NIRI Wayland compositor
  programs.niri.enable = true;

  # ===================================
  # INPUT CONFIGURATION
  # ===================================
  # Keyboard layout settings for X11 and console
  services.xserver.xkb.layout = "pl";
  services.xserver.xkb.variant = "";
  console.keyMap = "pl2";

}