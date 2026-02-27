{lib, ...}: {
  imports = [
    ../../shared/stylix/theme-profiles.nix
    ../core/base.nix
    ../core/boot.nix
    ../core/specialisations.nix
    ../desktop/hyprland.nix
    ../apps/nautilus.nix
    ../hardware/audio.nix
    ../hardware/bluetooth.nix
    ../services/flatpak.nix
    ../services/printing.nix
    ../packages/shared.nix
  ];

  nixy.themeProfile.name = lib.mkDefault "rose-pine-dawn";

  security.sudo.wheelNeedsPassword = false;
}
