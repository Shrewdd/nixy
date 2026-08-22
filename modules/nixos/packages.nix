{pkgs, ...}: {
  # ── Shared packages ───────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    onlyoffice-desktopeditors
    speedtest-cli
    tree
    simple-scan
    fastfetch
    anytype
  ];

  # ── Services ──────────────────────────────────────────────────────
  programs.localsend = {
    enable = true;
    openFirewall = true;
  };

  # ── Programs ──────────────────────────────────────────────────────
  programs.nh = {
    enable = true;
    flake = "/home/km/nixy";
  };
}
