{ config, pkgs, ... }:

{
  #######################
  # DISPLAY MANAGEMENT & GRAPHICS
  #######################

  # ===================================
  # GRAPHICS HARDWARE
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
  };

  # ===================================
  # DISPLAY MANAGER
  # ===================================
  # SDDM configuration
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

  # ===================================
  # WINDOW MANAGER (HYPRLAND)
  # ===================================
  # Hyprland Configuration
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  # ===================================
  # INPUT CONFIGURATION
  # ===================================
  # Keyboard layout settings for X11 and console
  services.xserver.xkb.layout = "pl";
  services.xserver.xkb.variant = "";
  console.keyMap = "pl2";
}