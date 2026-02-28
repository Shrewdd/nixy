# ── Workstation – GNOME desktop profile ─────────────────────────────────
#
# Full desktop workstation: GNOME, audio, printing, user shell and apps.
# Pulls in everything a daily-driver GNOME machine needs — system and
# Home Manager included.
#
{...}: {

  # ════════════════════════════════════════════════════════════════════════
  # ── NixOS ──────────────────────────────────────────────────────────────
  # ════════════════════════════════════════════════════════════════════════

  imports = [
    ../system/core/base.nix
    ../system/core/boot.nix
    ./gnome.nix
    ../system/hardware/audio.nix
    ../system/hardware/bluetooth.nix
    ../system/services/flatpak.nix
    ../system/services/printing.nix
    ../system/packages/shared.nix
  ];

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
