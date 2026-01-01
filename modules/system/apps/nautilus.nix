{ lib, pkgs, ... }:
{
  services.gvfs.enable = lib.mkDefault true;
  services.udisks2.enable = lib.mkDefault true;

  environment.systemPackages = [
    pkgs.nautilus
  ];
}
