{pkgs, ...}: {
  # ── Shared packages ───────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    nixd
    alejandra
    vscode
    onlyoffice-desktopeditors
    zapzap
    speedtest-cli
    tree
    fetch
    mission-center
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
