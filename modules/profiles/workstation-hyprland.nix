# ── Workstation (Hyprland) – tiling desktop profile ─────────────────────
#
# Same idea as the GNOME workstation, but built around Hyprland + the
# Caelestia shell instead.  Imports the merged Hyprland profile for both
# compositor and HM config, then layers user apps on top.
#
{...}: {

  # ════════════════════════════════════════════════════════════════════════
  # ── NixOS ──────────────────────────────────────────────────────────────
  # ════════════════════════════════════════════════════════════════════════

  imports = [
    ../stylix/theme-profiles.nix
    ../system/core/base.nix
    ../system/core/boot.nix
    ./hyprland.nix
    ../system/apps/nautilus.nix
    ../system/hardware/audio.nix
    ../system/hardware/bluetooth.nix
    ../system/services/flatpak.nix
    ../system/services/printing.nix
    ../system/packages/shared.nix
  ];

  nixy.themeProfile.name = "rose-pine-dawn";

  security.sudo.wheelNeedsPassword = false;

  # ════════════════════════════════════════════════════════════════════════
  # ── Home Manager (km) ──────────────────────────────────────────────────
  # ════════════════════════════════════════════════════════════════════════

  home-manager.users.km = {
    imports = [
      ../user/core/base.nix
      ../user/apps/ghostty.nix
      ../user/apps/zen.nix
      ../user/apps/spotify.nix
    ];
  };
}
