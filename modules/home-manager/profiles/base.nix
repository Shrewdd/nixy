{ config, lib, pkgs, ... }:

{
  # Base profile - Essential user features for any account
  imports = [
    ../features/shell/zsh.nix
    ../features/shell/starship.nix
    ../features/shell/btop.nix
    ../features/shell/fastfetch.nix
    ../features/dev/git.nix
  ];

  # Enable base features
  hm = {
    shell = {
      zsh.enable = lib.mkDefault true;
      starship.enable = lib.mkDefault true;
      btop.enable = lib.mkDefault true;
      fastfetch.enable = lib.mkDefault true;
    };
    dev.git.enable = lib.mkDefault true;
  };

  # Home Manager settings
  programs.home-manager.enable = true;
  
  # User identity (same across all hosts)
  home = {
    username = lib.mkDefault "km";
    homeDirectory = lib.mkDefault "/home/km";
    stateVersion = lib.mkDefault "25.05";
  };
}
