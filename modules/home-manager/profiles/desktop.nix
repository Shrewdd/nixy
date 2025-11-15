{ config, lib, pkgs, ... }:

{
  # Desktop profile - Common user apps for desktop environments
  imports = [
    ./base.nix
    ../features/desktop/gtk.nix
    ../features/desktop/gnome.nix
    ../features/apps/ghostty.nix
    ../features/apps/zen.nix
    ../features/apps/spotify.nix
    ../features/apps/anytype.nix
  ];

  # Enable desktop features and apps by default
  hm = {
    desktop = {
      gtk.enable = lib.mkDefault true;
      gnome.enable = lib.mkDefault true;
    };
    apps = {
      ghostty.enable = lib.mkDefault true;
      zen.enable = lib.mkDefault true;
      spotify.enable = lib.mkDefault true;
      anytype.enable = lib.mkDefault true;
    };
  };
}
