{ lib, ... }:
{
  imports = [
    ./nix.nix
    ./networking.nix
    ./localization.nix
  ];

  users.users.km = {
    isNormalUser = true;
    description = "km";
    extraGroups = [ "networkmanager" "wheel" ];
  };
}
