# ── GNOME – complete desktop profile ─────────────────────────────────────
#
# Everything a GNOME workstation needs: shared system plumbing, the
# desktop shell, and Home Manager user config.  Import this from a
# host — it takes care of both halves.
#
{
  lib,
  pkgs,
  ...
}: {

  # ════════════════════════════════════════════════════════════════════════
  # ── NixOS ──────────────────────────────────────────────────────────────
  # ════════════════════════════════════════════════════════════════════════

  # ── Common desktop plumbing ──────────────────────────────────────────
  imports = [
    ../system/core/base.nix
    ../system/core/boot.nix
    ../system/hardware/audio.nix
    ../system/hardware/bluetooth.nix
    ../system/services/flatpak.nix
    ../system/services/printing.nix
    ../system/packages/shared.nix
  ];

  security.sudo.wheelNeedsPassword = false;

  # ── Display Manager ──────────────────────────────────────────────────
  services.displayManager.gdm = {
    enable      = true;
    wayland     = true;
    autoSuspend = lib.mkDefault true;
  };

  # ── GNOME shell ──────────────────────────────────────────────────────
  services.desktopManager.gnome.enable = true;
  services.blueman.enable = lib.mkForce false;

  # ── Trimmed default packages ─────────────────────────────────────────
  environment.gnome.excludePackages = with pkgs; [
    epiphany
    gnome-tour
    geary
    yelp
  ];

  # ── Extensions & helpers ─────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    gnomeExtensions.appindicator
    gnome-settings-daemon
  ];

  # ── Power & services ────────────────────────────────────────────────
  services.tlp.enable = lib.mkForce false;

  services.udev.packages = with pkgs; [gnomeExtensions.appindicator];

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
