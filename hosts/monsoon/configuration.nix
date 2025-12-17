{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/profiles/desktop.nix
  ];

  networking.hostName = "monsoon";
  system.stateVersion = "25.05";

  # ===================================
  # Hardware Configuration - NVIDIA
  # ===================================
  services.xserver.videoDrivers = [ "nvidia" ];
  
  hardware.nvidia = {
    open = false;
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    package = config.boot.kernelPackages.nvidiaPackages.production;
    nvidiaSettings = true;
    prime = {
      sync.enable = true;
      nvidiaBusId = "PCI:1:0:0";
      intelBusId = "PCI:0:2:0";
    };
  };

  boot.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
  boot.blacklistedKernelModules = [ "nouveau" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  environment.variables = {
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    LIBVA_DRIVER_NAME = "nvidia";
  };

  # ===================================
  # System Configuration
  # ===================================
  features.system.boot.latestKernel = true;
  packages.monsoon.enable = true;

  # Hyprland (Wayland)
  features.desktop.hyprland.enable = true;
  features.desktop.plasma.enable = false;
  features.desktop.gnome.enable = false;

  # Roblox URL handlers so desktop portalsHyprland) can
  # resolve and open roblox-player/studio links correctly system-wide.
  xdg.mime.defaultApplications = {
    "x-scheme-handler/roblox-player" = "org.vinegarhq.Sober.desktop";
    "x-scheme-handler/roblox-studio" = "org.vinegarhq.Vinegar.desktop";
  };

  # ===================================
  # Home Manager (User Configuration)
  # ===================================
  home-manager.users.km = {
    imports = [ ../../modules/home-manager/profiles/desktop.nix ];

    # Host-specific packages
    home.packages = with pkgs; [ tree ];

    hm.desktop.gnome.enable = false;
    hm.desktop.hyprland.enable = true;
  };
}
