{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/profiles/monsoon-niri.nix
  ];

  networking.hostName = "monsoon";
  system.stateVersion = "25.05";

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
  boot.kernelPackages = pkgs.linuxPackages_latest;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  environment.variables = {
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    LIBVA_DRIVER_NAME = "nvidia";
  };

  xdg.mime.defaultApplications = {
    "x-scheme-handler/roblox-player" = "org.vinegarhq.Sober.desktop";
    "x-scheme-handler/roblox-studio" = "org.vinegarhq.Vinegar.desktop";
  };

  home-manager.users.km = {
    imports = [ ../../modules/user/profiles/monsoon-niri.nix ];
    home.packages = with pkgs; [ tree ];
  };
}
