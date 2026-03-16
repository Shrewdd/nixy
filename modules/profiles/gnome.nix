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
    ../nixos/core.nix
    ../nixos/audio.nix
    ../nixos/bluetooth.nix
    ../nixos/flatpak.nix
    ../nixos/printing.nix
    ../nixos/packages.nix
  ];

  # ── Display Manager ──────────────────────────────────────────────────
  services.displayManager.gdm = {
    enable = true;
    wayland = true;
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
    gnome-console
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
      ../home/core.nix
      ../home/ghostty.nix
      ../home/zen.nix
      ../home/spotify.nix
    ];
  };
}
