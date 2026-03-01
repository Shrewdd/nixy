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

  nixy.themeProfile.name = "rose-pine-dawn";

  # ── Nvidia ─────────────────────────────────────────────────────────
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    open = false;
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    package = config.boot.kernelPackages.nvidiaPackages.production;
    nvidiaSettings = true;
  };

  boot.kernelModules = ["nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm"];
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

  # ── MIME & apps ────────────────────────────────────────────────────
  xdg.mime.defaultApplications = {
    "x-scheme-handler/roblox-player" = "org.vinegarhq.Sober.desktop";
    "x-scheme-handler/roblox-studio" = "org.vinegarhq.Vinegar.desktop";
  };

  environment.systemPackages = with pkgs; [
    vesktop
    sixpair
    lshw
    simple-scan
  ];

  programs.gamemode.enable = true;

  # ── Home Manager ───────────────────────────────────────────────────
  home-manager.users.km = {
    home.stateVersion = "25.11";
  };
}
