{pkgs, ...}: {
  # ── Fonts ─────────────────────────────────────────────────────────
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
  ];

  # ── Shared packages ───────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    nixd
    alejandra
    apostrophe
    anytype
    vscode
    zapzap
    speedtest-cli
    tree
    tree-sitter
  ];

  # ── Services ──────────────────────────────────────────────────────
  programs.localsend = {
    enable = true;
    openFirewall = true;
  };

  # ── Programs ──────────────────────────────────────────────────
  programs.nh = {
    enable = true;
    flake = "/home/km/nixy";
  };
}
