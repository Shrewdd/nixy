{
  lib,
  pkgs,
  ...
}: {
  # ── Printing stack ───────────────────────────────────────────────
  services.printing = {
    enable = true;
    drivers = with pkgs; [gutenprint hplip];
  };

  # ── Printer discovery ────────────────────────────────────────────
  services.avahi = {
    enable = lib.mkDefault true;
    nssmdns4 = true;
    openFirewall = true;
  };
}
