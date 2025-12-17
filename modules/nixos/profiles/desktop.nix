{ config, lib, pkgs, ... }:

{
  # Desktop profile - Common features for desktop machines
  imports = [
    ./base.nix
    ../features/desktop/gnome.nix
    ../features/desktop/plasma.nix
    ../features/desktop/hyprland.nix
    ../features/hardware/audio.nix
    ../features/hardware/bluetooth.nix
    ../features/services/printing.nix
    ../features/services/flatpak.nix
  ];

  # Enable desktop features by default
  features = {
    desktop.gnome.enable = lib.mkDefault true;
    hardware = {
      audio.enable = lib.mkDefault true;
      bluetooth.enable = lib.mkDefault true;
    };
    services = {
      printing.enable = lib.mkDefault true;
      flatpak.enable = lib.mkDefault true;
    };
  };
}
