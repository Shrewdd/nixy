{ lib, ... }:
{
  imports = [
    ../../shared/stylix.nix
    ./workstation.nix
    ../packages/nomad.nix
  ];

  nixy.stylix.enable = lib.mkDefault true;
}
