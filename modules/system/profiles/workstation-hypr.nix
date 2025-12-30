{ lib, ... }:
{
  imports = [
    ../../shared/stylix.nix
    ../core/base.nix
    ../core/boot.nix
    ../desktop/hyprland.nix
    ../apps/thunar.nix
    ../hardware/audio.nix
    ../hardware/bluetooth.nix
    ../services/flatpak.nix
    ../services/printing.nix
    ../packages/shared.nix
  ];

  nixy.stylix.enable = lib.mkDefault true;

  security.sudo.wheelNeedsPassword = false;
}
