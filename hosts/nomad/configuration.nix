{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/profiles/laptop.nix
  ];

  networking.hostName = "nomad";
  system.stateVersion = "25.05";

  # ===================================
  # System Configuration
  # ===================================
  packages.nomad.enable = true;

  # ===================================
  # Home Manager (User Configuration)
  # ===================================
  home-manager.users.km = {
    imports = [ ../../modules/home-manager/profiles/desktop.nix ];

    # Host-specific packages
    home.packages = with pkgs; [ tree ];
  };
}
