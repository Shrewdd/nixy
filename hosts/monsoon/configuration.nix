{ config, pkgs, ... }:

{
  # ===================================
  # Imports
  # ===================================
  imports = [
    ./hardware-configuration.nix
  ../../shared/nixos/display/common.nix
  ../../shared/nixos/display/gnome.nix
  ./modules/nvidia.nix
    ../../shared/nixos/packages.nix
    ./modules/packages.nix
    ../../shared/nixos/audio.nix
    ../../shared/nixos/services/printing.nix
    ../../shared/nixos/services/avahi.nix
    ../../shared/nixos/localization.nix
    ./modules/flatpak.nix
  ];

  # ===================================
  # Boot & Kernel
  # ===================================
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # Use latest kernel packages
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # ===================================
  # Nix & flakes
  # ===================================
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # ===================================
  # Home Manager
  # ===================================
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "backup";

  # ===================================
  # Hostname & Networking
  # ===================================
  networking.hostName = "monsoon";
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

  # ===================================
  # Users
  # ===================================
  users.users.km = {
    isNormalUser = true;
    description = "km";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ tree ];
  };

  # ===================================
  # Hardware
  # ===================================
  hardware.bluetooth.enable = true;

  # Host-specific udev packages (GNOME appindicator integration)
  services.udev.packages = with pkgs; [ gnomeExtensions.appindicator ];

  # ===================================
  # Software policy
  # ===================================
  nixpkgs.config.allowUnfree = true;

  xdg.mime.defaultApplications = {
    "x-scheme-handler/roblox-player" = "org.vinegarhq.Sober.desktop";
    "x-scheme-handler/roblox-studio" = "org.vinegarhq.Vinegar.desktop";
  };


  # ===================================
  # System state version
  # ===================================
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  system.stateVersion = "25.05";

}
