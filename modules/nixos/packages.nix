{pkgs, ...}: {
  # ── Fonts ─────────────────────────────────────────────────────────
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # ── Shared packages ───────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    nixd
    alejandra
    apostrophe
    vscode
    zapzap
    speedtest-cli
    tree
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
