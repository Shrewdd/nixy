# ── Laptop – portable workstation ───────────────────────────────────────
#
# Thin layer on top of the GNOME workstation profile that enables Stylix
# theming.  Host configs can override the theme name as needed.
#
{lib, ...}: {
  imports = [
    ../stylix/theme-profiles.nix
    ./workstation.nix
  ];

  nixy.stylix.enable = lib.mkDefault true;
}
