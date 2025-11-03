{ config, pkgs, inputs, ... }:

{
  imports = [
    ./../../../shared/home-manager/shared/default.nix
    ./../../../shared/home-manager/monsoon/default.nix
  ];

  home.username = "km";
  home.homeDirectory = "/home/km";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;
}