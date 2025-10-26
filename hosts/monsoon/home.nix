{ config, pkgs, inputs, ... }:

{
  imports = [
    ./../../home-manager/zen-browser/default.nix
    ./../../home-manager/git/default.nix
    ./../../home-manager/spotify/default.nix
    ./../../home-manager/shell/btop/default.nix
    ./../../home-manager/anytype/default.nix
    ./../../home-manager/shell/fish/default.nix
    ./../../home-manager/shell/fastfetch/default.nix
  ];

  home.username = "km";
  home.homeDirectory = "/home/km";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;
}
