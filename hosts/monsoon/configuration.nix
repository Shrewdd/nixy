{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/profiles/hyprland.nix
  ];

  networking.hostName = "monsoon";
  system.stateVersion = "25.11";

  # ── Nvidia ─────────────────────────────────────────────────────────
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    open = false;
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
    nvidiaSettings = false;
  };

  boot.blacklistedKernelModules = ["nouveau"];
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

  environment.systemPackages = with pkgs; [
    vesktop
    sixpair
  ];

  # ── Home Manager ───────────────────────────────────────────────────
  home-manager.users.km = {
    home.stateVersion = "25.11";
  };
}
