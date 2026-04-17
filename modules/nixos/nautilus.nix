{
  lib,
  pkgs,
  ...
}: {
  # ── File services ────────────────────────────────────────────────
  services.gvfs.enable = lib.mkDefault true;
  services.udisks2.enable = lib.mkDefault true;

  # ── File manager tools ───────────────────────────────────────────
  environment.systemPackages = [
    pkgs.nautilus
    pkgs.file-roller
  ];
}
