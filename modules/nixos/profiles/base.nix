{ config, lib, pkgs, ... }:

{
  # Base profile - Essential system features for any machine
  imports = [
    ../features/system/nix.nix
    ../features/system/boot.nix
    ../features/system/networking.nix
    ../features/system/localization.nix
    ../features/packages.nix
  ];

  # Enable base features
  features.system = {
    nix.enable = lib.mkDefault true;
    boot.enable = lib.mkDefault true;
    networking.enable = lib.mkDefault true;
    localization.enable = lib.mkDefault true;
  };

  # Enable shared packages by default
  packages.shared.enable = lib.mkDefault true;

  # Define user (same across all hosts)
  users.users.km = {
    isNormalUser = true;
    description = "km";
    extraGroups = [ "networkmanager" "wheel" ];
  };
}
