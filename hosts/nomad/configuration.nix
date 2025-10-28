# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  # ===================================
  # Imports
  # ===================================
  imports = [
    ./hardware-configuration.nix
    ./modules/packages.nix
    ./modules/display.nix
    ./modules/audio.nix
    ./modules/services.nix
    ./modules/localization.nix
  ];

  # ===================================
  # Boot & system
  # ===================================
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ===================================
  # Nix & flakes
  # ===================================
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # ===================================
  # Hostname & networking
  # ===================================
  networking.hostName = "nomad";
  # Enable network manager
  networking.networkmanager.enable = true;

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
  # Package policy
  # ===================================
  nixpkgs.config.allowUnfree = true;

  # ===================================
  # Misc (comments preserved)
  # ===================================
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Open ports / firewall examples kept commented below
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # networking.firewall.enable = false; # disable firewall

  # ===================================
  # System state version
  # ===================================
  system.stateVersion = "25.05";

}
