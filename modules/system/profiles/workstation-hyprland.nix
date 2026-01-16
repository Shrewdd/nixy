{ lib, ... }:
{
  imports = [
    ../../shared/stylix.nix
    ../core/base.nix
    ../core/boot.nix
    ../desktop/hyprland.nix
    ../apps/nautilus.nix
    ../hardware/audio.nix
    ../hardware/bluetooth.nix
    ../services/flatpak.nix
    ../services/printing.nix
    ../packages/shared.nix
  ];

  nixy.stylix.enable = lib.mkDefault true;
  nixy.stylix.base16Scheme = lib.mkDefault (import ../../shared/theme/catppuccin-latte-base16.nix);

  security.sudo.wheelNeedsPassword = false;
}
