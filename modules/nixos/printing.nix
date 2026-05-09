{pkgs, ...}: {
  # ── Printing stack ───────────────────────────────────────────────
  services.printing = {
    enable = true;
    drivers = with pkgs; [epson-escpr2 gutenprint];
  };

  # ── Printer discovery ────────────────────────────────────────────
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
}
