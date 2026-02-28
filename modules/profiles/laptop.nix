# ── Laptop – portable workstation ───────────────────────────────────────
#
# Thin layer on top of the GNOME desktop profile that enables Stylix
# theming.  Host configs can override the theme name as needed.
#
{lib, ...}: {
  imports = [
    ../stylix/theme-profiles.nix
    ./gnome.nix
  ];

  nixy.stylix.enable = lib.mkDefault true;
}
