{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./modules/display.nix
    ./modules/packages.nix
    ./modules/audio.nix
  ];

  #######################
  # Boot & System
  #######################
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # Use latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  #######################
  # Home Manager
  #######################
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "backup";

  #######################
  # Nix-Helper
  #######################
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/km/nixy";
  };

  #######################
  # Hostname & Networking
  #######################
  networking.hostName = "monsoon";
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

  #######################
  # Localization
  #######################
  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pl_PL.UTF-8";
    LC_IDENTIFICATION = "pl_PL.UTF-8";
    LC_MEASUREMENT = "pl_PL.UTF-8";
    LC_MONETARY = "pl_PL.UTF-8";
    LC_NAME = "pl_PL.UTF-8";
    LC_NUMERIC = "pl_PL.UTF-8";
    LC_PAPER = "pl_PL.UTF-8";
    LC_TELEPHONE = "pl_PL.UTF-8";
    LC_TIME = "pl_PL.UTF-8";
  };

  #######################
  # Users
  #######################
  users.users.km = {
    isNormalUser = true;
    description = "km";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ ];
  };

  #######################
  # Hardware
  #######################
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  #######################
  # Software Packages
  #######################
  nixpkgs.config.allowUnfree = true;

  #######################
  # Services & Programs
  #######################
  services.flatpak.enable = true;
  services.printing = {
    enable = true;
  };


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
