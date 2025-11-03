{ config, pkgs, ... }:

{
  imports = [
    ./niri/default.nix
    ./fuzzel/default.nix
  ];
}