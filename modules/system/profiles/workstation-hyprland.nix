{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../../shared/stylix.nix
    ../../shared/theme-profiles.nix
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

  nixy.themeProfile.name = lib.mkDefault "catppuccin-latte";

  security.sudo.wheelNeedsPassword = false;
}
