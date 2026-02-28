# ── GNOME – desktop environment ─────────────────────────────────────────
#
# System-level GNOME shell, GDM, and related tweaks.  No user-side
# configuration needed — GNOME is opinionated enough on its own.
#
{
  lib,
  pkgs,
  ...
}: {

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
}
