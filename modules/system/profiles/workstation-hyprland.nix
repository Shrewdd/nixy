{...}: {
  imports = [
    ../../stylix/theme-profiles.nix
    ../core/base.nix
    ../core/boot.nix
    ../../profiles/hyprland.nix
    ../apps/nautilus.nix
    ../hardware/audio.nix
    ../hardware/bluetooth.nix
    ../services/flatpak.nix
    ../services/printing.nix
    ../packages/shared.nix
  ];

  nixy.themeProfile.name = "rose-pine-dawn";

  security.sudo.wheelNeedsPassword = false;
}
